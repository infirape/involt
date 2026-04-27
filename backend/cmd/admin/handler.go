package admin

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/infira/involt/backend/internal/adapters/repositories"
	"github.com/infira/involt/backend/internal/domain"
	"github.com/infira/involt/backend/internal/ports"
)

type AdminHandler struct {
	settingsRepo *repositories.SettingsRepository
	customerRepo ports.CustomerRepository
	readingRepo  ports.ReadingRepository
	metadataRepo ports.MetadataRepository
	pdfGen       ports.ReceiptGenerator
	templates    *template.Template
}

func NewAdminHandler(
	settingsRepo *repositories.SettingsRepository,
	customerRepo ports.CustomerRepository,
	readingRepo ports.ReadingRepository,
	metadataRepo ports.MetadataRepository,
	pdfGen ports.ReceiptGenerator,
) *AdminHandler {
	templates := template.New("admin").Funcs(template.FuncMap{
		"multiply": func(a, b float64) float64 {
			return a * b
		},
		"formatPeriod": func(p string) string {
			if len(p) != 7 {
				return p
			}
			year := p[:4]
			month := p[5:]
			months := map[string]string{
				"01": "Enero", "02": "Febrero", "03": "Marzo", "04": "Abril",
				"05": "Mayo", "06": "Junio", "07": "Julio", "08": "Agosto",
				"09": "Septiembre", "10": "Octubre", "11": "Noviembre", "12": "Diciembre",
			}
			return fmt.Sprintf("%s %s", months[month], year)
		},
	})
	
	templates, err := templates.ParseGlob("cmd/admin/templates/*.html")
	if err != nil {
		panic(err)
	}

	return &AdminHandler{
		settingsRepo: settingsRepo,
		customerRepo: customerRepo,
		readingRepo:  readingRepo,
		metadataRepo: metadataRepo,
		pdfGen:       pdfGen,
		templates:    templates,
	}
}

func (h *AdminHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Path
	log.Printf("Admin handler: path=%s", path)

	switch {
	case path == "/admin", path == "/admin/", path == "/admin/index.html":
		h.Dashboard(w, r)
	case path == "/admin/customers", path == "/admin/customers.html":
		h.Customers(w, r)
	case path == "/admin/settings", path == "/admin/settings.html":
		h.Settings(w, r)
	case path == "/admin/stats/customers":
		h.StatsCustomers(w, r)
	case path == "/admin/stats/readings":
		h.StatsReadings(w, r)
	case path == "/admin/stats/pending":
		h.StatsPending(w, r)
	case strings.HasPrefix(path, "/admin/customers/pdf/"):
		h.DownloadReceipt(w, r)
	case strings.HasPrefix(path, "/admin/customers/detail/"):
		h.CustomerDetail(w, r)
	case strings.HasPrefix(path, "/admin/customers/receipt/"):
		h.CustomerReceipt(w, r)
	case strings.HasPrefix(path, "/admin/customers/edit/"):
		h.CustomerEdit(w, r)
	case path == "/admin/set-period":
		h.SetPeriod(w, r)
	case path == "/admin/customers/save":
		h.SaveCustomer(w, r)
	case path == "/admin/settings/save":
		h.SaveSettings(w, r)
	case path == "/":
		http.Redirect(w, r, "/admin", http.StatusFound)
	default:
		log.Printf("Admin: 404 for path=%s", path)
		http.NotFound(w, r)
	}
}

type PageData struct {
	Settings   domain.Settings
	Stats      StatsData
	ActivePage string
	Periods    []string
	Period     string
	Filter     Filter
}

type StatsData struct {
	Customers int
	Readings  int
	Pending   int
}

type ListData struct {
	Customers   []CustomerRow
	Communities []domain.Community
	Sectors     []domain.Sector
	Stats       CustomerStats
	Page        PageInfo
	Filter      Filter
	ActivePage  string
	Periods     []string
}

type CustomerRow struct {
	Code        string
	Name        string
	Community   string
	Sector      string
	MeterNumber string
	LastReading string
	Consumption string
	CargoFijo   string
	Alumbrado   string
	Total       string
	Status      string
	StatusClass string
}

type CustomerStats struct {
	Total        int
	ByCommunity  int
	BySector     int
	WithReadings int
}

