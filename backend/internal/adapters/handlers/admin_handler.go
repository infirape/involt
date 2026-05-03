package handlers

import (
	"context"
	"fmt"

	"connectrpc.com/connect"
	"github.com/infira/involt/backend/internal/adapters/auth"
	"github.com/infira/involt/backend/internal/domain"
	involtv1 "github.com/infira/involt/backend/internal/gen/involt/v1"
	"github.com/infira/involt/backend/internal/gen/involt/v1/involtv1connect"
	"github.com/infira/involt/backend/internal/ports"
	"golang.org/x/crypto/bcrypt"
	"time"
)

type AdminHandler struct {
	adminRepo    ports.AdminRepository
	metaRepo     ports.MetadataRepository
	customerRepo ports.CustomerRepository
	readingRepo  ports.ReadingRepository
	jwtService   *auth.JWTService
}

func NewAdminHandler(
	adminRepo ports.AdminRepository,
	metaRepo ports.MetadataRepository,
	customerRepo ports.CustomerRepository,
	readingRepo ports.ReadingRepository,
	jwtSecret string,
) *AdminHandler {
	return &AdminHandler{
		adminRepo:    adminRepo,
		metaRepo:     metaRepo,
		customerRepo: customerRepo,
		readingRepo:  readingRepo,
		jwtService:   auth.NewJWTService(jwtSecret),
	}
}

func (h *AdminHandler) Login(
	ctx context.Context,
	req *connect.Request[involtv1.LoginRequest],
) (*connect.Response[involtv1.LoginResponse], error) {
	user, err := h.adminRepo.GetUserByEmail(ctx, req.Msg.Email)
	if err != nil {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("invalid credentials"))
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Msg.Password))
	if err != nil {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("invalid credentials"))
	}

	token, err := h.jwtService.GenerateToken(user)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to generate token"))
	}

	return connect.NewResponse(&involtv1.LoginResponse{
		Token: token,
		User: &involtv1.User{
			Id:                user.ID,
			Email:             user.Email,
			Role:              mapDomainRoleToProto(user.Role),
			AssignedSectorIds: user.AssignedSectorIDs,
		},
	}), nil
}

func (h *AdminHandler) GetUsers(
	ctx context.Context,
	req *connect.Request[involtv1.GetUsersRequest],
) (*connect.Response[involtv1.GetUsersResponse], error) {
	users, err := h.adminRepo.ListUsers(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetUsersResponse{
		Users: make([]*involtv1.User, len(users)),
	}
	for i, u := range users {
		resp.Users[i] = &involtv1.User{
			Id:                u.ID,
			Email:             u.Email,
			Role:              mapDomainRoleToProto(u.Role),
			AssignedSectorIds: u.AssignedSectorIDs,
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *AdminHandler) UpsertUser(
	ctx context.Context,
	req *connect.Request[involtv1.UpsertUserRequest],
) (*connect.Response[involtv1.UpsertUserResponse], error) {
	u := req.Msg.User
	if u.Email == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("email is required"))
	}

	// Map proto to domain
	domainUser := &domain.User{
		ID:                u.Id,
		Email:             u.Email,
		Role:              mapProtoRoleToDomain(u.Role),
		AssignedSectorIDs: u.AssignedSectorIds,
	}

	if req.Msg.Password != "" {
		hash, err := bcrypt.GenerateFromPassword([]byte(req.Msg.Password), bcrypt.DefaultCost)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
		domainUser.PasswordHash = string(hash)
	} else if u.Id != "" {
		// If editing and no password provided, keep existing
		existing, err := h.adminRepo.GetUserByID(ctx, u.Id)
		if err == nil {
			domainUser.PasswordHash = existing.PasswordHash
		}
	}

	err := h.adminRepo.UpsertUser(ctx, domainUser)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpsertUserResponse{
		User: &involtv1.User{
			Id:                domainUser.ID,
			Email:             domainUser.Email,
			Role:              u.Role,
			AssignedSectorIds: domainUser.AssignedSectorIDs,
		},
	}), nil
}

