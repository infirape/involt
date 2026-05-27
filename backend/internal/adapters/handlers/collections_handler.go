package handlers

import (
	"context"
	"fmt"

	"connectrpc.com/connect"

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

	if req.Msg.ReadingId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("reading_id is required"))
	}

	if err := h.readingRepo.UpdatePaymentStatus(ctx, req.Msg.ReadingId, req.Msg.IsPaid); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.TogglePaymentStatusResponse{
		ReadingId: req.Msg.ReadingId,
		IsPaid:    req.Msg.IsPaid,
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

	readings, err := h.readingRepo.ListBySector(ctx, req.Msg.SectorId, req.Msg.Periods)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoReadings []*involtv1.Reading
	for _, r := range readings {
		protoReadings = append(protoReadings, domain.MapReadingToProto(&r))
	}

	return connect.NewResponse(&involtv1.GetCollectionsResponse{
		Readings: protoReadings,
	}), nil
}
