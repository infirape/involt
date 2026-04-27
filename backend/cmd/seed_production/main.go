package main

import (
	"context"
	"database/sql"
	"encoding/csv"
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"

	_ "github.com/lib/pq"
)

func main() {
	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		connStr = "postgres://involt_user:involt_password@db:5432/involt_db?sslmode=disable"
	}
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	ctx := context.Background()

	// 1. Clean up
	fmt.Println("🧹 Cleaning up old data...")
	_, err = db.ExecContext(ctx, "TRUNCATE readings, customers, sectors, communities RESTART IDENTITY CASCADE")
	if err != nil {
		log.Fatal(err)
	}

	// 2. Parse Cleaned CSV
	fmt.Println("📊 Seeding from cleaned CSV...")
	file, err := os.Open("/Users/hbs/Documents/infira/involt/docs/cleaned_customers.csv")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		log.Fatal(err)
	}

	communityMap := make(map[string]string) // Name -> ID
	sectorMap := make(map[string]string)    // Name -> ID
	
	// Chetilla Center
	baseLat := -7.1470
	baseLng := -78.6727
	r := rand.New(rand.NewSource(time.Now().UnixNano()))

	count := 0
	for i, record := range records {
		if i == 0 { // Skip header
			continue
		}
		
		name := record[1]
		code := record[2]
		commName := record[3]
		
		if commName == "" {
			commName = "GENERAL"
		}

		// Handle Community
		commID, ok := communityMap[commName]
		if !ok {
			commID = fmt.Sprintf("COM-%03d", len(communityMap)+1)
			_, err = db.ExecContext(ctx, "INSERT INTO communities (id, name) VALUES ($1, $2)", commID, commName)
			if err != nil {
				log.Fatal(err)
			}
			communityMap[commName] = commID
			
			// Handle Sector
			secID := fmt.Sprintf("SEC-%03d", len(sectorMap)+1)
			_, err = db.ExecContext(ctx, "INSERT INTO sectors (id, community_id, name) VALUES ($1, $2, $3)", secID, commID, commName+" Centro")
			if err != nil {
				log.Fatal(err)
			}
			sectorMap[commName] = secID
		}
		
		secID := sectorMap[commName]
		custID := fmt.Sprintf("CUST-%s", code)
		
		// Random dispersion (approx 5km for full registry)
		lat := baseLat + (r.Float64()-0.5)*0.08
		lng := baseLng + (r.Float64()-0.5)*0.08
		lastVal := 100.0 + r.Float64()*500.0

		_, err = db.ExecContext(ctx, `
			INSERT INTO customers (id, code, name, community_id, sector_id, connection_type, tariff, meter_number, latitude, longitude, last_reading_value)
			VALUES ($1, $2, $3, $4, $5, 'MONOFASICA', 0.85, $6, $7, $8, $9)`,
			custID, code, name, commID, secID, "MET-"+code, lat, lng, lastVal)
		if err != nil {
			log.Printf("⚠️ Error inserting customer %s: %v", code, err)
			continue
		}

		// Seed historical reading for first 50
		if count < 50 {
			readingID := fmt.Sprintf("hist-%s", custID)
			_, err = db.ExecContext(ctx, `
				INSERT INTO readings (id, customer_id, previous_value, current_value, consumption, photo_url, timestamp, latitude, longitude, cargo_fijo, alumbrado_publico, saldo_redondeo, total_to_pay)
				VALUES ($1, $2, $3, $4, $5, '', $6, $7, $8, 6.45, 1.20, 0.0, $9)`,
				readingID, custID, lastVal-20.0, lastVal, 20.0, time.Now().Add(-24*time.Hour), lat, lng, 15.50)
			if err != nil {
				log.Fatal(err)
			}
		}
		count++
	}

	fmt.Printf("✅ Seeding complete! Processed %d customers in %d communities.\n", count, len(communityMap))
}
