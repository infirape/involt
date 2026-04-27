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
	query := `SELECT id, customer_id AS customerid, previous_value AS previousvalue, current_value AS currentvalue, 
	          consumption, photo_url AS photourl, timestamp, latitude, longitude, 
	          cargo_fijo AS cargofijo, alumbrado_publico AS alumbradopublico, 
	          saldo_redondeo AS saldoredondeo, total_to_pay AS totaltopay 
	          FROM readings WHERE customer_id = $1 ORDER BY timestamp DESC`
	err := r.db.SelectContext(ctx, &readings, query, customerID)
	if err != nil {
		return nil, fmt.Errorf("error listing readings for customer: %w", err)
	}
	return readings, nil
}

func (r *PostgresReadingRepository) GetLatestByCustomer(ctx context.Context, customerID string) (*domain.Reading, error) {
	var reading domain.Reading
	query := `SELECT id, customer_id AS customerid, previous_value AS previousvalue, current_value AS currentvalue, 
	          consumption, photo_url AS photourl, timestamp, latitude, longitude, 
	          cargo_fijo AS cargofijo, alumbrado_publico AS alumbradopublico, 
	          saldo_redondeo AS saldoredondeo, total_to_pay AS totaltopay 
	          FROM readings WHERE customer_id = $1 ORDER BY timestamp DESC LIMIT 1`
	err := r.db.GetContext(ctx, &reading, query, customerID)
	if err != nil {
		return nil, fmt.Errorf("error getting latest reading: %w", err)
	}
	return &reading, nil
}
