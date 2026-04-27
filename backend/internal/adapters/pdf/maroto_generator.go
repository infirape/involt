package pdf

import (
	"bytes"
	"context"
	"fmt"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/johnfercher/maroto/v2"
	"github.com/johnfercher/maroto/v2/pkg/components/col"
	"github.com/johnfercher/maroto/v2/pkg/components/row"
	"github.com/johnfercher/maroto/v2/pkg/components/text"
	"github.com/johnfercher/maroto/v2/pkg/config"
	"github.com/johnfercher/maroto/v2/pkg/consts/align"
	"github.com/johnfercher/maroto/v2/pkg/consts/fontstyle"
	"github.com/johnfercher/maroto/v2/pkg/consts/pagesize"
	"github.com/johnfercher/maroto/v2/pkg/core"
	"github.com/johnfercher/maroto/v2/pkg/props"
	"github.com/pdfcpu/pdfcpu/pkg/api"
	"github.com/pdfcpu/pdfcpu/pkg/pdfcpu/types"
)

type MarotoGenerator struct{}

func NewMarotoGenerator() *MarotoGenerator {
	return &MarotoGenerator{}
}

func (g *MarotoGenerator) Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer) ([]byte, error) {
	cfg := config.NewBuilder().
		WithPageSize(pagesize.A5).
		Build()

	m := maroto.New(cfg)
	g.addReceiptComponents(m, reading, customer)

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return g.applyWatermark(document.GetBytes())
}

func (g *MarotoGenerator) GenerateBatch(ctx context.Context, readings []domain.Reading, customers map[string]*domain.Customer) ([]byte, error) {
	if len(readings) == 0 {
		return nil, nil
	}

	r := readings[0]
	customer := customers[r.CustomerID]
	if customer == nil {
		customer = &domain.Customer{Name: "Desconocido", Code: "N/A"}
	}

	return g.Generate(ctx, &r, customer)
}

