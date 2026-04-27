package repositories

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/jmoiron/sqlx"
)

type PostgresMetadataRepository struct {
	db *sqlx.DB
}

func NewPostgresMetadataRepository(db *sqlx.DB) *PostgresMetadataRepository {
	return &PostgresMetadataRepository{db: db}
}

func (r *PostgresMetadataRepository) ListCommunities(ctx context.Context) ([]domain.Community, error) {
	var communities []domain.Community
	query := "SELECT id, name FROM communities ORDER BY name ASC"
	err := r.db.SelectContext(ctx, &communities, query)
	if err != nil {
		return nil, fmt.Errorf("error listing communities: %w", err)
	}
	return communities, nil
}

func (r *PostgresMetadataRepository) ListSectors(ctx context.Context) ([]domain.Sector, error) {
	var sectors []domain.Sector
	query := "SELECT id, community_id AS communityid, name FROM sectors ORDER BY name ASC"
	err := r.db.SelectContext(ctx, &sectors, query)
	if err != nil {
		return nil, fmt.Errorf("error listing sectors: %w", err)
	}
	return sectors, nil
}

func (r *PostgresMetadataRepository) SaveCommunities(ctx context.Context, communities []domain.Community) error {
	query := "INSERT INTO communities (id, name) VALUES (:id, :name) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name"
	_, err := r.db.NamedExecContext(ctx, query, communities)
	return err
}

func (r *PostgresMetadataRepository) SaveSectors(ctx context.Context, sectors []domain.Sector) error {
	query := "INSERT INTO sectors (id, community_id, name) VALUES (:id, :communityid, :name) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name"
	_, err := r.db.NamedExecContext(ctx, query, sectors)
	return err
}

func (r *PostgresMetadataRepository) GetAppConfig(ctx context.Context) (*domain.AppConfig, error) {
	var configs []struct {
		Key   string `db:"key"`
		Value string `db:"value"`
	}
	query := "SELECT key, value FROM app_configs"
	err := r.db.SelectContext(ctx, &configs, query)
	if err != nil {
		return nil, fmt.Errorf("error getting app config: %w", err)
	}

	config := &domain.AppConfig{}
	for _, c := range configs {
		switch c.Key {
		case "map_url_template":
			config.MapURLTemplate = c.Value
		case "map_user_agent":
			config.MapUserAgent = c.Value
		}
	}
	return config, nil
}

func (r *PostgresMetadataRepository) GetSettings(ctx context.Context) (*domain.Settings, error) {
	var settings domain.Settings
	query := `SELECT id, municipalidad, empresa, ruc, direccion, telefono, email, dias_vencimiento, tarifa_kwh, cargo_fijo, alumbrado, mantenimiento, igv, created_at, updated_at 
			 FROM settings WHERE id = 'main'`
	err := r.db.GetContext(ctx, &settings, query)
	return &settings, err
}