type PageInfo struct {
	Start int
	End   int
	Total int
}

type Filter struct {
	CommunityID string
	SectorID    string
	Period      string
}

func (h *AdminHandler) Dashboard(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	settings, _ := h.settingsRepo.Get(ctx)
	if settings == nil {
		settings = &domain.Settings{
			ID:              "main",
			Municipalidad:   "MUNICIPALIDAD DISTRITAL DE CHETILLA",
			Empresa:         "HIDROELECTRICA QARWAQIRU",
			DiasVencimiento: 15,
		}
	}

	customers, _ := h.customerRepo.ListAll(ctx)
	periods, _ := h.readingRepo.ListPeriods(ctx)
	currentPeriod := r.URL.Query().Get("period")
	if currentPeriod == "" {
		if len(periods) > 0 {
			currentPeriod = periods[0]
		} else {
			currentPeriod = time.Now().Format("2006-01")
		}
	}

	data := PageData{
		Settings:   *settings,
		Stats:      StatsData{Customers: len(customers), Readings: 0, Pending: 0},
		ActivePage: "dashboard",
		Periods:    periods,
		Period:     currentPeriod,
		Filter:     Filter{Period: currentPeriod},
	}

	h.templates.ExecuteTemplate(w, "index.html", data)
}

func (h *AdminHandler) SetPeriod(w http.ResponseWriter, r *http.Request) {
	period := r.URL.Query().Get("period")
	referer := r.Header.Get("Referer")
	
	// Add or update period in referer URL
	if strings.Contains(referer, "?") {
		if strings.Contains(referer, "period=") {
			// Replace existing period
			parts := strings.Split(referer, "period=")
			suffix := ""
			if strings.Contains(parts[1], "&") {
				suffix = parts[1][strings.Index(parts[1], "&"):]
			}
			referer = parts[0] + "period=" + period + suffix
		} else {
			referer += "&period=" + period
		}
	} else {
		referer += "?period=" + period
	}

	w.Header().Set("HX-Redirect", referer)
	w.WriteHeader(http.StatusOK)
}

func (h *AdminHandler) Customers(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	// Get communities and sectors from metadata
	communities, _ := h.metadataRepo.ListCommunities(ctx)
	sectors, _ := h.metadataRepo.ListSectors(ctx)

	// Get customers from DB
	customers, err := h.customerRepo.ListAll(ctx)
	if err != nil {
		log.Printf("Error fetching customers: %v", err)
		customers = []domain.Customer{}
	}

	// Build sector name map
	sectorMap := make(map[string]string)
	for _, s := range sectors {
		sectorMap[s.ID] = s.Name
	}

	// Filter logic
	search := r.URL.Query().Get("search")
	sectorID := r.URL.Query().Get("sector")

	var filtered []domain.Customer
	for _, c := range customers {
		if sectorID != "" && c.SectorID != sectorID {
			continue
		}
		if search != "" {
			match := strings.Contains(strings.ToLower(c.Name), strings.ToLower(search)) ||
				strings.Contains(strings.ToLower(c.Code), strings.ToLower(search)) ||
				strings.Contains(strings.ToLower(c.MeterNumber), strings.ToLower(search))
			if !match {
				continue
			}
		}
		filtered = append(filtered, c)
	}
	customers = filtered

	// Sort by Code explicitly (case-insensitive and trimmed)
	sort.Slice(customers, func(i, j int) bool {
		codeI := strings.ToLower(strings.TrimSpace(customers[i].Code))
		codeJ := strings.ToLower(strings.TrimSpace(customers[j].Code))
		return codeI < codeJ
	})

	if len(customers) > 0 {
		log.Printf("Sorted first 3: %s, %s, %s", customers[0].Code, customers[1].Code, (func() string { if len(customers) > 2 { return customers[2].Code }; return "" })())
	}

	// Build community name map
	commMap := make(map[string]string)
	for _, c := range communities {
		commMap[c.ID] = c.Name
	}

	// Convert to view rows
	rows := make([]CustomerRow, len(customers))
	withReadings := 0
	for i, c := range customers {
		latestReading, _ := h.readingRepo.GetLatestByCustomer(ctx, c.ID)

		row := CustomerRow{
			Code:        c.Code,
			Name:        c.Name,
			Community:   commMap[c.CommunityID],
			Sector:      sectorMap[c.SectorID],
			MeterNumber: c.MeterNumber,
		}

		status := "Sin lectura"
		statusClass := "bg-gray-800 text-gray-400"

		if latestReading != nil {
			lastReading := latestReading.Timestamp.Format("02/01/2006")
			status = "Con lectura"
			statusClass = "bg-green-900 text-green-400"
			withReadings++

			row.LastReading = lastReading
			row.Consumption = fmt.Sprintf("%.0f", latestReading.Consumption)
			row.CargoFijo = fmt.Sprintf("%.2f", latestReading.CargoFijo)
			row.Alumbrado = fmt.Sprintf("%.2f", latestReading.AlumbradoPublico)
			row.Total = fmt.Sprintf("%.2f", latestReading.TotalToPay)
		} else {
			row.LastReading = "-"
			row.Consumption = "-"
			row.CargoFijo = "-"
			row.Alumbrado = "-"
			row.Total = "-"
		}

		row.Status = status
		row.StatusClass = statusClass
		rows[i] = row
	}

	periods, _ := h.readingRepo.ListPeriods(ctx)
	currentPeriod := r.URL.Query().Get("period")
	if currentPeriod == "" {
		if len(periods) > 0 {
			currentPeriod = periods[0]
		} else {
			currentPeriod = time.Now().Format("2006-01")
		}
	}

	listData := ListData{
		Customers:   rows,
		Communities: communities,
		Sectors:     sectors,
		Stats:       CustomerStats{Total: len(customers), ByCommunity: len(communities), BySector: len(sectors), WithReadings: withReadings},
		Page:        PageInfo{Start: 1, End: len(customers), Total: len(customers)},
		Filter:      Filter{Period: currentPeriod},
		ActivePage:  "customers",
		Periods:     periods,
	}

	if r.Header.Get("HX-Request") == "true" {
		h.templates.ExecuteTemplate(w, "customer_rows.html", listData)
		return
	}

	h.templates.ExecuteTemplate(w, "customers.html", listData)
}

