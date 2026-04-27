package pdf

import (
	"context"
	"fmt"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/johnfercher/maroto/v2"
	"github.com/johnfercher/maroto/v2/pkg/components/code"
	"github.com/johnfercher/maroto/v2/pkg/components/col"
	"github.com/johnfercher/maroto/v2/pkg/components/row"
	"github.com/johnfercher/maroto/v2/pkg/components/text"
	"github.com/johnfercher/maroto/v2/pkg/consts/align"
	"github.com/johnfercher/maroto/v2/pkg/consts/fontstyle"
	"github.com/johnfercher/maroto/v2/pkg/props"
)

type MarotoGenerator struct{}

func NewMarotoGenerator() *MarotoGenerator {
	return &MarotoGenerator{}
}

func (g *MarotoGenerator) Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer) ([]byte, error) {
	m := maroto.New()

	// Header
	m.AddRows(
		row.New(20).Add(
			col.New(8).Add(
				text.New("RECIBO DE LECTURA - INVOLT", props.Text{
					Top:   5,
					Style: fontstyle.Bold,
					Size:  16,
					Align: align.Left,
				}),
			),
			col.New(4).Add(
				text.New(fmt.Sprintf("Fecha: %s", reading.Timestamp.Format("02/01/2006")), props.Text{
					Top:   5,
					Align: align.Right,
				}),
			),
		),
	)

	// Customer Info
	m.AddRows(
		row.New(10).Add(col.New(12).Add(text.New("DATOS DEL CLIENTE", props.Text{Style: fontstyle.Bold}))),
		row.New(5).Add(col.New(12).Add(text.New(fmt.Sprintf("Nombre: %s", customer.Name)))),
		row.New(5).Add(col.New(12).Add(text.New(fmt.Sprintf("Código: %s", customer.Code)))),
		row.New(5).Add(col.New(12).Add(text.New(fmt.Sprintf("Medidor: %s", customer.MeterNumber)))),
	)

	// Consumption Data
	m.AddRows(
		row.New(10).Add(col.New(12).Add(text.New("DETALLE DE CONSUMO", props.Text{Style: fontstyle.Bold, Top: 5}))),
		row.New(5).Add(
			col.New(6).Add(text.New(fmt.Sprintf("Lectura Anterior: %.2f", reading.PreviousValue))),
			col.New(6).Add(text.New(fmt.Sprintf("Lectura Actual: %.2f", reading.CurrentValue))),
		),
		row.New(5).Add(col.New(12).Add(text.New(fmt.Sprintf("Consumo Total: %.2f kWh", reading.Consumption), props.Text{Style: fontstyle.Bold}))),
	)

	// Financial Data
	m.AddRows(
		row.New(10).Add(col.New(12).Add(text.New("IMPORTES A PAGAR", props.Text{Style: fontstyle.Bold, Top: 5}))),
		row.New(5).Add(col.New(8).Add(text.New("Cargo Fijo:")), col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.CargoFijo)))),
		row.New(5).Add(col.New(8).Add(text.New("Alumbrado Público:")), col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.AlumbradoPublico)))),
		row.New(5).Add(col.New(8).Add(text.New("Saldo Redondeo:")), col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.SaldoRedondeo)))),
		row.New(10).Add(
			col.New(8).Add(text.New("TOTAL A PAGAR:", props.Text{Style: fontstyle.Bold, Size: 12})),
			col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.TotalToPay), props.Text{Style: fontstyle.Bold, Size: 12})),
		),
	)

	// QR Code for verification
	m.AddRows(
		row.New(40).Add(
			col.New(12).Add(
				code.NewQr(fmt.Sprintf("INVOLT|%s|%.2f", reading.ID, reading.TotalToPay), props.Rect{
					Center: true,
					Percent: 80,
				}),
			),
		),
	)

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return document.GetBytes(), nil
}
