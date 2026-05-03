package ports

import (
	"context"

	"github.com/infira/involt/backend/internal/domain"
)

// ReadingRepository defines operations for meter readings.
type ReadingRepository interface {
	Save(ctx context.Context, reading *domain.Reading) error
	GetByID(ctx context.Context, id string) (*domain.Reading, error)
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Reading, error)
	GetLatestByCustomer(ctx context.Context, customerID string) (*domain.Reading, error)
	ListBySectorAndPeriod(ctx context.Context, sectorID string, start, end string) ([]domain.Reading, error)
	CountByPeriod(ctx context.Context, period string) (int, error)
	CountPendingByPeriod(ctx context.Context, period string) (int, error)
	ListPeriods(ctx context.Context) ([]string, error)
	CountBySectorAndPeriod(ctx context.Context, sectorID, period string) (int, error)
	SumConsumptionBySectorAndPeriod(ctx context.Context, sectorID, period string) (float64, error)
	ListAll(ctx context.Context) ([]domain.Reading, error)
}

// CustomerRepository defines operations for customer data.
type CustomerRepository interface {
	GetByID(ctx context.Context, id string) (*domain.Customer, error)
	GetByCode(ctx context.Context, code string) (*domain.Customer, error)
	ListAll(ctx context.Context) ([]domain.Customer, error)
	SaveBatch(ctx context.Context, customers []domain.Customer) error
	Save(ctx context.Context, customer *domain.Customer) error
	CountBySector(ctx context.Context, sectorID string) (int, error)
}

// MetadataRepository defines operations for communities and sectors.
type MetadataRepository interface {
	ListCommunities(ctx context.Context) ([]domain.Community, error)
	ListSectors(ctx context.Context) ([]domain.Sector, error)
	SaveCommunities(ctx context.Context, communities []domain.Community) error
	SaveSectors(ctx context.Context, sectors []domain.Sector) error
	GetAppConfig(ctx context.Context) (*domain.AppConfig, error)
	GetSettings(ctx context.Context) (*domain.Settings, error)
	SaveSettings(ctx context.Context, settings *domain.Settings) error
}
