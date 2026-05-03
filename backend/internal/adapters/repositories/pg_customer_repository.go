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
	query := `SELECT id, code, name, community_id, sector_id, address, 
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
	query := `SELECT id, code, name, community_id, sector_id, address, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, last_reading_value
	          FROM customers WHERE id = $1`
	err := r.db.GetContext(ctx, &customer, query, id)
	if err != nil {
		return nil, fmt.Errorf("error getting customer by id: %w", err)
	}
	return &customer, nil
}

func (r *PostgresCustomerRepository) List(ctx context.Context, allowedSectorIDs []string, searchQuery string, limit, offset int) ([]domain.Customer, int, error) {
	var customers []domain.Customer
	var total int

	where := "1=1"
	args := map[string]interface{}{
		"limit":  limit,
		"offset": offset,
	}

	if len(allowedSectorIDs) > 0 {
		where += " AND sector_id IN (:allowed_sector_ids)"
		args["allowed_sector_ids"] = allowedSectorIDs
	}

	if searchQuery != "" {
		where += " AND (name ILIKE :search OR code ILIKE :search)"
		args["search"] = "%" + searchQuery + "%"
	}

	// Use sqlx.Named and sqlx.In for complex queries
	countQuery, countArgs, err := sqlx.Named(fmt.Sprintf("SELECT COUNT(*) FROM customers WHERE %s", where), args)
	if err != nil {
		return nil, 0, err
	}
	countQuery, countArgs, err = sqlx.In(countQuery, countArgs...)
	if err != nil {
		return nil, 0, err
	}
	countQuery = r.db.Rebind(countQuery)
	err = r.db.GetContext(ctx, &total, countQuery, countArgs...)
	if err != nil {
		return nil, 0, err
	}

	// Get paginated data
	selectQuery, selectArgs, err := sqlx.Named(fmt.Sprintf(`SELECT id, code, name, community_id, sector_id, address, 
	          connection_type, tariff, meter_number,
	          latitude, longitude, initial_reading, last_reading_value
	          FROM customers WHERE %s ORDER BY code ASC LIMIT :limit OFFSET :offset`, where), args)
	if err != nil {
		return nil, 0, err
	}
	selectQuery, selectArgs, err = sqlx.In(selectQuery, selectArgs...)
	if err != nil {
		return nil, 0, err
	}
	selectQuery = r.db.Rebind(selectQuery)
	err = r.db.SelectContext(ctx, &customers, selectQuery, selectArgs...)
	if err != nil {
		return nil, 0, err
	}

	return customers, total, nil
}

func (r *PostgresCustomerRepository) ListAll(ctx context.Context) ([]domain.Customer, error) {
	var customers []domain.Customer
	query := `SELECT id, code, name, community_id, sector_id, address, 
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
				id, code, name, community_id, sector_id, address, connection_type, 
				tariff, meter_number, latitude, longitude, initial_reading, last_reading_value
			  ) 
	          VALUES (
				:id, :code, :name, :community_id, :sector_id, :address, :connection_type, 
				:tariff, :meter_number, :latitude, :longitude, :initial_reading, :last_reading_value
			  ) 
	          ON CONFLICT (id) DO UPDATE SET 
	          code = EXCLUDED.code, name = EXCLUDED.name, community_id = EXCLUDED.community_id, 
	          sector_id = EXCLUDED.sector_id, address = EXCLUDED.address, connection_type = EXCLUDED.connection_type, 
	          tariff = EXCLUDED.tariff, meter_number = EXCLUDED.meter_number,
	          latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, 
	          initial_reading = EXCLUDED.initial_reading,
			  last_reading_value = EXCLUDED.last_reading_value`
	_, err := r.db.NamedExecContext(ctx, query, customers)
	return err
}

func (r *PostgresCustomerRepository) Save(ctx context.Context, c *domain.Customer) error {
	query := `INSERT INTO customers (
				id, code, name, community_id, sector_id, address, connection_type, 
				tariff, meter_number, latitude, longitude, initial_reading, last_reading_value
			  ) 
	          VALUES (
				$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13
			  ) 
	          ON CONFLICT (id) DO UPDATE SET 
	          code = EXCLUDED.code, name = EXCLUDED.name, community_id = EXCLUDED.community_id, 
	          sector_id = EXCLUDED.sector_id, address = EXCLUDED.address, connection_type = EXCLUDED.connection_type, 
	          tariff = EXCLUDED.tariff, meter_number = EXCLUDED.meter_number,
	          latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, 
	          initial_reading = EXCLUDED.initial_reading,
			  last_reading_value = EXCLUDED.last_reading_value`
	_, err := r.db.ExecContext(ctx, query,
		c.ID, c.Code, c.Name, c.CommunityID, c.SectorID, c.Address, c.ConnectionType,
		c.Tariff, c.MeterNumber, c.Latitude, c.Longitude, c.InitialReading, c.LastReadingValue)
	return err
}

func (r *PostgresCustomerRepository) Delete(ctx context.Context, id string) error {
	query := `DELETE FROM customers WHERE id = $1`
	_, err := r.db.ExecContext(ctx, query, id)
	return err
}

func (r *PostgresCustomerRepository) CountBySector(ctx context.Context, sectorID string) (int, error) {
	var count int
	query := `SELECT COUNT(*) FROM customers WHERE sector_id = $1`
	err := r.db.GetContext(ctx, &count, query, sectorID)
	return count, err
}