func (h *AdminHandler) GetSectors(
	ctx context.Context,
	req *connect.Request[involtv1.GetSectorsRequest],
) (*connect.Response[involtv1.GetSectorsResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, nil)
	}

	sectors, err := h.metaRepo.ListSectors(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Filter sectors if not ADMIN
	var filtered []domain.Sector
	if user.Role == string(domain.RoleAdmin) {
		filtered = sectors
	} else {
		for _, s := range sectors {
			if contains(user.AssignedSectorIDs, s.ID) {
				filtered = append(filtered, s)
			}
		}
	}

	resp := &involtv1.GetSectorsResponse{
		Sectors: make([]*involtv1.Sector, len(filtered)),
	}
	for i, s := range filtered {
		resp.Sectors[i] = &involtv1.Sector{
			Id:          s.ID,
			CommunityId: s.CommunityID,
			Name:        s.Name,
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *AdminHandler) GetCustomers(
	ctx context.Context,
	req *connect.Request[involtv1.GetCustomersRequest],
) (*connect.Response[involtv1.GetCustomersResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, nil)
	}

	pageSize := req.Msg.PageSize
	if pageSize <= 0 {
		pageSize = 20
	}
	offset := (req.Msg.PageNumber - 1) * pageSize
	if offset < 0 {
		offset = 0
	}

	var allowedSectors []string
	if user.Role != string(domain.RoleAdmin) {
		allowedSectors = user.AssignedSectorIDs
	}
	if req.Msg.SectorId != "" {
		allowedSectors = []string{req.Msg.SectorId}
	}

	customers, total, err := h.customerRepo.List(ctx, allowedSectors, req.Msg.SearchQuery, int(pageSize), int(offset))
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetCustomersResponse{
		Customers:  make([]*involtv1.Customer, len(customers)),
		TotalCount: int32(total),
	}
	for i, c := range customers {
		resp.Customers[i] = &involtv1.Customer{
			Id:               c.ID,
			Code:             c.Code,
			Name:             c.Name,
			CommunityId:      c.CommunityID,
			SectorId:         c.SectorID,
			Address:          c.Address,
			ConnectionType:   mapDomainConnectionTypeToProto(c.ConnectionType),
			Tariff:           c.Tariff,
			MeterNumber:      c.MeterNumber,
			Latitude:         c.Latitude,
			Longitude:        c.Longitude,
			InitialReading:   c.InitialReading,
			LastReadingValue: c.LastReadingValue,
		}
	}

	return connect.NewResponse(resp), nil
}

func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}

func (h *AdminHandler) GetReadings(
	ctx context.Context,
	req *connect.Request[involtv1.GetReadingsRequest],
) (*connect.Response[involtv1.GetReadingsResponse], error) {
	user, ok := auth.GetUserFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, nil)
	}

	pageSize := req.Msg.PageSize
	if pageSize <= 0 {
		pageSize = 20
	}
	offset := (req.Msg.PageNumber - 1) * pageSize
	if offset < 0 {
		offset = 0
	}

	sectorID := req.Msg.SectorId
	if user.Role != string(domain.RoleAdmin) {
		if sectorID != "" {
			allowed := false
			for _, id := range user.AssignedSectorIDs {
				if id == sectorID {
					allowed = true
					break
				}
			}
			if !allowed {
				return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("sector not assigned"))
			}
		} else {
			// If non-admin and no sector selected, we MUST force filtering by assigned sectors.
			// However, since Repo.List currently takes a single string, we'll return an error 
			// or default to the first assigned sector if available.
			if len(user.AssignedSectorIDs) > 0 {
				sectorID = user.AssignedSectorIDs[0]
			} else {
				return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("no assigned sectors"))
			}
		}
	}

	readings, total, err := h.readingRepo.List(ctx, req.Msg.CustomerId, sectorID, req.Msg.Period, int(pageSize), int(offset))
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	resp := &involtv1.GetReadingsResponse{
		Readings:   make([]*involtv1.Reading, len(readings)),
		TotalCount: int32(total),
	}
	for i, r := range readings {
		resp.Readings[i] = &involtv1.Reading{
			Id:               r.ID,
			CustomerId:       r.CustomerID,
			PreviousValue:    r.PreviousValue,
			CurrentValue:     r.CurrentValue,
			Consumption:      r.Consumption,
			PhotoUrl:         r.PhotoURL,
			Timestamp:        r.Timestamp.Format(time.RFC3339),
			Latitude:         r.Latitude,
			Longitude:        r.Longitude,
			PeriodStart:      r.PeriodStart.Format(time.RFC3339),
			PeriodEnd:        r.PeriodEnd.Format(time.RFC3339),
			CargoFijo:        r.CargoFijo,
			AlumbradoPublico: r.AlumbradoPublico,
			Mantenimiento:    r.Mantenimiento,
			Adjustment:       r.Adjustment,
			Subtotal:         r.Subtotal,
			SaldoRedondeo:    r.SaldoRedondeo,
			RoundDifference:  r.RoundDifference,
			PreviousBalance:  r.PreviousBalance,
			OverdueTotal:     r.OverdueTotal,
			TotalToPay:       r.TotalToPay,
			ExpirationDate:   r.ExpirationDate.Format(time.RFC3339),
		}
	}

	return connect.NewResponse(resp), nil
}

