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
	query := `SELECT id, code, name, community_id AS communityid, sector_id AS sectorid, 
	          connection_type AS connectiontype, tariff, meter_number AS meternumber,
	          latitude, longitude, last_reading_value AS lastreadingvalue, initial_reading
	          FROM customers WHERE code = $1`
	err := r.db.GetContext(ctx, &customer, query, code)
	if err != nil {
		return nil, fmt.Errorf("error getting customer by code: %w", err)
	}
	return &customer, nil
}

func (r *PostgresCustomerRepository) GetByID(ctx context.Context, id string) (*domain.Customer, error) {
	var customer domain.Customer
	query := `SELECT id, code, name, community_id AS communityid, sector_id AS sectorid, 
	          connection_type AS connectiontype, tariff, meter_number AS meternumber,
	          latitude, longitude, last_reading_value AS lastreadingvalue, initial_reading
	          FROM customers WHERE id = $1`
	err := r.db.GetContext(ctx, &customer, query, id)
	if err != nil {
		return nil, fmt.Errorf("error getting customer by id: %w", err)
	}
	return &customer, nil
}

func (r *PostgresCustomerRepository) ListAll(ctx context.Context) ([]domain.Customer, error) {
	var customers []domain.Customer
	query := `SELECT id, code, name, community_id AS communityid, sector_id AS sectorid, 
	          connection_type AS connectiontype, tariff, meter_number AS meternumber,
	          latitude, longitude, last_reading_value AS lastreadingvalue, initial_reading
	          FROM customers ORDER BY code ASC`
	err := r.db.SelectContext(ctx, &customers, query)
	if err != nil {
		return nil, fmt.Errorf("error listing customers: %w", err)
	}
	return customers, nil
}

func (r *PostgresCustomerRepository) SaveBatch(ctx context.Context, customers []domain.Customer) error {
	query := `INSERT INTO customers (id, code, name, community_id, sector_id, connection_type, tariff, meter_number, latitude, longitude, last_reading_value, initial_reading) 
	          VALUES (:id, :code, :name, :communityid, :sectorid, :connectiontype, :tariff, :meternumber, :latitude, :longitude, :lastreadingvalue, :initial_reading) 
	          ON CONFLICT (id) DO UPDATE SET 
	          code = EXCLUDED.code, name = EXCLUDED.name, community_id = EXCLUDED.community_id, 
	          sector_id = EXCLUDED.sector_id, connection_type = EXCLUDED.connection_type, 
	          tariff = EXCLUDED.tariff, meter_number = EXCLUDED.meter_number,
	          latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, 
	          last_reading_value = EXCLUDED.last_reading_value,
	          initial_reading = EXCLUDED.initial_reading`
	_, err := r.db.NamedExecContext(ctx, query, customers)
	return err
}