func (h *AdminHandler) Settings(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	settings, _ := h.settingsRepo.Get(ctx)
	if settings == nil {
		settings = &domain.Settings{
			ID:              "main",
			Municipalidad:   "MUNICIPALIDAD DISTRITAL DE CHETILLA",
			Empresa:         "HIDROELECTRICA QARWAQIRU",
			DiasVencimiento: 15,
		}
	}

	periods, _ := h.readingRepo.ListPeriods(ctx)
	currentPeriod := r.URL.Query().Get("period")
	if currentPeriod == "" {
		if len(periods) > 0 {
			currentPeriod = periods[0]
		} else {
			currentPeriod = time.Now().Format("2006-01")
		}
	}

	data := PageData{
		Settings:   *settings,
		ActivePage: "settings",
		Periods:    periods,
		Period:     currentPeriod,
		Filter:     Filter{Period: currentPeriod},
	}
	h.templates.ExecuteTemplate(w, "settings.html", data)
}

func (h *AdminHandler) SaveSettings(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	ctx := r.Context()
	err := r.ParseForm()
	if err != nil {
		w.Write([]byte(`<span class="text-red-500 font-semibold">❌ Error al procesar formulario</span>`))
		return
	}

	dias, _ := strconv.Atoi(r.FormValue("dias_vencimiento"))
	tarifa, _ := strconv.ParseFloat(r.FormValue("tarifa_kwh"), 64)
	cargo, _ := strconv.ParseFloat(r.FormValue("cargo_fijo"), 64)
	alumbrado, _ := strconv.ParseFloat(r.FormValue("alumbrado"), 64)
	mantenimiento, _ := strconv.ParseFloat(r.FormValue("mantenimiento"), 64)
	igv := r.FormValue("igv") == "on"

	settings := &domain.Settings{
		ID:              "main",
		Municipalidad:   r.FormValue("municipalidad"),
		Empresa:         r.FormValue("empresa"),
		RUC:             r.FormValue("ruc"),
		Direccion:       r.FormValue("direccion"),
		Telefono:        r.FormValue("telefono"),
		Email:           r.FormValue("email"),
		DiasVencimiento: dias,
		TarifaKWh:       tarifa,
		CargoFijo:       cargo,
		Alumbrado:       alumbrado,
		Mantenimiento:   mantenimiento,
		IGV:             igv,
	}

	err = h.settingsRepo.Upsert(ctx, settings)
	if err != nil {
		log.Printf("Error saving settings: %v", err)
		w.Write([]byte(`<span class="text-red-500 font-semibold">❌ Error al guardar en DB</span>`))
		return
	}

	w.Write([]byte(`<span class="text-green-500 font-semibold animate-pulse">✅ Cambios guardados correctamente</span>`))
}

