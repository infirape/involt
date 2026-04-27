package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresCustomerRepository struct {
	db *sqlx.DB
}

func NewPostgresCustomerRepository(db *sqlx.DB) *PostgresCustomerRepository {
	return &PostgresCustomerRepository{db: db}
}

func (r *PostgresCustomerRepository) GetByCode(ctx context.Context, code string) (*domain.Customer, error) {
	var customer domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, last_reading_value
	          FROM customers WHERE code = $1`
	err := r.db.GetContext(ctx, &customer, query, code)
	if err != nil {
		return nil, fmt.Errorf("error getting customer by code: %w", err)
	}
	return &customer, nil
}

func (r *PostgresCustomerRepository) GetByID(ctx context.Context, id string) (*domain.Customer, error) {
	var customer domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, last_reading_value
	          FROM customers WHERE id = $1`
	err := r.db.GetContext(ctx, &customer, query, id)
	if err != nil {
		return nil, fmt.Errorf("error getting customer by id: %w", err)
	}
	return &customer, nil
}

func (r *PostgresCustomerRepository) ListAll(ctx context.Context) ([]domain.Customer, error) {
	var customers []domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, last_reading_value
	          FROM customers ORDER BY code ASC`
	err := r.db.SelectContext(ctx, &customers, query)
	if err != nil {
		return nil, fmt.Errorf("error listing customers: %w", err)
	}
	return customers, nil
}

func (r *PostgresCustomerRepository) SaveBatch(ctx context.Context, customers []domain.Customer) error {
	query := `INSERT INTO customers (
				id, code, name, community_id, sector_id, connection_type, 
				tariff, meter_number, latitude, longitude, initial_reading, last_reading_value
			  ) 
	          VALUES (
				:id, :code, :name, :community_id, :sector_id, :connection_type, 
				:tariff, :meter_number, :latitude, :longitude, :initial_reading, :last_reading_value
			  ) 
	          ON CONFLICT (id) DO UPDATE SET 
	          code = EXCLUDED.code, name = EXCLUDED.name, community_id = EXCLUDED.community_id, 
	          sector_id = EXCLUDED.sector_id, connection_type = EXCLUDED.connection_type, 
	          tariff = EXCLUDED.tariff, meter_number = EXCLUDED.meter_number,
	          latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, 
	          initial_reading = EXCLUDED.initial_reading,
			  last_reading_value = EXCLUDED.last_reading_value`
	_, err := r.db.NamedExecContext(ctx, query, customers)
	return err
}
func (r *PostgresCustomerRepository) CountBySector(ctx context.Context, sectorID string) (int, error) {
	var count int
	query := `SELECT COUNT(*) FROM customers WHERE sector_id = $1`
	err := r.db.GetContext(ctx, &count, query, sectorID)
	return count, err
}