func (h *AdminHandler) GetSettings(
	ctx context.Context,
	req *connect.Request[involtv1.GetSettingsRequest],
) (*connect.Response[involtv1.GetSettingsResponse], error) {
	settings, err := h.metaRepo.GetSettings(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.GetSettingsResponse{
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
	}), nil
}

func (h *AdminHandler) UpdateSettings(
	ctx context.Context,
	req *connect.Request[involtv1.UpdateSettingsRequest],
) (*connect.Response[involtv1.UpdateSettingsResponse], error) {
	s := req.Msg.Settings
	domainSettings := &domain.Settings{
		Municipalidad:   s.Municipalidad,
		Empresa:         s.Empresa,
		RUC:             s.Ruc,
		Direccion:       s.Direccion,
		Telefono:        s.Telefono,
		Email:           s.Email,
		DiasVencimiento: int(s.DiasVencimiento),
		TarifaKWh:       s.TarifaKwh,
		CargoFijo:       s.CargoFijo,
		Alumbrado:       s.Alumbrado,
		Mantenimiento:   s.Mantenimiento,
		IGV:             s.Igv,
	}

	err := h.metaRepo.SaveSettings(ctx, domainSettings)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpdateSettingsResponse{
		Settings: s,
	}), nil
}

func (h *AdminHandler) UpsertCustomer(
	ctx context.Context,
	req *connect.Request[involtv1.UpsertCustomerRequest],
) (*connect.Response[involtv1.UpsertCustomerResponse], error) {
	c := req.Msg.Customer
	contractStart, _ := time.Parse(time.RFC3339, c.ContractStart)

	domainCustomer := &domain.Customer{
		ID:               c.Id,
		Code:             c.Code,
		Name:             c.Name,
		CommunityID:      c.CommunityId,
		SectorID:         c.SectorId,
		Address:          c.Address,
		ConnectionType:   mapProtoConnectionTypeToDomain(c.ConnectionType),
		Tariff:           c.Tariff,
		MeterNumber:      c.MeterNumber,
		Latitude:         c.Latitude,
		Longitude:        c.Longitude,
		InitialReading:   c.InitialReading,
		LastReadingValue: c.LastReadingValue,
		ContractStart:    contractStart,
	}

	err := h.customerRepo.Save(ctx, domainCustomer)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.UpsertCustomerResponse{
		Customer: c,
	}), nil
}

func (h *AdminHandler) DeleteCustomer(
	ctx context.Context,
	req *connect.Request[involtv1.DeleteCustomerRequest],
) (*connect.Response[involtv1.DeleteCustomerResponse], error) {
	err := h.customerRepo.Delete(ctx, req.Msg.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&involtv1.DeleteCustomerResponse{
		Success: true,
	}), nil
}

