package domain

import "time"

// ConnectionType matches the electrical setup.
type ConnectionType string

const (
	ConnectionTypeMonofasica ConnectionType = "MONOFASICA"
	ConnectionTypeTrifasica  ConnectionType = "TRIFASICA"
)

// Community represents a village or Caserio.
type Community struct {
	ID   string
	Name string
}

// Sector represents an area within a community.
type Sector struct {
	ID          string
	CommunityID string
	Name        string
}

// Customer contains the master data.
type Customer struct {
	ID             string
	Code           string // e.g., ACH001
	Name           string
	CommunityID    string
	SectorID       string
	ConnectionType ConnectionType
	Tariff         float64
	MeterNumber    string
}

// Reading represents a captured meter value.
type Reading struct {
	ID           string
	CustomerID   string
	PreviousValue float64
	CurrentValue  float64
	Consumption  float64
	PhotoURL     string
	Timestamp    time.Time
	Latitude     float64
	Longitude    float64
	
	// Financial data for receipt consistency
	CargoFijo        float64
	AlumbradoPublico float64
	SaldoRedondeo    float64
	TotalToPay       float64
}
