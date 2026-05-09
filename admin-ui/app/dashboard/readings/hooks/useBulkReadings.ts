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
  ReadingSchema,
} from "@/app/gen/involt/v1/models_pb";
import { create } from "@bufbuild/protobuf";
import { toast } from "sonner";
import { useConfigStore } from "@/lib/store/useConfigStore";

export function useBulkReadings() {
  const [isPending, startTransition] = useTransition();
  const [saving, setSaving] = useState(false);
  const { selectedPeriod, periods: globalPeriods } = useConfigStore();

  const [data, setData] = useState<{
    customers: Customer[];
    sectors: Sector[];
    totalCount: number;
    totalReadings: number;
  }>({
    customers: [],
    sectors: [],
    totalCount: 0,
    totalReadings: 0,
  });

  const [filters, setFilters] = useState({
    sectorId: "",
    searchQuery: "",
    page: 1,
    showMissing: false,
  });

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
      
      try {
        const customerPageSize = showMissingAll ? 5000 : 500;
        
        const [readingsResp, customersResp] = await Promise.all([
          adminClient.getReadings({
            period: periodId,
            pageSize: 5000,
            pageNumber: 1,
          }),
          adminClient.getCustomers({
            pageSize: customerPageSize,
            pageNumber: page,
            searchQuery: showMissingAll ? "" : searchQuery,
            sectorId: sectorId,
            excludePeriodId: periodId,
          }),
        ]);

        const syncedSet = new Set<string>();

        startTransition(() => {
          const isNewPeriod = lastPeriodRef.current !== periodId;
          lastPeriodRef.current = periodId;

          if (isNewPeriod) {
            setBulkPreviousReadings({});
            setBulkReadings({});
            setBulkObservations({});
          }

          setBulkReadings((prev) => {
            const newMap = isNewPeriod ? {} : { ...prev };
            const newPrevMap = isNewPeriod ? {} : { ...bulkPreviousReadings };
            const newObsMap = isNewPeriod ? {} : { ...bulkObservations };

            readingsResp.readings.forEach((r) => {
              if (!newMap[r.customerId]) {
                newMap[r.customerId] = r.currentValue.toString();
              }
              if (!newPrevMap[r.customerId]) {
                newPrevMap[r.customerId] = r.previousValue.toString();
              }
              if (!newObsMap[r.customerId]) {
                newObsMap[r.customerId] = r.observation;
              }
              syncedSet.add(r.customerId);
            });

            setBulkPreviousReadings(newPrevMap);
            setBulkObservations(newObsMap);
            
            return newMap;
          });

          setSyncedReadings(syncedSet);
          setData((prev) => ({
            ...prev,
            customers: customersResp.customers,
            totalCount: customersResp.totalCount,
            totalReadings: readingsResp.totalCount,
          }));
        });
      } catch (error) {
        console.error("Error fetching readings and customers:", error);
        toast.error("Error al cargar datos del periodo");
      }
    },
    [bulkPreviousReadings, bulkObservations],
  );

  // Initial fetch of sectors
  useEffect(() => {
    const init = async () => {
      try {
        const resp = await adminClient.getSectors({});
        startTransition(() => {
          setData((prev) => ({ ...prev, sectors: resp.sectors }));
        });
      } catch (err) {
        console.error("Failed to init sectors:", err);
      } finally {
        setInitialized(true);
      }
    };
    init();
  }, []);

  useEffect(() => {
    if (selectedPeriod) {
      fetchReadingsAndCustomers(
        selectedPeriod,
        filters.page,
        filters.searchQuery,
        filters.sectorId,
        filters.showMissing,
      );
    }
  }, [
    selectedPeriod,
    filters.page,
    filters.searchQuery,
    filters.sectorId,
    filters.showMissing,
    fetchReadingsAndCustomers,
  ]);

  const filteredCustomers = useMemo(() => {
    return data.customers
      .filter((c) => {
        const matchesSector = !filters.sectorId || c.sectorId === filters.sectorId;
        const matchesSearch =
          !filters.searchQuery ||
          c.name.toLowerCase().includes(filters.searchQuery.toLowerCase()) ||
          c.code.toLowerCase().includes(filters.searchQuery.toLowerCase());
        
        const hasSyncedReading = syncedReadings.has(c.id);
        const matchesMissing = !filters.showMissing || !hasSyncedReading;
        
        return matchesSector && matchesSearch && matchesMissing;
      })
      .sort((a, b) => a.code.localeCompare(b.code));
  }, [data.customers, filters.sectorId, filters.searchQuery, filters.showMissing, syncedReadings]);

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

    if (value !== "") {
      const prevVal = bulkPreviousReadings[customerId];
      const customer = data.customers.find((c) => c.id === customerId);
      const ant = prevVal !== undefined && prevVal !== "" ? prevVal : (customer?.lastReadingValue.toString() || "0");
      handleInputChange(customerId, ant);
    }
  };

  const saveSingleReading = async (customerId: string, value: string) => {
    const period = globalPeriods.find((p) => p.id === selectedPeriod);
    const isPeriodOpen = period?.status === "OPEN";

    if (!value || !selectedPeriod || (syncedReadings.has(customerId) && !isPeriodOpen)) return;

    const customer = data.customers.find((c) => c.id === customerId);
    const currentValue = parseFloat(value);
    const previousValue = bulkPreviousReadings[customerId] !== undefined && bulkPreviousReadings[customerId] !== "" 
      ? parseFloat(bulkPreviousReadings[customerId]) 
      : (customer?.lastReadingValue || 0);

    if (currentValue < previousValue) return;

    try {
      const reading = create(ReadingSchema, {
        id: `read-${customerId}-${selectedPeriod}`,
        customerId,
        previousValue,
        currentValue,
        consumption: currentValue - previousValue,
        observation: bulkObservations[customerId] || "",
        period: selectedPeriod,
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
    const period = globalPeriods.find((p) => p.id === selectedPeriod);
    const isPeriodOpen = period?.status === "OPEN";

    const entries = Object.entries(bulkReadings).filter(
      ([customerId, val]) => (val !== "" || bulkObservations[customerId]) && (!syncedReadings.has(customerId) || isPeriodOpen),
    );

    if (entries.length === 0) {
      toast.warning("No hay lecturas ingresadas para guardar");
      return;
    }

    if (!selectedPeriod) return;

    setSaving(true);
    try {
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
          id: `read-${customerId}-${selectedPeriod}`,
          customerId,
          previousValue: prevVal,
          currentValue: currentVal,
          consumption: currentVal - prevVal,
          observation: bulkObservations[customerId] || "",
          period: selectedPeriod,
          timestamp: new Date().toISOString(),
        });
      });

      const resp = await syncClient.pushReadings({ readings: readingsToPush });

      if (resp.success) {
        toast.success(`${resp.syncedCount} lecturas guardadas correctamente`);
        await fetchReadingsAndCustomers(
          selectedPeriod,
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
    pendingCount,
    isPending,
  };
}
