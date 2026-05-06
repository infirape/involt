package domain

import "time"

type PeriodStatus string

const (
	PeriodStatusOpen   PeriodStatus = "OPEN"
	PeriodStatusClosed PeriodStatus = "CLOSED"
)

type Period struct {
	ID        string       `db:"id"` // YYYY-MM
	StartDate time.Time    `db:"start_date"`
	EndDate   time.Time    `db:"end_date"`
	Status          PeriodStatus `db:"status"`
	IsBillingPeriod bool         `db:"is_billing_period"`
	CreatedAt       time.Time    `db:"created_at"`
	UpdatedAt       time.Time    `db:"updated_at"`
}

type PeriodStats struct {
	TotalCustomers    int
	ReadingsCaptured  int
	MissingReadings   int
	MissingCustomers []CustomerShort
}

type CustomerShort struct {
	ID          string
	Name        string
	Code        string
	SectorName  string
	Supervisor  string // Main supervisor for this sector
}