func (h *AdminHandler) StatsCustomers(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	customers, err := h.customerRepo.ListAll(ctx)
	if err != nil {
		w.Write([]byte("0"))
		return
	}
	w.Write([]byte(fmt.Sprintf("%d", len(customers))))
}

func (h *AdminHandler) StatsReadings(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	count, err := h.readingRepo.CountCurrentMonth(ctx)
	if err != nil {
		w.Write([]byte("0"))
		return
	}
	w.Write([]byte(fmt.Sprintf("%d", count)))
}

func (h *AdminHandler) StatsPending(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	count, err := h.readingRepo.CountPendingCurrentMonth(ctx)
	if err != nil {
		w.Write([]byte("0"))
		return
	}
	w.Write([]byte(fmt.Sprintf("%d", count)))
}

func (h *AdminHandler) DownloadReceipt(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	customerCode := r.URL.Path[21:] // After /admin/customers/pdf/

	customer, err := h.customerRepo.GetByCode(ctx, customerCode)
	if err != nil {
		log.Printf("Error getting customer %s: %v", customerCode, err)
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}

	reading, err := h.readingRepo.GetLatestByCustomer(ctx, customer.ID)
	if err != nil {
		log.Printf("Error getting reading for customer %s: %v", customerCode, err)
		http.Error(w, "Reading not found", http.StatusNotFound)
		return
	}

	settings, _ := h.metadataRepo.GetSettings(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	communities, _ := h.metadataRepo.ListCommunities(ctx)
	sectors, _ := h.metadataRepo.ListSectors(ctx)

	h.populateReadingDetails(reading, settings)

	commName := ""
	for _, c := range communities {
		if c.ID == customer.CommunityID {
			commName = c.Name
			break
		}
	}

	sectName := ""
	for _, s := range sectors {
		if s.ID == customer.SectorID {
			sectName = s.Name
			break
		}
	}

	pdfData, err := h.pdfGen.Generate(ctx, reading, customer, settings, commName, sectName)
	if err != nil {
		log.Printf("Error generating PDF for customer %s: %v", customerCode, err)
		http.Error(w, "Error generating PDF", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", fmt.Sprintf("inline; filename=recibo_%s.pdf", customerCode))
	w.Write(pdfData)
}

func (h *AdminHandler) populateReadingDetails(reading *domain.Reading, settings *domain.Settings) {
	// Populate period and expiration dates if zero
	if reading.PeriodStart.IsZero() {
		reading.PeriodStart = reading.Timestamp.AddDate(0, -1, 0)
	}
	if reading.PeriodEnd.IsZero() {
		reading.PeriodEnd = reading.Timestamp
	}
	if reading.ExpirationDate.IsZero() {
		days := settings.DiasVencimiento
		if days == 0 {
			days = 15 // Default
		}
		reading.ExpirationDate = reading.Timestamp.AddDate(0, 0, days)
	}

	// Calculate subtotal on the fly if zero
	if reading.Subtotal == 0 {
		reading.Subtotal = (reading.Consumption * settings.TarifaKWh) + 
			reading.CargoFijo + 
			reading.AlumbradoPublico + 
			settings.Mantenimiento
	}
}

type CustomerDetailData struct {
	Customer  domain.Customer
	Community string
	Sector    string
	Readings  []domain.Reading
}

type CustomerEditData struct {
	Customer    domain.Customer
	Communities []domain.Community
	Sectors     []domain.Sector
}

type CustomerReceiptData struct {
	Customer  domain.Customer
	Reading   domain.Reading
	Settings  domain.Settings
	Community string
	Sector    string
}

func (h *AdminHandler) CustomerReceipt(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	customerCode := r.URL.Path[25:] // After /admin/customers/receipt/

	customer, err := h.customerRepo.GetByCode(ctx, customerCode)
	if err != nil {
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}

	latestReading, err := h.readingRepo.GetLatestByCustomer(ctx, customer.ID)
	if err != nil || latestReading == nil {
		// If no reading, show detail instead
		h.CustomerDetail(w, r)
		return
	}

	settings, _ := h.settingsRepo.Get(ctx)
	if settings == nil {
		settings = &domain.Settings{}
	}

	// Names for UI
	communities, _ := h.metadataRepo.ListCommunities(ctx)
	sectors, _ := h.metadataRepo.ListSectors(ctx)
	
	commName := ""
	for _, c := range communities {
		if c.ID == customer.CommunityID {
			commName = c.Name
			break
		}
	}
	
	sectName := ""
	for _, s := range sectors {
		if s.ID == customer.SectorID {
			sectName = s.Name
			break
		}
	}

	h.populateReadingDetails(latestReading, settings)

	data := CustomerReceiptData{
		Customer:  *customer,
		Reading:   *latestReading,
		Settings:  *settings,
		Community: commName,
		Sector:    sectName,
	}

	h.templates.ExecuteTemplate(w, "modal_receipt.html", data)
}

func (h *AdminHandler) CustomerDetail(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	customerCode := r.URL.Path[24:] // After /admin/customers/detail/

	customer, err := h.customerRepo.GetByCode(ctx, customerCode)
	if err != nil {
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}

	readings, _ := h.readingRepo.ListByCustomer(ctx, customer.ID)
	
	// Get community and sector names
	communities, _ := h.metadataRepo.ListCommunities(ctx)
	sectors, _ := h.metadataRepo.ListSectors(ctx)
	
	commName := ""
	for _, c := range communities {
		if c.ID == customer.CommunityID {
			commName = c.Name
			break
		}
	}
	
	sectName := ""
	for _, s := range sectors {
		if s.ID == customer.SectorID {
			sectName = s.Name
			break
		}
	}

	data := CustomerDetailData{
		Customer:  *customer,
		Community: commName,
		Sector:    sectName,
		Readings:  readings,
	}

	h.templates.ExecuteTemplate(w, "modal_detail.html", data)
}

func (h *AdminHandler) CustomerEdit(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	customerCode := r.URL.Path[22:] // After /admin/customers/edit/

	customer, err := h.customerRepo.GetByCode(ctx, customerCode)
	if err != nil {
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}

	communities, _ := h.metadataRepo.ListCommunities(ctx)
	sectors, _ := h.metadataRepo.ListSectors(ctx)

	data := CustomerEditData{
		Customer:    *customer,
		Communities: communities,
		Sectors:     sectors,
	}

	h.templates.ExecuteTemplate(w, "modal_edit.html", data)
}

func (h *AdminHandler) SaveCustomer(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	ctx := r.Context()
	err := r.ParseForm()
	if err != nil {
		http.Error(w, "Error parsing form", http.StatusBadRequest)
		return
	}

	id := r.FormValue("id")
	customer, err := h.customerRepo.GetByID(ctx, id)
	if err != nil {
		http.Error(w, "Customer not found", http.StatusNotFound)
		return
	}

	// Update fields
	customer.Name = r.FormValue("name")
	customer.SectorID = r.FormValue("sector_id")
	customer.MeterNumber = r.FormValue("meter_number")
	customer.ConnectionType = domain.ConnectionType(r.FormValue("connection_type"))
	
	lat, _ := strconv.ParseFloat(r.FormValue("latitude"), 64)
	lng, _ := strconv.ParseFloat(r.FormValue("longitude"), 64)
	initial, _ := strconv.ParseFloat(r.FormValue("initial_reading"), 64)

	customer.Latitude = lat
	customer.Longitude = lng
	customer.InitialReading = initial

	err = h.customerRepo.SaveBatch(ctx, []domain.Customer{*customer})
	if err != nil {
		log.Printf("Error saving customer: %v", err)
		http.Error(w, "Error saving customer", http.StatusInternalServerError)
		return
	}

	// Trigger a table refresh via HTMX if needed, or just close modal
	w.Header().Set("HX-Trigger", "refreshTable")
	w.WriteHeader(http.StatusOK)
}
