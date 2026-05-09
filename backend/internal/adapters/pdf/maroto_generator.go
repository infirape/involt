package pdf

import (
	"bytes"
	"context"
	"fmt"
	"time"

	"github.com/infira/involt/backend/internal/domain"
	"github.com/johnfercher/maroto/v2"
	"github.com/johnfercher/maroto/v2/pkg/components/col"
	"github.com/johnfercher/maroto/v2/pkg/components/image"
	"github.com/johnfercher/maroto/v2/pkg/components/row"
	"github.com/johnfercher/maroto/v2/pkg/components/text"
	"github.com/johnfercher/maroto/v2/pkg/config"
	"github.com/johnfercher/maroto/v2/pkg/consts/align"
	"github.com/johnfercher/maroto/v2/pkg/consts/border"
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

func (g *MarotoGenerator) Generate(ctx context.Context, reading *domain.Reading, customer *domain.Customer, settings *domain.Settings, community, sector string) ([]byte, error) {
	cfg := config.NewBuilder().
		WithPageSize(pagesize.A4).
		WithLeftMargin(31).
		WithRightMargin(31).
		WithTopMargin(15).
		Build()

	m := maroto.New(cfg)
	g.addReceiptComponents(m, reading, customer, settings, community, sector)

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return g.applyWatermark(document.GetBytes())
}

func (g *MarotoGenerator) GenerateBatch(ctx context.Context, readings []domain.Reading, customers map[string]*domain.Customer, settings *domain.Settings) ([]byte, error) {
	if len(readings) == 0 {
		return nil, nil
	}

	cfg := config.NewBuilder().
		WithPageSize(pagesize.A4).
		WithLeftMargin(31).
		WithRightMargin(31).
		WithTopMargin(15).
		Build()
	m := maroto.New(cfg)

	for i, r := range readings {
		customer := customers[r.CustomerID]
		if customer == nil {
			customer = &domain.Customer{Name: "Desconocido", Code: "N/A"}
		}
		g.addReceiptComponents(m, &r, customer, settings, customer.CommunityName, customer.SectorName)
		
		// If it's the first receipt of the page, add a separator
		if (i+1)%2 != 0 && (i+1) < len(readings) {
			m.AddRows(row.New(20).Add(
				col.New(12).WithStyle(&props.Cell{BorderType: border.Bottom, BorderThickness: 0.1}),
			))
		} else {
			m.AddRows(row.New(10))
		}
	}

	document, err := m.Generate()
	if err != nil {
		return nil, err
	}

	return g.applyWatermark(document.GetBytes())
}

func (g *MarotoGenerator) addReceiptComponents(m core.Maroto, reading *domain.Reading, customer *domain.Customer, settings *domain.Settings, community, sector string) {
	fontSmall := 7.5
	fontNormal := 9.0
	fontLarge := 12.0
	borderThick := 0.6 

	// ===== LOGO SECTION =====
	m.AddRows(
		row.New(20).Add(
			col.New(12).Add(
				image.NewFromFile("assets/logo_chetilla.png", props.Rect{
					Center:  true,
					Percent: 40,
				}),
			),
		),
	)

	// ===== HEADER SECTION =====
	m.AddRows(
		row.New(18).Add(
			col.New(7).Add(
				text.New(community, props.Text{Left: 1, Top: 1, Size: fontSmall}),
				text.New(fmt.Sprintf("Para consulta su código es: %s", customer.Code), props.Text{Left: 1, Top: 4.5, Size: fontSmall, Style: fontstyle.Bold}),
				text.New(customer.Name, props.Text{Left: 1, Top: 8, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(customer.Address, props.Text{Left: 1, Top: 11.5, Size: fontSmall}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Top, BorderThickness: borderThick}),
			col.New(5).Add(
				text.New(sector, props.Text{Right: 1, Top: 1, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				text.New(settings.Municipalidad, props.Text{Right: 1, Top: 4.5, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				text.New(settings.Empresa, props.Text{Right: 1, Top: 8, Size: fontSmall, Align: align.Right}),
			).WithStyle(&props.Cell{BorderType: border.Right | border.Top, BorderThickness: borderThick}),
		),
	)

	m.AddRows(
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick})),
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick})),
	)

	// ===== DATOS DEL SUMINISTRO Y CONSUMO TITLE =====
	m.AddRows(
		row.New(6).Add(
			col.New(12).Add(
				text.New("DATOS DEL SUMINISTRO Y CONSUMO", props.Text{Left: 3, Top: 1, Size: fontNormal, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick}),
		),
	)

	m.AddRows(
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick})),
	)

	// ===== BODY SECTION =====
	m.AddRows(
		row.New(48).Add(
			// Left Column
			col.New(5).Add(
				text.New("Tipo de Conexión:", props.Text{Left: 3, Top: 2, Size: fontSmall}),
				text.New(string(customer.ConnectionType), props.Text{Top: 2, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Tarifa:", props.Text{Left: 3, Top: 5, Size: fontSmall}),
				text.New(fmt.Sprintf("%.4f", settings.TarifaKWh), props.Text{Top: 5, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Medidor N°:", props.Text{Left: 3, Top: 8, Size: fontSmall}),
				text.New(customer.MeterNumber, props.Text{Top: 8, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Lectura Anterior:", props.Text{Left: 3, Top: 15, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.PreviousValue), props.Text{Top: 15, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Lectura Actual:", props.Text{Left: 3, Top: 18, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.CurrentValue), props.Text{Top: 18, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Consumo:", props.Text{Left: 3, Top: 25, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("%.2f kWh", reading.Consumption), props.Text{Top: 25, Size: fontNormal, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Fecha de Emisión:", props.Text{Left: 3, Top: 28, Size: fontSmall}),
				text.New(formatDate(reading.Timestamp), props.Text{Top: 28, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left, BorderThickness: borderThick}),
			
			col.New(2).Add(), // GAP
			
			// Right Column
			col.New(5).Add(
				text.New(fmt.Sprintf("Recibo por Consumo del %s al %s", formatDateShort(reading.PeriodStart), formatDateShort(reading.PeriodEnd)), props.Text{Right: 3, Top: 2, Size: fontSmall, Align: align.Right}),
				
				text.New("Consumo (kWh x Tarifa):", props.Text{Top: 8, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.Consumption*settings.TarifaKWh), props.Text{Right: 3, Top: 8, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Cargo Fijo:", props.Text{Top: 11, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.CargoFijo), props.Text{Right: 3, Top: 11, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Alumbrado Público:", props.Text{Top: 14, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.AlumbradoPublico), props.Text{Right: 3, Top: 14, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Mantenimiento:", props.Text{Top: 17, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.Mantenimiento), props.Text{Right: 3, Top: 17, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("SUBTOTAL:", props.Text{Top: 21, Size: fontSmall, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("%.2f", reading.Subtotal), props.Text{Right: 3, Top: 21, Size: fontSmall, Align: align.Right, Style: fontstyle.Bold}),
				
				text.New("Saldo Anterior:", props.Text{Top: 27, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.PreviousBalance), props.Text{Right: 3, Top: 27, Size: fontSmall, Align: align.Right}),
				
				text.New("Recibos Vencidos:", props.Text{Top: 30, Size: fontSmall}),
				text.New(fmt.Sprintf("%.2f", reading.OverdueTotal), props.Text{Right: 3, Top: 30, Size: fontSmall, Align: align.Right}),
				
				text.New("TOTAL RECIBO:", props.Text{Top: 37, Size: fontNormal, Style: fontstyle.Bold}),
				text.New(fmt.Sprintf("S/ %.2f", reading.TotalToPay), props.Text{Right: 3, Top: 37, Size: fontNormal, Align: align.Right, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Right, BorderThickness: borderThick}),
		),
	)

	m.AddRows(row.New(3).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick})))

	// ===== WARNING BOX =====
	m.AddRows(
		row.New(10).Add(
			col.New(1).WithStyle(&props.Cell{BorderType: border.Left, BorderThickness: borderThick}),
			col.New(10).Add(
				text.New("Si paga hasta la fecha de vencimiento evitará cortes y gastos innecesarios.", props.Text{Top: 3, Size: fontSmall, Align: align.Center, Style: fontstyle.Italic}),
			).WithStyle(&props.Cell{BorderType: border.Full, BorderThickness: 0.6}),
			col.New(1).WithStyle(&props.Cell{BorderType: border.Right, BorderThickness: borderThick}),
		),
	)

	m.AddRows(row.New(3).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick})))

	// ===== TOTAL SECTION =====
	m.AddRows(
		row.New(12).Add(
			col.New(12).Add(
				text.New(fmt.Sprintf("TOTAL A PAGAR: S/ %.2f", reading.TotalToPay), props.Text{Right: 3, Top: 4, Size: fontLarge, Align: align.Right, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Right, BorderThickness: borderThick}),
		),
	)

	// Final divider and Vencimiento
	m.AddRows(
		row.New(0.5).Add(col.New(12).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick})),
		row.New(12).Add(
			col.New(12).Add(
				text.New(fmt.Sprintf("FECHA DE VENCIMIENTO: %s", formatDate(reading.ExpirationDate)), props.Text{Top: 3, Size: fontNormal, Align: align.Center, Style: fontstyle.Bold}),
			).WithStyle(&props.Cell{BorderType: border.Left | border.Right | border.Bottom, BorderThickness: borderThick}),
		),
	)
}

func (g *MarotoGenerator) applyWatermark(pdfData []byte) ([]byte, error) {
	rs := bytes.NewReader(pdfData)
	var out bytes.Buffer

	wm, err := api.TextWatermark("DEMO", "rot:45, scale:0.8, op:0.1, color:0.5 0.5 0.5", true, false, types.POINTS)
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
	return t.Format("02/01/2006")
}