func (g *MarotoGenerator) addReceiptComponents(m core.Maroto, reading *domain.Reading, customer *domain.Customer) {
	fontSmall := 8.0
	fontNormal := 9.0

	// ===== HEADER SECTION =====
	// Row 1: Companies (left) + Suministro info (right)
	m.AddRows(
		row.New(8).Add(
			col.New(6).Add(
				text.New("MUNICIPALIDAD DISTRITAL DE CHETILLA", props.Text{Top: 1, Size: fontNormal, Style: fontstyle.Bold}),
				text.New("HIDROELECTRICA QARWAQIRU", props.Text{Top: 4, Size: fontSmall}),
			),
			col.New(6).Add(
				text.New(fmt.Sprintf("Código: %s", customer.Code), props.Text{Top: 1, Size: fontNormal, Align: align.Right}),
				text.New(fmt.Sprintf("Fecha Emisión: %s", formatDate(reading.Timestamp)), props.Text{Top: 4, Size: fontSmall, Align: align.Right}),
			),
		),
	)

	// Row 2: Customer info box
	m.AddRows(
		row.New(12).Add(
			col.New(3).Add(
				text.New("Suministro:", props.Text{Top: 1, Size: fontSmall}),
				text.New("Cliente:", props.Text{Top: 4, Size: fontSmall}),
				text.New("Dirección:", props.Text{Top: 7, Size: fontSmall}),
				text.New("Medidor N°:", props.Text{Top: 10, Size: fontSmall}),
			),
			col.New(6).Add(
				text.New(customer.Code, props.Text{Top: 1, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(customer.Name, props.Text{Top: 4, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(customer.Address, props.Text{Top: 7, Size: fontNormal}),
				text.New(customer.MeterNumber, props.Text{Top: 10, Size: fontNormal}),
			),
			col.New(3).Add(
				text.New("Vencimiento:", props.Text{Top: 1, Size: fontSmall, Align: align.Right}),
				text.New("Período:", props.Text{Top: 7, Size: fontSmall, Align: align.Right}),
			),
			col.New(3).Add(
				text.New(formatDate(reading.ExpirationDate), props.Text{Top: 1, Size: fontNormal, Style: fontstyle.Bold, Align: align.Right}),
				text.New(fmt.Sprintf("%s a %s", formatDateShort(reading.PeriodStart), formatDateShort(reading.PeriodEnd)), props.Text{Top: 7, Size: fontSmall, Align: align.Right}),
			),
		),
	)

	// ===== CONSUMPTION TABLE =====
	m.AddRows(
		row.New(6).Add(
			col.New(12).Add(
				text.New("DETALLE DE CONSUMO", props.Text{Top: 1, Size: fontNormal, Style: fontstyle.Bold}),
			),
		),
	)

	// Table header
	m.AddRows(
		row.New(5).Add(
			col.New(4).Add(text.New("CONCEPTO", props.Text{Top: 1, Size: fontSmall, Style: fontstyle.Bold})),
			col.New(2).Add(text.New("RUBRO", props.Text{Top: 1, Size: fontSmall, Style: fontstyle.Bold, Align: align.Center})),
			col.New(2).Add(text.New("CANT.", props.Text{Top: 1, Size: fontSmall, Style: fontstyle.Bold, Align: align.Center})),
			col.New(2).Add(text.New("P.UNIT", props.Text{Top: 1, Size: fontSmall, Style: fontstyle.Bold, Align: align.Right})),
			col.New(2).Add(text.New("IMPORTE", props.Text{Top: 1, Size: fontSmall, Style: fontstyle.Bold, Align: align.Right})),
		),
	)

	// Consumption row
	m.AddRows(
		row.New(5).Add(
			col.New(4).Add(text.New("Energía Activa", props.Text{Top: 1, Size: fontSmall})),
			col.New(2).Add(text.New("001", props.Text{Top: 1, Size: fontSmall, Align: align.Center})),
			col.New(2).Add(text.New(fmt.Sprintf("%.0f", reading.Consumption), props.Text{Top: 1, Size: fontSmall, Align: align.Center})),
			col.New(2).Add(text.New(fmt.Sprintf("%.4f", customer.Tariff), props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
			col.New(2).Add(text.New(fmt.Sprintf("%.2f", reading.Subtotal), props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
		),
	)

	// Cargo Fijo row
	m.AddRows(
		row.New(5).Add(
			col.New(4).Add(text.New("Cargo Fijo", props.Text{Top: 1, Size: fontSmall})),
			col.New(2).Add(text.New("002", props.Text{Top: 1, Size: fontSmall, Align: align.Center})),
			col.New(2).Add(text.New("1", props.Text{Top: 1, Size: fontSmall, Align: align.Center})),
			col.New(2).Add(text.New(fmt.Sprintf("%.2f", reading.CargoFijo), props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
			col.New(2).Add(text.New(fmt.Sprintf("%.2f", reading.CargoFijo), props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
		),
	)

	// Alumbrado Público row
	m.AddRows(
		row.New(5).Add(
			col.New(4).Add(text.New("Alumbrado Público", props.Text{Top: 1, Size: fontSmall})),
			col.New(2).Add(text.New("003", props.Text{Top: 1, Size: fontSmall, Align: align.Center})),
			col.New(2).Add(text.New("1", props.Text{Top: 1, Size: fontSmall, Align: align.Center})),
			col.New(2).Add(text.New(fmt.Sprintf("%.2f", reading.AlumbradoPublico), props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
			col.New(2).Add(text.New(fmt.Sprintf("%.2f", reading.AlumbradoPublico), props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
		),
	)

	// ===== TOTALS =====
	subtotalBase := reading.Subtotal + reading.CargoFijo + reading.AlumbradoPublico
	m.AddRows(
		row.New(6).Add(
			col.New(8).Add(text.New("", props.Text{Top: 1, Size: fontSmall})),
			col.New(2).Add(text.New("SUBTOTAL:", props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
			col.New(2).Add(text.New(fmt.Sprintf("%.2f", subtotalBase), props.Text{Top: 1, Size: fontSmall, Align: align.Right})),
		),
	)

	m.AddRows(
		row.New(6).Add(
			col.New(8).Add(text.New("", props.Text{Top: 1, Size: fontSmall})),
			col.New(2).Add(text.New("TOTAL A PAGAR:", props.Text{Top: 2, Size: 12, Style: fontstyle.Bold, Align: align.Right})),
			col.New(2).Add(text.New(fmt.Sprintf("S/ %.2f", reading.TotalToPay), props.Text{Top: 2, Size: 12, Style: fontstyle.Bold, Align: align.Right})),
		),
	)

	// ===== READINGS =====
	m.AddRows(
		row.New(8).Add(
			col.New(12).Add(
				text.New("LECTURAS", props.Text{Top: 1, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("Anterior: %.2f  |  Actual: %.2f  |  Consumo: %.0f kWh",
					reading.PreviousValue, reading.CurrentValue, reading.Consumption), props.Text{Top: 4, Size: fontSmall}),
			),
		),
	)

	// ===== FOOTER =====
	m.AddRows(
		row.New(6).Add(
			col.New(12).Add(
				text.New("Gracias por su pago", props.Text{Top: 1, Size: fontSmall, Align: align.Center, Style: fontstyle.Italic}),
			),
		),
	)
}

func (g *MarotoGenerator) applyWatermark(pdfData []byte) ([]byte, error) {
	rs := bytes.NewReader(pdfData)
	var out bytes.Buffer

	wm, err := api.TextWatermark("DEMO", "rot:45, scale:0.8, op:0.2, color:0.5 0.5 0.5", true, false, types.POINTS)
	if err != nil {
		return nil, fmt.Errorf("failed to create watermark: %w", err)
	}

	err = api.AddWatermarks(rs, &out, nil, wm, nil)
	if err != nil {
		return pdfData, nil
	}

	return out.Bytes(), nil
}

func formatDate(t time.Time) string {
	if t.IsZero() {
		return "-"
	}
	return t.Format("02/01/2006")
}

func formatDateShort(t time.Time) string {
	if t.IsZero() {
		return "-"
	}
	return t.Format("02/01")
}
