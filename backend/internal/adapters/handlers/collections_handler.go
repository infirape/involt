package handlers

import (
	"context"
	"fmt"

	"connectrpc.com/connect"
	"github.com/google/uuid"

	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
)

// TogglePaymentStatus updates the is_paid flag of a reading.
func (h *AdminHandler) TogglePaymentStatus(
	ctx context.Context,
	req *connect.Request[involtv1.TogglePaymentStatusRequest],
) (*connect.Response[involtv1.TogglePaymentStatusResponse], error) {
	_, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}

	readingID := req.Msg.ReadingId
	isPaid := req.Msg.IsPaid

	if readingID == "" {
		if req.Msg.CustomerId == "" || req.Msg.Period == "" {
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("reading_id or both customer_id and period are required"))
		}

		// Look up reading
		reading, err := h.readingRepo.GetByCustomerAndPeriod(ctx, req.Msg.CustomerId, req.Msg.Period)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}

		if reading != nil {
			readingID = reading.ID
		} else {
			// Create a default/dummy reading representing a flat/fixed fee for this period
			// Get default settings to retrieve cargo_fijo, mantenimiento, alumbrado_publico
			settings, err := h.metaRepo.GetSettings(ctx)
			if err != nil {
				return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to get default settings: %w", err))
			}

			// Generate a new UUID
			newUUID := uuid.New().String()
			readingID = newUUID

			// Create reading record
			cargoFijo := settings.CargoFijo
			alumbrado := settings.Alumbrado
			mantenimiento := settings.Mantenimiento
			totalToPay := cargoFijo + alumbrado + mantenimiento

			if req.Msg.TotalToPay > 0 {
				totalToPay = req.Msg.TotalToPay
				cargoFijo = req.Msg.TotalToPay
				alumbrado = 0
				mantenimiento = 0
			}

			newReading := &domain.Reading{
				ID:               newUUID,
				CustomerID:       req.Msg.CustomerId,
				PreviousValue:    0,
				CurrentValue:     0,
				Consumption:      0,
				Period:           req.Msg.Period,
				CargoFijo:        cargoFijo,
				AlumbradoPublico: alumbrado,
				Mantenimiento:    mantenimiento,
				TotalToPay:       totalToPay,
				Observation:      req.Msg.Observation,
				IsPaid:           isPaid,
			}

			if err := h.readingRepo.Save(ctx, newReading); err != nil {
				return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to save dummy reading: %w", err))
			}
		}
	}

	if err := h.readingRepo.UpdatePaymentStatus(ctx, readingID, isPaid); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.TogglePaymentStatusResponse{
		ReadingId: readingID,
		IsPaid:    isPaid,
	}), nil
}

// GetCollections returns the payment matrix for a sector across the given periods.
func (h *AdminHandler) GetCollections(
	ctx context.Context,
	req *connect.Request[involtv1.GetCollectionsRequest],
) (*connect.Response[involtv1.GetCollectionsResponse], error) {
	_, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("authentication required"))
	}

	if req.Msg.SectorId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("sector_id is required"))
	}

	customers, err := h.customerRepo.ListBySector(ctx, req.Msg.SectorId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	readings, err := h.readingRepo.ListBySector(ctx, req.Msg.SectorId, req.Msg.Periods)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	customerRows := make([]*involtv1.CollectionCustomer, 0, len(customers))
	readingsByCustomer := make(map[string][]*involtv1.Reading, len(customers))
	customerNamesByID := make(map[string]string, len(customers))
	for _, customer := range customers {
		customerNamesByID[customer.ID] = customer.Name
		readingsByCustomer[customer.ID] = nil
	}

	protoReadings := make([]*involtv1.Reading, 0, len(readings))
	for _, r := range readings {
		if r.CustomerName == "" {
			r.CustomerName = customerNamesByID[r.CustomerID]
		}
		protoReading := domain.MapReadingToProto(&r)
		protoReadings = append(protoReadings, protoReading)
		if _, ok := readingsByCustomer[r.CustomerID]; ok {
			readingsByCustomer[r.CustomerID] = append(readingsByCustomer[r.CustomerID], protoReading)
		}
	}

	for _, customer := range customers {
		customer := customer
		customerRows = append(customerRows, &involtv1.CollectionCustomer{
			Customer: domain.MapCustomerToProto(&customer),
			Readings: readingsByCustomer[customer.ID],
		})
	}

	return connect.NewResponse(&involtv1.GetCollectionsResponse{
		Readings:  protoReadings,
		Customers: customerRows,
	}), nil
}
