package ports

import (
	"context"
	"github.com/infira/involt/backend/internal/domain"
)

// ReceiptGenerator defines the operation to create a PDF receipt.
type ReceiptGenerator interface {
	Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer) ([]byte, error)
}
