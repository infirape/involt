import {
  useState,
  useCallback,
  useEffect,
  useMemo,
  useTransition,
  useRef,
} from "react";
import { adminClient, syncClient } from "@/lib/rpc";
import {
  type Customer,
  type Sector,
  type Period,
  PeriodStatus,
  ReadingSchema,
} from "@/app/gen/involt/v1/models_pb";
import { create } from "@bufbuild/protobuf";
import { toast } from "sonner";

export function useBulkReadings() {
  const [isPending, startTransition] = useTransition();
  const [saving, setSaving] = useState(false);

  const [data, setData] = useState<{
    customers: Customer[];
    sectors: Sector[];
    periods: Period[];
    totalCount: number;
    totalReadings: number;
  }>({
    customers: [],
    sectors: [],
    periods: [],
    totalCount: 0,
    totalReadings: 0,
  });

  const [filters, setFilters] = useState({
    sectorId: "",
    periodId: "",
    searchQuery: "",
    page: 1,
    showMissing: false, // Filter: show only customers without reading
  });

  // Track initialization status (separate from data loading)
  const [initialized, setInitialized] = useState(false);
  const lastPeriodRef = useRef<string>("");

  const [bulkReadings, setBulkReadings] = useState<Record<string, string>>({});
  const [bulkPreviousReadings, setBulkPreviousReadings] = useState<Record<string, string>>({});
  const [syncedReadings, setSyncedReadings] = useState<Set<string>>(new Set());
  const [bulkObservations, setBulkObservations] = useState<Record<string, string>>({});

  const fetchReadingsAndCustomers = useCallback(
    async (
      periodId: string,
      page: number = 1,
      searchQuery: string = "",
      sectorId: string = "",
      showMissingAll: boolean = false,
    ) => {
      if (!periodId) return;
      console.log(
        `🔍 Fetching Page ${page} (Size: 500, Search: "${searchQuery}", Sector: "${sectorId}", AllCustomers: ${showMissingAll})`,
      );

      try {
        // When filtering "missing", fetch ALL customers at once (no pagination)
        const customerPageSize = showMissingAll ? 5000 : 500;
        
        const [readingsResp, customersResp] = await Promise.all([
          adminClient.getReadings({
            period: periodId,
            pageSize: 5000,
            pageNumber: 1,
          }),
          adminClient.getCustomers({
            pageSize: customerPageSize,
            pageNumber: page, // Use the correct page number
            searchQuery: showMissingAll ? "" : searchQuery, // No search when fetching all
            sectorId: sectorId,
            excludePeriodId: periodId,
          }),
        ]);

        const syncedSet = new Set<string>();

        console.log(
          `✅ Received ${customersResp.customers.length} customers, ${readingsResp.readings.length} readings synced. Total customers: ${customersResp.totalCount}`,
        );

        startTransition(() => {
          const isNewPeriod = lastPeriodRef.current !== periodId;
          lastPeriodRef.current = periodId;

          if (isNewPeriod) {
            setBulkPreviousReadings({});
          }

          setBulkReadings((prev) => {
            const newMap = isNewPeriod ? {} : { ...prev };
            const newPrevMap = isNewPeriod ? {} : { ...bulkPreviousReadings };
            const newObsMap = isNewPeriod ? {} : { ...bulkObservations };

            readingsResp.readings.forEach((r) => {
              // Populate current values
              if (!newMap[r.customerId]) {
                newMap[r.customerId] = r.currentValue.toString();
              }
              // Populate previous values if they were manually corrected or differ from customer base
              if (!newPrevMap[r.customerId]) {
                newPrevMap[r.customerId] = r.previousValue.toString();
              }
              // Populate observations
              if (!newObsMap[r.customerId]) {
                newObsMap[r.customerId] = r.observation;
              }
              syncedSet.add(r.customerId);
            });

            // We need to update state
            setBulkPreviousReadings(newPrevMap);
            setBulkObservations(newObsMap);
            
            return newMap;
          });

          setSyncedReadings(syncedSet);
          console.log(`📊 Synced customer IDs: ${[...syncedSet].slice(0, 5).join(", ")}...`);
          setData((prev) => ({
            ...prev,
            customers: customersResp.customers,
            totalCount: customersResp.totalCount,
            totalReadings: readingsResp.totalCount,
          }));
        });
      } catch (error) {
        console.error("❌ Error fetching readings and customers:", error);
        toast.error("Error al cargar datos del periodo");
      }
    },
    [],
  );

  useEffect(() => {
    let isMounted = true;

    const init = async () => {
      try {
        const [sectorsResp, periodsResp] = await Promise.all([
          adminClient.getSectors({}),
          adminClient.listPeriods({}),
        ]);

        if (!isMounted) return;

        const periods = periodsResp.periods;
        const openPeriod = periods.find((p) => p.status === PeriodStatus.OPEN);
        const initialPeriodId =
          openPeriod?.id || (periods.length > 0 ? periods[0].id : "");

        startTransition(() => {
          setData((prev) => ({
            ...prev,
            sectors: sectorsResp.sectors,
            periods: periods,
          }));

          if (initialPeriodId) {
            setFilters((prev) => ({ ...prev, periodId: initialPeriodId }));
          }
        });
      } catch (err) {
        console.error("Failed to init bulk readings:", err);
        toast.error("Error al inicializar la página");
      } finally {
        if (isMounted) setInitialized(true);
      }
    };

    init();
    return () => {
      isMounted = false;
    };
  }, []); // Only on mount

  useEffect(() => {
    fetchReadingsAndCustomers(
      filters.periodId,
      filters.page,
      filters.searchQuery,
      filters.sectorId,
      filters.showMissing,
    );
  }, [
    filters.periodId,
    filters.page,
    filters.searchQuery,
    filters.sectorId,
    filters.showMissing,
    fetchReadingsAndCustomers,
  ]);

const filteredCustomers = useMemo(() => {
    const result = data.customers
      .filter((c) => {
        const matchesSector =
          !filters.sectorId || c.sectorId === filters.sectorId;
        const matchesSearch =
          !filters.searchQuery ||
          c.name.toLowerCase().includes(filters.searchQuery.toLowerCase()) ||
          c.code.toLowerCase().includes(filters.searchQuery.toLowerCase());
        
        // Debug: log para audit
        if (filters.showMissing && c.code === 'ACH001') {
          console.log(`🔍 ACH001: synced=${syncedReadings.has(c.id)}, bulk="${bulkReadings[c.id]}"`);
        }
        
        // "Solo Faltan" = solo los que NO tienen lectura SYNCED en el servidor
        // No importa si tienen draft en bulkReadings - esos también faltan guardar
        const hasSyncedReading = syncedReadings.has(c.id);
        const matchesMissing = !filters.showMissing || !hasSyncedReading;
        
        return matchesSector && matchesSearch && matchesMissing;
      })
      .sort((a, b) => a.code.localeCompare(b.code));
    
    console.log(`📋 Filtered: ${result.length} customers, showMissing=${filters.showMissing}`);
    return result;
  }, [data.customers, filters.sectorId, filters.searchQuery, filters.showMissing, syncedReadings, bulkReadings]);

  const focusNextRow = useCallback(
    (currentId: string) => {
      const currentIndex = filteredCustomers.findIndex(
        (c) => c.id === currentId,
      );
      if (currentIndex < filteredCustomers.length - 1) {
        const nextCustomer = filteredCustomers[currentIndex + 1];
        const nextInput = document.getElementById(`input-${nextCustomer.id}`);
        nextInput?.focus();
      }
    },
    [filteredCustomers],
  );

  const handleInputChange = (customerId: string, value: string) => {
    const normalizedValue = value.replace(",", ".");
    if (normalizedValue === "" || /^\d*\.?\d*$/.test(normalizedValue)) {
      setBulkReadings((prev) => ({
        ...prev,
        [customerId]: normalizedValue,
      }));
      setSyncedReadings((prev) => {
        const next = new Set(prev);
        next.delete(customerId);
        return next;
      });
    }
  };

  const handlePreviousInputChange = (customerId: string, value: string) => {
    const normalizedValue = value.replace(",", ".");
    if (normalizedValue === "" || /^\d*\.?\d*$/.test(normalizedValue)) {
      setBulkPreviousReadings((prev) => ({
        ...prev,
        [customerId]: normalizedValue,
      }));
    }
  };

  const handleObservationChange = (customerId: string, value: string) => {
    setBulkObservations((prev) => ({
      ...prev,
      [customerId]: value,
    }));

    // If an observation is set, automatically set current reading to previous reading
    if (value !== "") {
      const prevVal = bulkPreviousReadings[customerId];
      const customer = data.customers.find((c) => c.id === customerId);
      const ant = prevVal !== undefined && prevVal !== "" ? prevVal : (customer?.lastReadingValue.toString() || "0");
      
      handleInputChange(customerId, ant);
    }
  };

  const saveSingleReading = async (customerId: string, value: string) => {
    const period = data.periods.find((p) => p.id === filters.periodId);
    const isPeriodOpen = period?.status === 1;

    if (!value || !filters.periodId || (syncedReadings.has(customerId) && !isPeriodOpen)) return;

    const customer = data.customers.find((c) => c.id === customerId);
    const currentValue = parseFloat(value);
    const previousValue = bulkPreviousReadings[customerId] !== undefined && bulkPreviousReadings[customerId] !== "" 
      ? parseFloat(bulkPreviousReadings[customerId]) 
      : (customer?.lastReadingValue || 0);

    if (currentValue < previousValue) return;

    try {
      const reading = create(ReadingSchema, {
        id: `read-${customerId}-${filters.periodId}`,
        customerId,
        previousValue,
        currentValue,
        consumption: currentValue - previousValue,
        observation: bulkObservations[customerId] || "",
        period: filters.periodId,
        timestamp: new Date().toISOString(),
      });

      const resp = await syncClient.pushReadings({ readings: [reading] });
      if (resp.success) {
        setSyncedReadings((prev) => new Set(prev).add(customerId));
      }
    } catch (err) {
      console.error("Failed to save single reading:", err);
    }
  };

  const handleSave = async () => {
    const period = data.periods.find((p) => p.id === filters.periodId);
    const isPeriodOpen = period?.status === 1;

    const entries = Object.entries(bulkReadings).filter(
      ([customerId, val]) => (val !== "" || bulkObservations[customerId]) && (!syncedReadings.has(customerId) || isPeriodOpen),
    );

    if (entries.length === 0) {
      toast.warning("No hay lecturas ingresadas para guardar");
      return;
    }

    if (!filters.periodId) return;

    setSaving(true);
    try {
      // Validate that no reading is less than the previous one
      const hasInvalid = entries.some(([customerId, value]) => {
        const customer = data.customers.find((c) => c.id === customerId);
        const prevVal = bulkPreviousReadings[customerId] !== undefined && bulkPreviousReadings[customerId] !== "" 
          ? parseFloat(bulkPreviousReadings[customerId]) 
          : (customer?.lastReadingValue || 0);
        return parseFloat(value) < prevVal;
      });

      if (hasInvalid) {
        toast.error("Hay suministros con lectura actual menor a la anterior. Corrígelos antes de guardar.");
        setSaving(false);
        return;
      }

      const readingsToPush = entries.map(([customerId, value]) => {
        const customer = data.customers.find((c) => c.id === customerId);
        const prevVal = bulkPreviousReadings[customerId] !== undefined && bulkPreviousReadings[customerId] !== "" 
          ? parseFloat(bulkPreviousReadings[customerId]) 
          : (customer?.lastReadingValue || 0);
        
        const currentVal = value !== "" ? parseFloat(value) : prevVal;

        return create(ReadingSchema, {
          id: `read-${customerId}-${filters.periodId}`,
          customerId,
          previousValue: prevVal,
          currentValue: currentVal,
          consumption: currentVal - prevVal,
          observation: bulkObservations[customerId] || "",
          period: filters.periodId,
          timestamp: new Date().toISOString(),
        });
      });

      const resp = await syncClient.pushReadings({ readings: readingsToPush });

      if (resp.success) {
        toast.success(`${resp.syncedCount} lecturas guardadas correctamente`);
        await fetchReadingsAndCustomers(
          filters.periodId,
          filters.page,
          filters.searchQuery,
          filters.sectorId,
          filters.showMissing,
        );
      }
    } catch (err) {
      console.error("Failed to save readings:", err);
      toast.error("Error al guardar las lecturas");
    } finally {
      setSaving(false);
    }
  };

  const getPreviousPeriod = (id: string) => {
    if (!id) return "";
    const [year, month] = id.split("-").map(Number);
    const date = new Date(year, month - 2, 1);
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}`;
  };

  // Derived loading state - true while not initialized
  const loading = !initialized;

  const pendingCount = useMemo(() => {
    return Object.keys(bulkReadings).filter(
      (customerId) => bulkReadings[customerId] !== "" && !syncedReadings.has(customerId),
    ).length;
  }, [bulkReadings, syncedReadings]);

  return {
    loading,
    saving,
    data,
    filters,
    setFilters,
    bulkReadings,
    syncedReadings,
    filteredCustomers,
    handleInputChange,
    handlePreviousInputChange,
    bulkPreviousReadings,
    handleObservationChange,
    bulkObservations,
    handleSave,
    saveSingleReading,
    focusNextRow,
    getPreviousPeriod,
    filledCount: pendingCount,
    pendingCount,
    isPending,
  };
}
