package main

import (
	"log"
	"net/http"
	"os"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	"github.com/infira/involt/backend/internal/adapters/handlers"
	"github.com/infira/involt/backend/internal/adapters/pdf"
	"github.com/infira/involt/backend/internal/adapters/repositories"
	"github.com/infira/involt/backend/internal/gen/involt/v1/involtv1connect"
)

func main() {
	// 1. Database Connection
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		dbURL = "postgres://involt_user:involt_password@localhost:5432/involt_db?sslmode=disable"
	}

	db, err := sqlx.Connect("postgres", dbURL)
	if err != nil {
		log.Fatalf("❌ Database connection failed: %v", err)
	}
	defer db.Close()
	log.Println("🐘 Connected to PostgreSQL")

	// 2. Initialize Repositories
	metaRepo := repositories.NewPostgresMetadataRepository(db)
	customerRepo := repositories.NewPostgresCustomerRepository(db)
	readingRepo := repositories.NewPostgresReadingRepository(db)
	pdfGen := pdf.NewMarotoGenerator()

	// 3. Initialize Handlers
	syncHandler := handlers.NewSyncHandler(metaRepo, customerRepo, readingRepo, pdfGen)

	// 4. Setup Mux
	mux := http.NewServeMux()
	path, handler := involtv1connect.NewSyncServiceHandler(syncHandler)
	mux.Handle(path, handler)

	// 5. Start Server with h2c (HTTP/2 Cleartext)
	log.Println("🚀 InVolt Backend running on http://localhost:8080")
	err = http.ListenAndServe(
		"0.0.0.0:8080",
		h2c.NewHandler(mux, &http2.Server{}),
	)
	if err != nil {
		log.Fatalf("❌ Server failed: %v", err)
	}
}
