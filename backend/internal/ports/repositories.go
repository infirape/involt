package ports

import (
	"context"

	"github.com/infira/involt/backend/internal/domain"
)

// CustomerRepository defines operations for customer data.
type CustomerRepository interface {
	GetByCode(ctx context.Context, code string) (*domain.Customer, error)
	ListAll(ctx context.Context) ([]domain.Customer, error)
	SaveBatch(ctx context.Context, customers []domain.Customer) error
}

// ReadingRepository defines operations for meter readings.
type ReadingRepository interface {
	Save(ctx context.Context, reading *domain.Reading) error
	ListByCustomer(ctx context.Context, customerID string) ([]domain.Reading, error)
	GetLatestByCustomer(ctx context.Context, customerID string) (*domain.Reading, error)
}

// MetadataRepository defines operations for communities and sectors.
type MetadataRepository interface {
	ListCommunities(ctx context.Context) ([]domain.Community, error)
	ListSectors(ctx context.Context) ([]domain.Sector, error)
	SaveCommunities(ctx context.Context, communities []domain.Community) error
	SaveSectors(ctx context.Context, sectors []domain.Sector) error
}
