package domain

import (
	"testing"
	"time"

	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

func TestMapProtoToReading(t *testing.T) {
	now := time.Now().Unix()
	proto := &involtv1.Reading{
		Id:               "read-123",
		CustomerId:       "cust-456",
		PreviousValue:    100.5,
		CurrentValue:     150.2,
		ConsumptionKwh:   49.7,
		PhotoUrl:         "http://photos/1.jpg",
		Timestamp:        now,
		Latitude:         -7.15,
		Longitude:        -78.50,
		CargoFijo:        6.00,
		AlumbradoPublico: 1.50,
		SaldoRedondeo:    0.05,
		TotalToPay:       7.55,
	}

	domain := MapProtoToReading(proto)

	if domain.ID != proto.Id {
		t.Errorf("expected ID %s, got %s", proto.Id, domain.ID)
	}
	if domain.Consumption != proto.ConsumptionKwh {
		t.Errorf("expected Consumption %f, got %f", proto.ConsumptionKwh, domain.Consumption)
	}
	if domain.Timestamp.Unix() != proto.Timestamp {
		t.Errorf("expected Timestamp %d, got %d", proto.Timestamp, domain.Timestamp.Unix())
	}
	if domain.TotalToPay != proto.TotalToPay {
		t.Errorf("expected TotalToPay %f, got %f", proto.TotalToPay, domain.TotalToPay)
	}
}

func TestMapProtoToCustomer(t *testing.T) {
	proto := &involtv1.Customer{
		Id:             "cust-123",
		Code:           "ACH001",
		Name:           "Juan Perez",
		CommunityId:    "com-1",
		SectorId:       "sec-A",
		ConnectionType: involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA,
		Tariff:         0.25,
		MeterNumber:    "M-999",
	}

	domain := MapProtoToCustomer(proto)

	if domain.Code != proto.Code {
		t.Errorf("expected Code %s, got %s", proto.Code, domain.Code)
	}
	if domain.ConnectionType != ConnectionTypeTrifasica {
		t.Errorf("expected ConnectionType TRIFASICA, got %s", domain.ConnectionType)
	}
}
