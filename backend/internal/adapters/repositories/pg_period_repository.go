package repositories

import (
	"context"
	"database/sql"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresPeriodRepository struct {
	db *sqlx.DB
}

func NewPostgresPeriodRepository(db *sqlx.DB) *PostgresPeriodRepository {
	return &PostgresPeriodRepository{db: db}
}

func (r *PostgresPeriodRepository) GetByID(ctx context.Context, id string) (*domain.Period, error) {
	var period domain.Period
	query := "SELECT id, start_date, end_date, status, created_at, updated_at FROM periods WHERE id = $1"
	err := r.db.GetContext(ctx, &period, query, id)
	if err != nil {
		return nil, err
	}
	return &period, nil
}

func (r *PostgresPeriodRepository) GetCurrent(ctx context.Context) (*domain.Period, error) {
	var period domain.Period
	query := "SELECT id, start_date, end_date, status, created_at, updated_at FROM periods WHERE status = 'OPEN' ORDER BY start_date DESC LIMIT 1"
	err := r.db.GetContext(ctx, &period, query)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return &period, nil
}

func (r *PostgresPeriodRepository) List(ctx context.Context) ([]domain.Period, error) {
	var periods []domain.Period
	query := "SELECT id, start_date, end_date, status, created_at, updated_at FROM periods ORDER BY start_date DESC"
	err := r.db.SelectContext(ctx, &periods, query)
	if err != nil {
		return nil, err
	}
	return periods, nil
}

func (r *PostgresPeriodRepository) Save(ctx context.Context, p *domain.Period) error {
	query := `INSERT INTO periods (id, start_date, end_date, status, updated_at)
			  VALUES (:id, :start_date, :end_date, :status, NOW())
			  ON CONFLICT (id) DO UPDATE SET
			  start_date = EXCLUDED.start_date,
			  end_date = EXCLUDED.end_date,
			  status = EXCLUDED.status,
			  updated_at = NOW()`
	_, err := r.db.NamedExecContext(ctx, query, p)
	return err
}

func (r *PostgresPeriodRepository) GetStats(ctx context.Context, periodID string) (*domain.PeriodStats, error) {
	stats := &domain.PeriodStats{}

	// 1. Total Customers
	err := r.db.GetContext(ctx, &stats.TotalCustomers, "SELECT COUNT(*) FROM customers")
	if err != nil {
		return nil, err
	}

	// 2. Readings Captured for this period
	// We need to parse periodID (YYYY-MM) to get dates
	t, _ := time.Parse("2006-01", periodID)
	start := t.Format("2006-01-02")
	end := t.AddDate(0, 1, -1).Format("2006-01-02")

	err = r.db.GetContext(ctx, &stats.ReadingsCaptured, 
		"SELECT COUNT(*) FROM readings WHERE period_start = $1 AND period_end = $2", start, end)
	if err != nil {
		return nil, err
	}

	stats.MissingReadings = stats.TotalCustomers - stats.ReadingsCaptured

	// 3. List Missing Customers with Supervisors
	query := `
		SELECT 
			c.id, c.name, c.code, s.name as sector_name,
			COALESCE((
				SELECT STRING_AGG(u.email, ', ') 
				FROM users u 
				JOIN user_sectors us ON u.id = us.user_id 
				WHERE us.sector_id = c.sector_id AND u.role = 'SUPERVISOR'
			), 'Sin asignar') as supervisor
		FROM customers c
		JOIN sectors s ON c.sector_id = s.id
		WHERE c.id NOT IN (
			SELECT customer_id FROM readings WHERE period_start = $1 AND period_end = $2
		)
		ORDER BY s.name ASC, c.name ASC
		LIMIT 100`
	
	rows, err := r.db.QueryContext(ctx, query, start, end)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var cs domain.CustomerShort
		err := rows.Scan(&cs.ID, &cs.Name, &cs.Code, &cs.SectorName, &cs.Supervisor)
		if err != nil {
			return nil, err
		}
		stats.MissingCustomers = append(stats.MissingCustomers, cs)
	}

	return stats, nil
}
