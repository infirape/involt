package handlers

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/gen/involt/v1/involtv1connect"
	"github.com/infira/involt/backend/internal/ports"
)

type SyncHandler struct {
	metaRepo     ports.MetadataRepository
	customerRepo ports.CustomerRepository
	readingRepo  ports.ReadingRepository
	pdfGen       ports.ReceiptGenerator
}

func NewSyncHandler(
	metaRepo ports.MetadataRepository,
	customerRepo ports.CustomerRepository,
	readingRepo ports.ReadingRepository,
	pdfGen ports.ReceiptGenerator,
) *SyncHandler {
	return &SyncHandler{
		metaRepo:     metaRepo,
		customerRepo: customerRepo,
		readingRepo:  readingRepo,
		pdfGen:       pdfGen,
	}
}

func (h *SyncHandler) PullMetadata(
	ctx context.Context,
	req *connect.Request[involtv1.PullMetadataRequest],
) (*connect.Response[involtv1.PullMetadataResponse], error) {
	communities, err := h.metaRepo.ListCommunities(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list communities: %w", err))
	}

	sectors, err := h.metaRepo.ListSectors(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list sectors: %w", err))
	}

	customers, err := h.customerRepo.ListAll(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to list customers: %w", err))
	}

	config, err := h.metaRepo.GetAppConfig(ctx)
	if err != nil {
		log.Printf("⚠️ Error getting app config: %v", err)
		config = &domain.AppConfig{}
	}

	settings, err := h.metaRepo.GetSettings(ctx)
	if err != nil {
		log.Printf("⚠️ Error getting settings: %v", err)
		settings = &domain.Settings{}
	}

	resp := &involtv1.PullMetadataResponse{
		Communities: make([]*involtv1.Community, len(communities)),
		Sectors:     make([]*involtv1.Sector, len(sectors)),
		Customers:   make([]*involtv1.Customer, len(customers)),
		Config: &involtv1.AppConfig{
			MapUrlTemplate: config.MapURLTemplate,
			MapUserAgent:   config.MapUserAgent,
		},
		Settings: &involtv1.Settings{
			Municipalidad:   settings.Municipalidad,
			Empresa:         settings.Empresa,
			Ruc:             settings.RUC,
			Direccion:       settings.Direccion,
			Telefono:        settings.Telefono,
			Email:           settings.Email,
			DiasVencimiento: int32(settings.DiasVencimiento),
			TarifaKwh:       settings.TarifaKWh,
			CargoFijo:       settings.CargoFijo,
			Alumbrado:       settings.Alumbrado,
			Mantenimiento:   settings.Mantenimiento,
			Igv:             settings.IGV,
		},
	}

	for i, c := range communities {
		resp.Communities[i] = &involtv1.Community{Id: c.ID, Name: c.Name}
	}

	for i, s := range sectors {
		resp.Sectors[i] = &involtv1.Sector{Id: s.ID, CommunityId: s.CommunityID, Name: s.Name}
	}

	for i, c := range customers {
		connType := involtv1.ConnectionType_CONNECTION_TYPE_MONOFASICA
		if c.ConnectionType == domain.ConnectionTypeTrifasica {
			connType = involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA
		}

		resp.Customers[i] = &involtv1.Customer{
			Id:             c.ID,
			Code:           c.Code,
			Name:           c.Name,
			CommunityId:    c.CommunityID,
			SectorId:       c.SectorID,
			ConnectionType: connType,
			Tariff:         c.Tariff,
			MeterNumber:    c.MeterNumber,
			Latitude:       c.Latitude,
			Longitude:      c.Longitude,
			LastReadingValue: c.LastReadingValue,
			InitialReading: c.InitialReading,
		}
	}

	// Fetch and map readings
	readings, err := h.readingRepo.ListAll(ctx)
	if err != nil {
		log.Printf("⚠️ Error getting readings for sync: %v", err)
	} else {
		resp.Readings = make([]*involtv1.Reading, len(readings))
		for i, r := range readings {
			resp.Readings[i] = &involtv1.Reading{
				Id:               r.ID,
				CustomerId:       r.CustomerID,
				PreviousValue:    r.PreviousValue,
				CurrentValue:     r.CurrentValue,
				ConsumptionKwh:   r.Consumption,
				PhotoUrl:         r.PhotoURL,
				Timestamp:        r.Timestamp.Unix(),
				Latitude:         r.Latitude,
				Longitude:        r.Longitude,
				CargoFijo:        r.CargoFijo,
				AlumbradoPublico: r.AlumbradoPublico,
				SaldoRedondeo:    r.SaldoRedondeo,
				Period:           r.Timestamp.Format("2006-01"),
			}
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *SyncHandler) PushReadings(
	ctx context.Context,
	req *connect.Request[involtv1.PushReadingsRequest],
) (*connect.Response[involtv1.PushReadingsResponse], error) {
	syncedCount := 0
	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	for _, r := range req.Msg.Readings {
		
		// Use the previous value sent by the app to ensure consistency with the UI
		prevVal := r.PreviousValue
		consumption := r.CurrentValue - prevVal
		if consumption < 0 {
			consumption = 0
		}

		// Use settings for charges if not provided by app
		cargoFijo := r.CargoFijo
		if cargoFijo == 0 {
			cargoFijo = settings.CargoFijo
		}

		alumbrado := r.AlumbradoPublico
		if alumbrado == 0 {
			alumbrado = settings.Alumbrado
		}

		// Calculate components
		consumptionCharge := consumption * settings.TarifaKWh
		subtotal := consumptionCharge + cargoFijo + alumbrado + settings.Mantenimiento
		total := subtotal + r.SaldoRedondeo

		reading := &domain.Reading{
			ID:               r.Id,
			CustomerID:       r.CustomerId,
			PreviousValue:    prevVal,
			CurrentValue:     r.CurrentValue,
			Consumption:      consumption,
			PhotoURL:         r.PhotoUrl,
			Timestamp:        time.Unix(r.Timestamp, 0),
			Latitude:         r.Latitude,
			Longitude:        r.Longitude,
			CargoFijo:        cargoFijo,
			AlumbradoPublico: alumbrado,
			Mantenimiento:    settings.Mantenimiento, // We need to store this in the reading
			Subtotal:         subtotal,
			TotalToPay:       total,
			SaldoRedondeo:    r.SaldoRedondeo,
		}
		if err := h.readingRepo.Save(ctx, reading); err != nil {
			log.Printf("⚠️ Error saving reading %s: %v", r.Id, err)
			continue
		}
		syncedCount++
	}

	return connect.NewResponse(&involtv1.PushReadingsResponse{
		Success:     true,
		SyncedCount: int32(syncedCount),
	}), nil
}

func (h *SyncHandler) UploadPhoto(
	ctx context.Context,
	req *connect.Request[involtv1.UploadPhotoRequest],
) (*connect.Response[involtv1.UploadPhotoResponse], error) {
	fileName := fmt.Sprintf("%d_%s", time.Now().UnixNano(), req.Msg.FileName)
	filePath := fmt.Sprintf("uploads/%s", fileName)

	err := os.WriteFile(filePath, req.Msg.Data, 0644)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to save photo: %w", err))
	}

	// For now, returning a local path. In production, this would be a full URL (S3/CDN).
	return connect.NewResponse(&involtv1.UploadPhotoResponse{
		Url: filePath,
	}), nil
}

func (h *SyncHandler) DownloadReceipt(
	ctx context.Context,
	req *connect.Request[involtv1.DownloadReceiptRequest],
) (*connect.Response[involtv1.DownloadReceiptResponse], error) {
	reading, err := h.readingRepo.GetByID(ctx, req.Msg.ReadingId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("reading %s not found: %w", req.Msg.ReadingId, err))
	}

	customer, err := h.customerRepo.GetByID(ctx, reading.CustomerID)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("customer %s not found: %w", reading.CustomerID, err))
	}

	settings, _ := h.metaRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	communities, _ := h.metaRepo.ListCommunities(ctx)
	commName := ""
	for _, c := range communities {
		if c.ID == customer.CommunityID {
			commName = c.Name
			break
		}
	}

	sectors, _ := h.metaRepo.ListSectors(ctx)
	sectName := ""
	for _, s := range sectors {
		if s.ID == customer.SectorID {
			sectName = s.Name
			break
		}
	}

	pdfData, err := h.pdfGen.Generate(ctx, reading, customer, settings, commName, sectName)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to generate PDF: %w", err))
	}

	return connect.NewResponse(&involtv1.DownloadReceiptResponse{
		PdfData: pdfData,
	}), nil
}

// Ensure SyncHandler implements the generated interface
var _ involtv1connect.SyncServiceHandler = (*SyncHandler)(nil)
