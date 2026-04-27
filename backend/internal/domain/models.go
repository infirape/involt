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
	ID               string    `db:"id"`
	CustomerID       string    `db:"customer_id"`
	PreviousValue    float64   `db:"previous_value"`
	CurrentValue     float64   `db:"current_value"`
	Consumption      float64   `db:"consumption"`
	PhotoURL         string    `db:"photo_url"`
	Timestamp        time.Time `db:"timestamp"`
	Latitude         float64   `db:"latitude"`
	Longitude        float64   `db:"longitude"`

	// Period for the reading
	PeriodStart time.Time `db:"period_start"`
	PeriodEnd   time.Time `db:"period_end"`

	// Financial data for receipt consistency
	CargoFijo        float64 `db:"cargo_fijo"`
	AlumbradoPublico float64 `db:"alumbrado_publico"`
	Adjustment       float64 `db:"adjustment"`
	Subtotal         float64 `db:"subtotal"`
	SaldoRedondeo    float64 `db:"saldo_redondeo"`
	RoundDifference  float64 `db:"round_difference"`
	TotalToPay       float64 `db:"total_to_pay"`
	PreviousBalance  float64 `db:"previous_balance"`
	OverdueTotal     float64 `db:"overdue_total"`
	ExpirationDate   time.Time `db:"expiration_date"`
}

// AppConfig contains remote configuration.
type AppConfig struct {
	ID             string `db:"id"`
	MapURLTemplate string `db:"map_url_template"`
	MapUserAgent   string `db:"map_user_agent"`
}
