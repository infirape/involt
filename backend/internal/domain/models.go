package domain

import "time"

// ConnectionType matches the electrical setup.
type ConnectionType string

const (
	ConnectionTypeMonofasica ConnectionType = "MONOFASICA"
	ConnectionTypeTrifasica  ConnectionType = "TRIFASICA"
)

// Settings contains municipalidad/empresa configuration.
type Settings struct {
	ID              string    `db:"id"`
	Municipalidad   string    `db:"municipalidad"`
	Empresa         string    `db:"empresa"`
	RUC             string    `db:"ruc"`
	Direccion       string    `db:"direccion"`
	Telefono        string    `db:"telefono"`
	Email           string    `db:"email"`
	DiasVencimiento int       `db:"dias_vencimiento"`
	TarifaKWh       float64   `db:"tarifa_kwh"`
	CargoFijo       float64   `db:"cargo_fijo"`
	Alumbrado       float64   `db:"alumbrado"`
	Mantenimiento   float64   `db:"mantenimiento"`
	IGV             bool      `db:"igv"`
	CreatedAt       time.Time `db:"created_at"`
	UpdatedAt       time.Time `db:"updated_at"`
}

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
	ID               string
	Code             string // e.g., ACH001
	Name             string
	CommunityID      string
	CommunityName    string // e.g., Chetilla
	SectorID         string
	SectorName       string // e.g., TANTA CUEVA JOSE SILVERIO
	Address          string // e.g., CASERIO TAMBILLO ALTO
	ConnectionType   ConnectionType
	Tariff           float64
	MeterNumber      string
	Latitude         float64
	Longitude        float64
	LastReadingValue float64
	InitialReading   float64   `db:"initial_reading"`
	ContractStart    time.Time // Inicio Contrato
}

// Reading represents a captured meter value.
type Reading struct {
	ID            string
	CustomerID    string
	PreviousValue float64
	CurrentValue  float64
	Consumption   float64
	PhotoURL      string
	Timestamp     time.Time
	Latitude      float64
	Longitude     float64

	// Period for the reading
	PeriodStart time.Time
	PeriodEnd   time.Time

	// Financial data for receipt consistency
	CargoFijo        float64
	AlumbradoPublico float64
	Adjustment       float64 // Ajuste Tarifario
	Subtotal         float64
	SaldoRedondeo    float64 // Saldo por Redondeo
	RoundDifference  float64 // Diferencia de redondeo
	TotalToPay       float64
	PreviousBalance  float64   // Saldo anterior
	OverdueTotal     float64   // Total recibos vencidos
	ExpirationDate   time.Time // Fecha de vencimiento
}

// AppConfig contains remote configuration.
type AppConfig struct {
	MapURLTemplate string
	MapUserAgent   string
}
