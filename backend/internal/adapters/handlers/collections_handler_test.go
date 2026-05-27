package handlers

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func TestGetCollectionsReturnsCustomersWithoutReadings(t *testing.T) {
	ctx := authenticatedTestContext()
	customerRepo := &collectionsCustomerRepoStub{
		listBySectorFunc: func(_ context.Context, sectorID string) ([]domain.Customer, error) {
			if sectorID != "sector-achupampa" {
				t.Fatalf("expected sector-achupampa, got %s", sectorID)
			}
			return []domain.Customer{
				{ID: "cust-001", Code: "ACH001", Name: "Ana Luz", SectorID: sectorID},
				{ID: "cust-002", Code: "ACH002", Name: "Beto Sol", SectorID: sectorID},
			}, nil
		},
	}
	readingRepo := &collectionsReadingRepoStub{
		listBySectorFunc: func(_ context.Context, sectorID string, periods []string) ([]domain.Reading, error) {
			if sectorID != "sector-achupampa" {
				t.Fatalf("expected readings query to use sector_id, got %s", sectorID)
			}
			if len(periods) != 2 || periods[0] != "2026-05" || periods[1] != "2026-04" {
				t.Fatalf("unexpected periods: %#v", periods)
			}
			return nil, nil
		},
	}
	handler := &AdminHandler{customerRepo: customerRepo, readingRepo: readingRepo}

	resp, err := handler.GetCollections(ctx, connect.NewRequest(&involtv1.GetCollectionsRequest{
		SectorId: "sector-achupampa",
		Periods:  []string{"2026-05", "2026-04"},
	}))
	if err != nil {
		t.Fatalf("GetCollections returned error: %v", err)
	}

	if got := len(resp.Msg.GetReadings()); got != 0 {
		t.Fatalf("legacy readings length = %d, want 0", got)
	}
	if got := len(resp.Msg.GetCustomers()); got != 2 {
		t.Fatalf("customers length = %d, want 2", got)
	}
	if resp.Msg.GetCustomers()[0].GetCustomer().GetId() != "cust-001" {
		t.Fatalf("first customer id = %s, want cust-001", resp.Msg.GetCustomers()[0].GetCustomer().GetId())
	}
	if got := len(resp.Msg.GetCustomers()[0].GetReadings()); got != 0 {
		t.Fatalf("customer readings length = %d, want 0", got)
	}
}

func TestGetCollectionsAttachesRequestedPeriodReadingsToCustomerRows(t *testing.T) {
	ctx := authenticatedTestContext()
	customerRepo := &collectionsCustomerRepoStub{
		listBySectorFunc: func(_ context.Context, sectorID string) ([]domain.Customer, error) {
			return []domain.Customer{
				{ID: "cust-001", Code: "ACH001", Name: "Ana Luz", SectorID: sectorID},
				{ID: "cust-002", Code: "ACH002", Name: "Beto Sol", SectorID: sectorID},
			}, nil
		},
	}
	readingRepo := &collectionsReadingRepoStub{
		listBySectorFunc: func(_ context.Context, _ string, _ []string) ([]domain.Reading, error) {
			return []domain.Reading{
				{ID: "read-001", CustomerID: "cust-001", CustomerName: "Ana Luz", Period: "2026-05", TotalToPay: 45.5, IsPaid: false},
			}, nil
		},
	}
	handler := &AdminHandler{customerRepo: customerRepo, readingRepo: readingRepo}

	resp, err := handler.GetCollections(ctx, connect.NewRequest(&involtv1.GetCollectionsRequest{
		SectorId: "sector-achupampa",
		Periods:  []string{"2026-05", "2026-04"},
	}))
	if err != nil {
		t.Fatalf("GetCollections returned error: %v", err)
	}

	if got := len(resp.Msg.GetReadings()); got != 1 {
		t.Fatalf("legacy readings length = %d, want 1", got)
	}
	customers := resp.Msg.GetCustomers()
	if got := len(customers); got != 2 {
		t.Fatalf("customers length = %d, want 2", got)
	}
	if got := len(customers[0].GetReadings()); got != 1 {
		t.Fatalf("first customer readings length = %d, want 1", got)
	}
	if got := customers[0].GetReadings()[0].GetId(); got != "read-001" {
		t.Fatalf("attached reading id = %s, want read-001", got)
	}
	if got := len(customers[1].GetReadings()); got != 0 {
		t.Fatalf("second customer readings length = %d, want 0", got)
	}
}

func authenticatedTestContext() context.Context {
	return context.WithValue(context.Background(), auth.UserContextKey, &auth.UserContext{
		ID:    "admin-1",
		Email: "admin@example.com",
		Role:  "ADMIN",
	})
}

type collectionsCustomerRepoStub struct {
	listBySectorFunc func(context.Context, string) ([]domain.Customer, error)
}

func (s *collectionsCustomerRepoStub) GetByID(context.Context, string) (*domain.Customer, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) GetByCode(context.Context, string) (*domain.Customer, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) List(context.Context, []string, string, int, int, string, string) ([]domain.Customer, int, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) ListAll(context.Context) ([]domain.Customer, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) SaveBatch(context.Context, []domain.Customer) error {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) Save(context.Context, *domain.Customer) error {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) Delete(context.Context, string) error {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) CountBySector(context.Context, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsCustomerRepoStub) ListBySector(ctx context.Context, sectorID string) ([]domain.Customer, error) {
	return s.listBySectorFunc(ctx, sectorID)
}

type collectionsReadingRepoStub struct {
	listBySectorFunc func(context.Context, string, []string) ([]domain.Reading, error)
}

func (s *collectionsReadingRepoStub) Save(context.Context, *domain.Reading) error {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) GetByID(context.Context, string) (*domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListByCustomer(context.Context, string) ([]domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) GetLatestByCustomer(context.Context, string) (*domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) GetLatestByCustomerExcludingID(context.Context, string, string) (*domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListBySectorAndPeriod(context.Context, string, string, string) ([]domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) CountByPeriod(context.Context, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) CountPendingByPeriod(context.Context, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListPeriods(context.Context) ([]string, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) CountBySectorAndPeriod(context.Context, string, string) (int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumConsumptionBySectorAndPeriod(context.Context, string, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumRevenueBySectorAndPeriod(context.Context, string, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumRevenueByPeriod(context.Context, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) SumConsumptionByPeriod(context.Context, string) (float64, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) List(context.Context, string, string, string, int, int) ([]domain.Reading, int, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListAll(context.Context) ([]domain.Reading, error) {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) UpdatePaymentStatus(context.Context, string, bool) error {
	panic("not implemented")
}
func (s *collectionsReadingRepoStub) ListBySector(ctx context.Context, sectorID string, periods []string) ([]domain.Reading, error) {
	return s.listBySectorFunc(ctx, sectorID, periods)
}
func (s *collectionsReadingRepoStub) GetByCustomerAndPeriod(context.Context, string, string) (*domain.Reading, error) {
	panic("not implemented")
}
