package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"connectrpc.com/connect"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	"github.com/infira/involt/backend/cmd/admin"
	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/adapters/handlers"
	"github.com/infira/involt/backend/internal/adapters/pdf"
	"github.com/infira/involt/backend/internal/adapters/repositories"
	"github.com/infira/involt/backend/internal/gen/involt/v1/involtv1connect"
	"github.com/rs/cors"
)

func main() {
	// 1. Database Connection
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		dbURL = "postgres://involt_user:involt_password@localhost:5432/involt_db?sslmode=disable"
	}

	var db *sqlx.DB
	var err error
	for i := 0; i < 5; i++ {
		db, err = sqlx.Connect("postgres", dbURL)
		if err == nil {
			break
		}
		log.Printf("⚠️  Database connection failed (attempt %d/5): %v. Retrying in 2s...", i+1, err)
		time.Sleep(2 * time.Second)
	}

	if err != nil {
		log.Fatalf("❌ Database connection failed after 5 attempts: %v", err)
	}
	defer db.Close()
	log.Println("🐘 Connected to PostgreSQL")

	// 2. Initialize Repositories
	metaRepo := repositories.NewPostgresMetadataRepository(db)
	customerRepo := repositories.NewPostgresCustomerRepository(db)
	readingRepo := repositories.NewPostgresReadingRepository(db)
	settingsRepo := repositories.NewSettingsRepository(db)
	adminRepo := repositories.NewPostgresAdminRepository(db)
	pdfGen := pdf.NewMarotoGenerator()

	// 3. Initialize Handlers
	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		jwtSecret = "super-secret-key-change-me-in-prod"
	}

	syncHandler := handlers.NewSyncHandler(metaRepo, customerRepo, readingRepo, pdfGen)
	settingsHandler := handlers.NewSettingsHandler(settingsRepo)
	adminSvcHandler := handlers.NewAdminHandler(adminRepo, metaRepo, customerRepo, readingRepo, jwtSecret)
	adminHandler := admin.NewAdminHandler(settingsRepo, customerRepo, readingRepo, metaRepo, pdfGen)

	// 4. Setup Mux
	mux := http.NewServeMux()

	// ConnectRPC endpoints
	path, handler := involtv1connect.NewSyncServiceHandler(syncHandler)
	mux.Handle(path, handler)

	authInterceptor := auth.NewAuthInterceptor(auth.NewJWTService(jwtSecret))
	adminPath, adminHandlerRPC := involtv1connect.NewAdminServiceHandler(
		adminSvcHandler,
		connect.WithInterceptors(authInterceptor),
	)
	mux.Handle(adminPath, adminHandlerRPC)

	// REST endpoints for settings
	mux.HandleFunc("/api/settings", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			settingsHandler.GetSettings(w, r)
		case http.MethodPut:
			settingsHandler.UpdateSettings(w, r)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	// Root redirect — apunta directo a /admin/ para evitar el doble redirect de ServeMux
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/" {
			// Respetar el proto que manda Caddy para que el Location sea https:// en prod
			proto := r.Header.Get("X-Forwarded-Proto")
			if proto == "" {
				proto = "http"
			}
			target := proto + "://" + r.Host + "/admin/"
			http.Redirect(w, r, target, http.StatusFound)
			return
		}
		http.NotFound(w, r)
	})

	// Admin dashboard with HTMX
	mux.Handle("/admin/", adminHandler)
	assetsDir := resolveAssetsDir()
	log.Printf("🖼️ Serving assets from %s at /assets/", assetsDir)
	mux.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir(assetsDir))))

	// 5. Start Server with h2c (HTTP/2 Cleartext) and CORS
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"http://localhost:3000", "http://localhost:3001"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Connect-Protocol-Version", "Content-Type", "Authorization"},
		ExposedHeaders:   []string{"Connect-Protocol-Version"},
		AllowCredentials: true,
	})

	log.Println("🚀 InVolt Backend running on http://localhost:8080")
	err = http.ListenAndServe(
		"0.0.0.0:8080",
		c.Handler(h2c.NewHandler(mux, &http2.Server{})),
	)
	if err != nil {
		log.Fatalf("❌ Server failed: %v", err)
	}
}

func resolveAssetsDir() string {
	candidates := []string{
		"../assets",   // running from /backend
		"assets",      // running from project root
		"../../assets", // fallback when running from /backend/cmd/server
	}

	for _, candidate := range candidates {
		info, err := os.Stat(candidate)
		if err == nil && info.IsDir() {
			return candidate
		}
	}

	return "../assets"
}
