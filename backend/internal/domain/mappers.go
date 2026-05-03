package domain

import (
	"time"

	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// MapProtoToReading converts a Protobuf reading to a Domain reading.
func MapProtoToReading(p *involtv1.Reading) *Reading {
	if p == nil {
		return nil
	}
	t, _ := time.Parse(time.RFC3339, p.Timestamp)
	ps, _ := time.Parse(time.RFC3339, p.PeriodStart)
	pe, _ := time.Parse(time.RFC3339, p.PeriodEnd)
	ed, _ := time.Parse(time.RFC3339, p.ExpirationDate)

	return &Reading{
		ID:               p.Id,
		CustomerID:       p.CustomerId,
		PreviousValue:    p.PreviousValue,
		CurrentValue:     p.CurrentValue,
		Consumption:      p.Consumption,
		PhotoURL:         p.PhotoUrl,
		Timestamp:        t,
		Latitude:         p.Latitude,
		Longitude:        p.Longitude,
		CargoFijo:        p.CargoFijo,
		AlumbradoPublico: p.AlumbradoPublico,
		SaldoRedondeo:    p.SaldoRedondeo,
		TotalToPay:       p.TotalToPay,
		PeriodStart:      ps,
		PeriodEnd:        pe,
		Mantenimiento:    p.Mantenimiento,
		Adjustment:       p.Adjustment,
		Subtotal:         p.Subtotal,
		RoundDifference:  p.RoundDifference,
		PreviousBalance:  p.PreviousBalance,
		OverdueTotal:     p.OverdueTotal,
		ExpirationDate:   ed,
	}
}

// MapReadingToProto converts a Domain reading back to Protobuf.
func MapReadingToProto(d *Reading) *involtv1.Reading {
	if d == nil {
		return nil
	}
	return &involtv1.Reading{
		Id:               d.ID,
		CustomerId:       d.CustomerID,
		PreviousValue:    d.PreviousValue,
		CurrentValue:     d.CurrentValue,
		Consumption:      d.Consumption,
		PhotoUrl:         d.PhotoURL,
		Timestamp:        d.Timestamp.Format(time.RFC3339),
		Latitude:         d.Latitude,
		Longitude:        d.Longitude,
		CargoFijo:        d.CargoFijo,
		AlumbradoPublico: d.AlumbradoPublico,
		SaldoRedondeo:    d.SaldoRedondeo,
		TotalToPay:       d.TotalToPay,
		PeriodStart:      d.PeriodStart.Format(time.RFC3339),
		PeriodEnd:        d.PeriodEnd.Format(time.RFC3339),
		Mantenimiento:    d.Mantenimiento,
		Adjustment:       d.Adjustment,
		Subtotal:         d.Subtotal,
		RoundDifference:  d.RoundDifference,
		PreviousBalance:  d.PreviousBalance,
		OverdueTotal:     d.OverdueTotal,
		ExpirationDate:   d.ExpirationDate.Format(time.RFC3339),
	}
}

// MapProtoToCustomer converts a Protobuf customer to a Domain customer.
func MapProtoToCustomer(p *involtv1.Customer) *Customer {
	if p == nil {
		return nil
	}
	
	connType := ConnectionTypeMonofasica
	if p.ConnectionType == involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA {
		connType = ConnectionTypeTrifasica
	}

	cs, _ := time.Parse(time.RFC3339, p.ContractStart)

	return &Customer{
		ID:               p.Id,
		Code:             p.Code,
		Name:             p.Name,
		CommunityID:      p.CommunityId,
		SectorID:         p.SectorId,
		ConnectionType:   connType,
		Tariff:           p.Tariff,
		MeterNumber:      p.MeterNumber,
		Latitude:         p.Latitude,
		Longitude:        p.Longitude,
		InitialReading:   p.InitialReading,
		LastReadingValue: p.LastReadingValue,
		Address:          p.Address,
		ContractStart:    cs,
	}
}

// MapCustomerToProto converts a Domain customer to Protobuf.
func MapCustomerToProto(d *Customer) *involtv1.Customer {
	if d == nil {
		return nil
	}

	connType := involtv1.ConnectionType_CONNECTION_TYPE_MONOFASICA
	if d.ConnectionType == ConnectionTypeTrifasica {
		connType = involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA
	}

	return &involtv1.Customer{
		Id:               d.ID,
		Code:             d.Code,
		Name:             d.Name,
		CommunityId:      d.CommunityID,
		SectorId:         d.SectorID,
		ConnectionType:   connType,
		Tariff:           d.Tariff,
		MeterNumber:      d.MeterNumber,
		Latitude:         d.Latitude,
		Longitude:        d.Longitude,
		InitialReading:   d.InitialReading,
		LastReadingValue: d.LastReadingValue,
		Address:          d.Address,
		ContractStart:    d.ContractStart.Format(time.RFC3339),
	}
}
