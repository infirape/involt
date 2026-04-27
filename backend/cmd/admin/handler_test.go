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

func TestBuildPageInfo(t *testing.T) {
	tests := []struct {
		name     string
		total    int
		page     int
		size     int
		expected PageInfo
	}{
		{
			name:  "first page with next",
			total: 45,
			page:  1,
			size:  20,
			expected: PageInfo{
				Start: 1, End: 20, Total: 45,
				Current: 1, Size: 20, TotalPages: 3,
				Prev: 1, Next: 2, HasPrev: false, HasNext: true,
			},
		},
		{
			name:  "middle page",
			total: 45,
			page:  2,
			size:  20,
			expected: PageInfo{
				Start: 21, End: 40, Total: 45,
				Current: 2, Size: 20, TotalPages: 3,
				Prev: 1, Next: 3, HasPrev: true, HasNext: true,
			},
		},
		{
			name:  "last page",
			total: 45,
			page:  3,
			size:  20,
			expected: PageInfo{
				Start: 41, End: 45, Total: 45,
				Current: 3, Size: 20, TotalPages: 3,
				Prev: 2, Next: 3, HasPrev: true, HasNext: false,
			},
		},
		{
			name:  "empty result",
			total: 0,
			page:  1,
			size:  20,
			expected: PageInfo{
				Start: 0, End: 0, Total: 0,
				Current: 1, Size: 20, TotalPages: 0,
				Prev: 1, Next: 1, HasPrev: false, HasNext: false,
			},
		},
		{
			name:  "page overflow clamps to last page",
			total: 12,
			page:  9,
			size:  10,
			expected: PageInfo{
				Start: 11, End: 12, Total: 12,
				Current: 2, Size: 10, TotalPages: 2,
				Prev: 1, Next: 2, HasPrev: true, HasNext: false,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := buildPageInfo(tt.total, tt.page, tt.size)
			if got != tt.expected {
				t.Fatalf("unexpected page info: got=%+v expected=%+v", got, tt.expected)
			}
		})
	}
}
