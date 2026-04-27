package admin

import (
	"context"
	"html/template"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/infira/involt/backend/internal/domain"
)

type mockReadingRepo struct {
	countBySector map[string]int
	sumBySector   map[string]float64
}

func (m *mockReadingRepo) Save(ctx context.Context, reading *domain.Reading) error { return nil }
func (m *mockReadingRepo) GetByID(ctx context.Context, id string) (*domain.Reading, error) { return nil, nil }
func (m *mockReadingRepo) ListByCustomer(ctx context.Context, customerID string) ([]domain.Reading, error) { return nil, nil }
func (m *mockReadingRepo) GetLatestByCustomer(ctx context.Context, customerID string) (*domain.Reading, error) { return nil, nil }
func (m *mockReadingRepo) ListBySectorAndPeriod(ctx context.Context, sectorID string, start, end string) ([]domain.Reading, error) { return nil, nil }
func (m *mockReadingRepo) CountByPeriod(ctx context.Context, period string) (int, error) { return 0, nil }
func (m *mockReadingRepo) CountPendingByPeriod(ctx context.Context, period string) (int, error) { return 0, nil }
func (m *mockReadingRepo) ListPeriods(ctx context.Context) ([]string, error) { return nil, nil }
func (m *mockReadingRepo) CountBySectorAndPeriod(ctx context.Context, sectorID, period string) (int, error) {
	return m.countBySector[sectorID], nil
}
func (m *mockReadingRepo) SumConsumptionBySectorAndPeriod(ctx context.Context, sectorID, period string) (float64, error) {
	return m.sumBySector[sectorID], nil
}

type mockCustomerRepo struct {
	countBySector map[string]int
}

func (m *mockCustomerRepo) GetByID(ctx context.Context, id string) (*domain.Customer, error) { return nil, nil }
func (m *mockCustomerRepo) GetByCode(ctx context.Context, code string) (*domain.Customer, error) { return nil, nil }
func (m *mockCustomerRepo) ListAll(ctx context.Context) ([]domain.Customer, error) { return nil, nil }
func (m *mockCustomerRepo) SaveBatch(ctx context.Context, customers []domain.Customer) error { return nil }
func (m *mockCustomerRepo) CountBySector(ctx context.Context, sectorID string) (int, error) {
	return m.countBySector[sectorID], nil
}

type mockMetadataRepo struct {
	sectors []domain.Sector
}

func (m *mockMetadataRepo) ListCommunities(ctx context.Context) ([]domain.Community, error) { return nil, nil }
func (m *mockMetadataRepo) ListSectors(ctx context.Context) ([]domain.Sector, error) {
	return m.sectors, nil
}
func (m *mockMetadataRepo) SaveCommunities(ctx context.Context, communities []domain.Community) error { return nil }
func (m *mockMetadataRepo) SaveSectors(ctx context.Context, sectors []domain.Sector) error { return nil }
func (m *mockMetadataRepo) GetAppConfig(ctx context.Context) (*domain.AppConfig, error) { return nil, nil }
func (m *mockMetadataRepo) GetSettings(ctx context.Context) (*domain.Settings, error) { return nil, nil }

type mockReceiptGen struct{}

func (m *mockReceiptGen) Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer, settings *domain.Settings, community, sector string) ([]byte, error) {
	return nil, nil
}
func (m *mockReceiptGen) GenerateBatch(ctx context.Context, readings []domain.Reading, customers map[string]*domain.Customer, settings *domain.Settings) ([]byte, error) {
	return nil, nil
}

func TestStatsSectors(t *testing.T) {
	// GIVEN
	sectors := []domain.Sector{
		{ID: "s1", Name: "Sector 1"},
		{ID: "s2", Name: "Sector 2"},
	}
	mReading := &mockReadingRepo{
		countBySector: map[string]int{"s1": 5, "s2": 10},
		sumBySector:   map[string]float64{"s1": 150.5, "s2": 300.0},
	}
	mCustomer := &mockCustomerRepo{
		countBySector: map[string]int{"s1": 10, "s2": 10},
	}
	mMeta := &mockMetadataRepo{sectors: sectors}
	mReceipt := &mockReceiptGen{}

	// Mock templates
	tmpl := template.New("test")
	
	h := &AdminHandler{
		readingRepo:  mReading,
		customerRepo: mCustomer,
		metadataRepo: mMeta,
		pdfGen:       mReceipt,
		templates:    tmpl,
	}

	req := httptest.NewRequest("GET", "/admin/stats/sectors?period=2026-04", nil)
	rr := httptest.NewRecorder()

	// WHEN
	h.StatsSectors(rr, req)

	// THEN
	if rr.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d", rr.Code)
	}
}