func (h *AdminHandler) GetDashboardStats(
	ctx context.Context,
	req *connect.Request[involtv1.GetDashboardStatsRequest],
) (*connect.Response[involtv1.GetDashboardStatsResponse], error) {
	period := req.Msg.Period
	if period == "" {
		period = time.Now().Format("2006-01")
	}

	// 1. Total Customers
	customers, err := h.customerRepo.ListAll(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// 2. Total Users
	users, err := h.adminRepo.ListUsers(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// 3. Readings in Period
	readingsCount, _ := h.readingRepo.CountByPeriod(ctx, period)

	// 4. Pending in Period
	pendingCount, _ := h.readingRepo.CountPendingByPeriod(ctx, period)

	// 5. Business Metrics
	revenue, _ := h.readingRepo.SumRevenueByPeriod(ctx, period)
	consumption, _ := h.readingRepo.SumConsumptionByPeriod(ctx, period)

	// Calculate previous period (YYYY-MM)
	t, _ := time.Parse("2006-01", period)
	prevPeriod := t.AddDate(0, -1, 0).Format("2006-01")
	prevConsumption, _ := h.readingRepo.SumConsumptionByPeriod(ctx, prevPeriod)

	// 6. Sector Stats
	sectors, _ := h.metaRepo.ListSectors(ctx)
	sectorStats := make([]*involtv1.SectorStat, len(sectors))
	for i, s := range sectors {
		total, _ := h.customerRepo.CountBySector(ctx, s.ID)
		registered, _ := h.readingRepo.CountBySectorAndPeriod(ctx, s.ID, period)
		sConsumption, _ := h.readingRepo.SumConsumptionBySectorAndPeriod(ctx, s.ID, period)

		progress := int32(0)
		if total > 0 {
			progress = int32((registered * 100) / total)
		}

		sectorStats[i] = &involtv1.SectorStat{
			SectorId:           s.ID,
			SectorName:         s.Name,
			RegisteredCount:    int32(registered),
			TotalCount:         int32(total),
			ProgressPercentage: progress,
			TotalConsumption:   sConsumption,
		}
	}

	return connect.NewResponse(&involtv1.GetDashboardStatsResponse{
		TotalCustomers:        int32(len(customers)),
		TotalUsers:            int32(len(users)),
		TotalReadingsPeriod:   int32(readingsCount),
		PendingReadingsPeriod: int32(pendingCount),
		TotalRevenue:          revenue,
		TotalConsumptionKwh:   consumption,
		PreviousConsumptionKwh: prevConsumption,
		SectorStats:           sectorStats,
	}), nil
}

func mapDomainConnectionTypeToProto(conn domain.ConnectionType) involtv1.ConnectionType {
	switch conn {
	case domain.ConnectionTypeMonofasica:
		return involtv1.ConnectionType_CONNECTION_TYPE_MONOFASICA
	case domain.ConnectionTypeTrifasica:
		return involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA
	default:
		return involtv1.ConnectionType_CONNECTION_TYPE_UNSPECIFIED
	}
}

func mapDomainRoleToProto(role domain.UserRole) involtv1.UserRole {
	switch role {
	case domain.RoleAdmin:
		return involtv1.UserRole_USER_ROLE_ADMIN
	case domain.RoleSupervisor:
		return involtv1.UserRole_USER_ROLE_SUPERVISOR
	case domain.RoleReader:
		return involtv1.UserRole_USER_ROLE_READER
	default:
		return involtv1.UserRole_USER_ROLE_UNSPECIFIED
	}
}

func mapProtoRoleToDomain(role involtv1.UserRole) domain.UserRole {
	switch role {
	case involtv1.UserRole_USER_ROLE_ADMIN:
		return domain.RoleAdmin
	case involtv1.UserRole_USER_ROLE_SUPERVISOR:
		return domain.RoleSupervisor
	case involtv1.UserRole_USER_ROLE_READER:
		return domain.RoleReader
	default:
		return domain.RoleReader // Default to safest
	}
}

func mapProtoConnectionTypeToDomain(conn involtv1.ConnectionType) domain.ConnectionType {
	switch conn {
	case involtv1.ConnectionType_CONNECTION_TYPE_MONOFASICA:
		return domain.ConnectionTypeMonofasica
	case involtv1.ConnectionType_CONNECTION_TYPE_TRIFASICA:
		return domain.ConnectionTypeTrifasica
	default:
		return domain.ConnectionTypeMonofasica
	}
}

// Ensure AdminHandler implements the generated interface
var _ involtv1connect.AdminServiceHandler = (*AdminHandler)(nil)
