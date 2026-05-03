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
	tx, err := r.db.BeginTxx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	query := `INSERT INTO readings (
				id, customer_id, previous_value, current_value, consumption, 
				photo_url, timestamp, latitude, longitude, period_start, period_end,
				cargo_fijo, alumbrado_publico, mantenimiento, adjustment, subtotal, 
				saldo_redondeo, round_difference, total_to_pay, previous_balance, 
				overdue_total, expiration_date
			  ) 
	          VALUES (
				:id, :customer_id, :previous_value, :current_value, :consumption, 
				:photo_url, :timestamp, :latitude, :longitude, :period_start, :period_end,
				:cargo_fijo, :alumbrado_publico, :mantenimiento, :adjustment, :subtotal, 
				:saldo_redondeo, :round_difference, :total_to_pay, :previous_balance, 
				:overdue_total, :expiration_date
			  ) 
	          ON CONFLICT (id) DO UPDATE SET 
				current_value = EXCLUDED.current_value,
				consumption = EXCLUDED.consumption,
				total_to_pay = EXCLUDED.total_to_pay`

	_, err = tx.NamedExecContext(ctx, query, reading)
	if err != nil {
		return err
	}

	// Update customer's last reading value
	_, err = tx.ExecContext(ctx, "UPDATE customers SET last_reading_value = $1 WHERE id = $2", reading.CurrentValue, reading.CustomerID)
	if err != nil {
		return err
	}

	return tx.Commit()
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

func (r *PostgresReadingRepository) CountByPeriod(ctx context.Context, period string) (int, error) {
	var count int
	query := `SELECT COUNT(DISTINCT customer_id) FROM readings WHERE to_char(timestamp, 'YYYY-MM') = $1`
	err := r.db.GetContext(ctx, &count, query, period)
	return count, err
}

func (r *PostgresReadingRepository) CountPendingByPeriod(ctx context.Context, period string) (int, error) {
	var count int
	query := `SELECT COUNT(*) FROM customers c 
	          WHERE NOT EXISTS (
	              SELECT 1 FROM readings r 
	              WHERE r.customer_id = c.id 
	              AND to_char(r.timestamp, 'YYYY-MM') = $1
	          )`
	err := r.db.GetContext(ctx, &count, query, period)
	return count, err
}

func (r *PostgresReadingRepository) ListPeriods(ctx context.Context) ([]string, error) {
	var periods []string
	query := `SELECT DISTINCT to_char(timestamp, 'YYYY-MM') as period 
	          FROM readings 
	          ORDER BY period DESC`
	err := r.db.SelectContext(ctx, &periods, query)
	if err != nil {
		return nil, fmt.Errorf("error listing periods: %w", err)
	}
	return periods, nil
}
func (r *PostgresReadingRepository) CountBySectorAndPeriod(ctx context.Context, sectorID, period string) (int, error) {
	var count int
	query := `SELECT COUNT(DISTINCT r.customer_id) FROM readings r
	          JOIN customers c ON r.customer_id = c.id
	          WHERE c.sector_id = $1 AND to_char(r.timestamp, 'YYYY-MM') = $2`
	err := r.db.GetContext(ctx, &count, query, sectorID, period)
	return count, err
}

func (r *PostgresReadingRepository) SumConsumptionBySectorAndPeriod(ctx context.Context, sectorID, period string) (float64, error) {
	var sum float64
	query := `SELECT COALESCE(SUM(r.consumption), 0) FROM readings r
	          JOIN customers c ON r.customer_id = c.id
	          WHERE c.sector_id = $1 AND to_char(r.timestamp, 'YYYY-MM') = $2`
	err := r.db.GetContext(ctx, &sum, query, sectorID, period)
	return sum, err
}

func (r *PostgresReadingRepository) SumRevenueByPeriod(ctx context.Context, period string) (float64, error) {
	var sum float64
	query := `SELECT COALESCE(SUM(total_to_pay), 0) FROM readings WHERE to_char(timestamp, 'YYYY-MM') = $1`
	err := r.db.GetContext(ctx, &sum, query, period)
	return sum, err
}

func (r *PostgresReadingRepository) SumConsumptionByPeriod(ctx context.Context, period string) (float64, error) {
	var sum float64
	query := `SELECT COALESCE(SUM(consumption), 0) FROM readings WHERE to_char(timestamp, 'YYYY-MM') = $1`
	err := r.db.GetContext(ctx, &sum, query, period)
	return sum, err
}
func (r *PostgresReadingRepository) List(ctx context.Context, customerID, sectorID, period string, limit, offset int) ([]domain.Reading, int, error) {
	var readings []domain.Reading
	var total int

	where := "1=1"
	args := []interface{}{}
	argIdx := 1

	if customerID != "" {
		where += fmt.Sprintf(" AND r.customer_id = $%d", argIdx)
		args = append(args, customerID)
		argIdx++
	}

	if sectorID != "" {
		where += fmt.Sprintf(" AND c.sector_id = $%d", argIdx)
		args = append(args, sectorID)
		argIdx++
	}

	if period != "" {
		where += fmt.Sprintf(" AND to_char(r.timestamp, 'YYYY-MM') = $%d", argIdx)
		args = append(args, period)
		argIdx++
	}

	// Get total count
	countQuery := fmt.Sprintf(`SELECT COUNT(*) FROM readings r 
	                           JOIN customers c ON r.customer_id = c.id 
	                           WHERE %s`, where)
	err := r.db.GetContext(ctx, &total, countQuery, args...)
	if err != nil {
		return nil, 0, err
	}

	// Get paginated data
	query := fmt.Sprintf(`SELECT r.* FROM readings r
	                       JOIN customers c ON r.customer_id = c.id
	                       WHERE %s ORDER BY r.timestamp DESC LIMIT $%d OFFSET $%d`, where, argIdx, argIdx+1)
	
	args = append(args, limit, offset)
	err = r.db.SelectContext(ctx, &readings, query, args...)
	if err != nil {
		return nil, 0, err
	}

	return readings, total, nil
}

func (r *PostgresReadingRepository) ListAll(ctx context.Context) ([]domain.Reading, error) {
	var readings []domain.Reading
	query := `SELECT * FROM readings ORDER BY timestamp DESC`
	err := r.db.SelectContext(ctx, &readings, query)
	return readings, err
}
