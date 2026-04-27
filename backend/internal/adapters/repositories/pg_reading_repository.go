package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresReadingRepository struct {
	db *sqlx.DB
}

func NewPostgresReadingRepository(db *sqlx.DB) *PostgresReadingRepository {
	return &PostgresReadingRepository{db: db}
}

func (r *PostgresReadingRepository) Save(ctx context.Context, reading *domain.Reading) error {
	query := `INSERT INTO readings (id, customer_id, previous_value, current_value, consumption, photo_url, timestamp, latitude, longitude, cargo_fijo, alumbrado_publico, saldo_redondeo, total_to_pay) 
	          VALUES (:id, :customerid, :previousvalue, :currentvalue, :consumption, :photourl, :timestamp, :latitude, :longitude, :cargofijo, :alumbradopublico, :saldoredondeo, :totaltopay) 
	          ON CONFLICT (id) DO NOTHING`
	_, err := r.db.NamedExecContext(ctx, query, reading)
	return err
}

func (r *PostgresReadingRepository) ListByCustomer(ctx context.Context, customerID string) ([]domain.Reading, error) {
	var readings []domain.Reading
	query := `SELECT * FROM readings WHERE customer_id = $1 ORDER BY timestamp DESC`
	err := r.db.SelectContext(ctx, &readings, query, customerID)
	if err != nil {
		return nil, fmt.Errorf("error listing readings for customer: %w", err)
	}
	return readings, nil
}

func (r *PostgresReadingRepository) GetLatestByCustomer(ctx context.Context, customerID string) (*domain.Reading, error) {
	var reading domain.Reading
	query := `SELECT * FROM readings WHERE customer_id = $1 ORDER BY timestamp DESC LIMIT 1`
	err := r.db.GetContext(ctx, &reading, query, customerID)
	if err != nil {
		return nil, fmt.Errorf("error getting latest reading: %w", err)
	}
	return &reading, nil
}

func (r *PostgresReadingRepository) GetByID(ctx context.Context, id string) (*domain.Reading, error) {
	var reading domain.Reading
	query := `SELECT * FROM readings WHERE id = $1`
	err := r.db.GetContext(ctx, &reading, query, id)
	if err != nil {
		return nil, fmt.Errorf("error getting reading by id: %w", err)
	}
	return &reading, nil
}

func (r *PostgresReadingRepository) ListBySectorAndPeriod(ctx context.Context, sectorID string, start, end string) ([]domain.Reading, error) {
	var readings []domain.Reading
	query := `SELECT r.* FROM readings r
              JOIN customers c ON r.customer_id = c.id
              WHERE c.sector_id = $1 AND r.timestamp >= $2 AND r.timestamp <= $3
              ORDER BY r.timestamp DESC`
	err := r.db.SelectContext(ctx, &readings, query, sectorID, start, end)
	if err != nil {
		return nil, fmt.Errorf("error listing readings by sector and period: %w", err)
	}
	return readings, nil
}

func (r *PostgresReadingRepository) CountCurrentMonth(ctx context.Context) (int, error) {
	var count int
	query := `SELECT COUNT(*) FROM readings WHERE timestamp >= date_trunc('month', now())`
	err := r.db.GetContext(ctx, &count, query)
	return count, err
}

func (r *PostgresReadingRepository) CountPendingCurrentMonth(ctx context.Context) (int, error) {
	var count int
	query := `SELECT COUNT(*) FROM customers c 
	          WHERE NOT EXISTS (
	              SELECT 1 FROM readings r 
	              WHERE r.customer_id = c.id 
	              AND r.timestamp >= date_trunc('month', now())
	          )`
	err := r.db.GetContext(ctx, &count, query)
	return count, err
}
