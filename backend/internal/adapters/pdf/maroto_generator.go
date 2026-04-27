package pdf

import (
	"bytes"
	"context"
	"fmt"
	"io"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/johnfercher/maroto/v2"
	"github.com/johnfercher/maroto/v2/pkg/components/code"
	"github.com/johnfercher/maroto/v2/pkg/components/col"
	"github.com/johnfercher/maroto/v2/pkg/components/row"
	"github.com/johnfercher/maroto/v2/pkg/components/text"
	"github.com/johnfercher/maroto/v2/pkg/consts/align"
	"github.com/johnfercher/maroto/v2/pkg/consts/fontstyle"
	"github.com/johnfercher/maroto/v2/pkg/props"
	"github.com/pdfcpu/pdfcpu/pkg/api"
	"github.com/pdfcpu/pdfcpu/pkg/pdfcpu/model"
)

type MarotoGenerator struct{}

func NewMarotoGenerator() *MarotoGenerator {
	return &MarotoGenerator{}
}

func (g *MarotoGenerator) Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer) ([]byte, error) {
	m := maroto.New()
	g.addReceiptComponents(m, reading, customer)

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return g.applyWatermark(document.GetBytes())
}

func (g *MarotoGenerator) GenerateBatch(ctx context.Context, readings []domain.Reading, customers map[string]*domain.Customer) ([]byte, error) {
	m := maroto.New()

	for i, r := range readings {
		customer := customers[r.CustomerID]
		if customer == nil {
			customer = &domain.Customer{Name: "Desconocido", Code: "N/A"}
		}

		g.addReceiptComponents(m, &r, customer)

		// Every 2 receipts, Maroto will handle the page if we reach the limit, 
		// but we want to ensure they are well spaced. 
		// Since each receipt is approx 140mm, 2 fit in 297mm.
		if i%2 == 0 && i < len(readings)-1 {
			// Spacer or divider could go here
		}
	}

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return g.applyWatermark(document.GetBytes())
}

func (g *MarotoGenerator) addReceiptComponents(m maroto.Maroto, reading *domain.Reading, customer *domain.Customer) {
	// Header
	m.AddRows(
		row.New(15).Add(
			col.New(8).Add(
				text.New("RECIBO DE LECTURA - INVOLT", props.Text{
					Top:   5,
					Style: fontstyle.Bold,
					Size:  14,
					Align: align.Left,
				}),
			),
			col.New(4).Add(
				text.New(fmt.Sprintf("Fecha: %s", reading.Timestamp.Format("02/01/2006")), props.Text{
					Top:   5,
					Align: align.Right,
					Size:  10,
				}),
			),
		),
	)

	// Customer Info & Consumption (Side by side for compact view)
	m.AddRows(
		row.New(25).Add(
			col.New(6).Add(
				text.New("DATOS DEL CLIENTE", props.Text{Style: fontstyle.Bold, Size: 9}),
				text.New(fmt.Sprintf("Nombre: %s", customer.Name), props.Text{Top: 4, Size: 8}),
				text.New(fmt.Sprintf("Código: %s", customer.Code), props.Text{Top: 8, Size: 8}),
				text.New(fmt.Sprintf("Medidor: %s", customer.MeterNumber), props.Text{Top: 12, Size: 8}),
			),
			col.New(6).Add(
				text.New("DETALLE DE CONSUMO", props.Text{Style: fontstyle.Bold, Size: 9}),
				text.New(fmt.Sprintf("Lectura Anterior: %.2f", reading.PreviousValue), props.Text{Top: 4, Size: 8}),
				text.New(fmt.Sprintf("Lectura Actual: %.2f", reading.CurrentValue), props.Text{Top: 8, Size: 8}),
				text.New(fmt.Sprintf("Consumo: %.2f kWh", reading.Consumption), props.Text{Top: 12, Style: fontstyle.Bold, Size: 8}),
			),
		),
	)

	// Financial Data
	m.AddRows(
		row.New(5).Add(col.New(12).Add(text.New("IMPORTES A PAGAR", props.Text{Style: fontstyle.Bold, Size: 9}))),
		row.New(4).Add(col.New(8).Add(text.New("Cargo Fijo:", props.Text{Size: 8})), col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.CargoFijo), props.Text{Size: 8, Align: align.Right}))),
		row.New(4).Add(col.New(8).Add(text.New("Alumbrado Público:", props.Text{Size: 8})), col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.AlumbradoPublico), props.Text{Size: 8, Align: align.Right}))),
		row.New(4).Add(col.New(8).Add(text.New("Saldo Redondeo:", props.Text{Size: 8})), col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.SaldoRedondeo), props.Text{Size: 8, Align: align.Right}))),
		row.New(8).Add(
			col.New(8).Add(text.New("TOTAL A PAGAR:", props.Text{Style: fontstyle.Bold, Size: 11})),
			col.New(4).Add(text.New(fmt.Sprintf("S/ %.2f", reading.TotalToPay), props.Text{Style: fontstyle.Bold, Size: 11, Align: align.Right})),
		),
	)

	// QR & Verification
	m.AddRows(
		row.New(35).Add(
			col.New(4).Add(
				code.NewQr(fmt.Sprintf("INVOLT|%s|%.2f", reading.ID, reading.TotalToPay), props.Rect{
					Center:  true,
					Percent: 90,
				}),
			),
			col.New(8).Add(
				text.New("Verifique su recibo escaneando el código QR.", props.Text{
					Top:  15,
					Size: 7,
					Style: fontstyle.Italic,
					Align: align.Center,
				}),
				text.New("----------------------------------------------------------------", props.Text{
					Top: 30,
					Align: align.Center,
					Size: 8,
				}),
			),
		),
	)
}

func (g *MarotoGenerator) applyWatermark(pdfData []byte) ([]byte, error) {
	rs := bytes.NewReader(pdfData)
	var out bytes.Buffer

	// Watermark configuration: "DEMO", diagonal, light gray, semi-transparent
	wm, err := api.TextWatermark("DEMO", "rot:45, s:0.8, op:0.2, c:0.5 0.5 0.5", true, false, model.POINTS)
	if err != nil {
		return nil, fmt.Errorf("failed to create watermark: %w", err)
	}

	err = api.AddWatermarks(rs, &out, nil, wm, nil)
	if err != nil {
		// If watermark fails, return original data instead of erroring out to be resilient
		return pdfData, nil
	}

	return out.Bytes(), nil
}

// Helper to wrap bytes.Reader as ReadSeeker if needed, but api.AddWatermarks takes io.ReadSeeker
var _ io.ReadSeeker = (*bytes.Reader)(nil)

