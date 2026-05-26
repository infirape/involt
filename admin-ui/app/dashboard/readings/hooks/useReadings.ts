import { useState, useCallback, useEffect, useMemo, useTransition } from "react";
import { adminClient } from "@/lib/rpc";
import type { Reading, Sector } from "@/app/gen/involt/v1/models_pb";
import { useConfigStore } from "@/lib/store/useConfigStore";

export function useReadings() {
  const [isPending, startTransition] = useTransition();
  const { selectedPeriod, periods: globalPeriods } = useConfigStore();

  const [data, setData] = useState<{
    readings: Reading[];
    totalCount: number;
    loading: boolean;
    stats: {
      totalRevenue: number;
      totalConsumptionKwh: number;
      syncPercentage: number;
    };
    sectors: Sector[];
  }>({
    readings: [],
    totalCount: 0,
    loading: true,
    stats: {
      totalRevenue: 0,
      totalConsumptionKwh: 0,
      syncPercentage: 0,
    },
    sectors: [],
  });

  const [filters, setFilters] = useState({
    customerId: "",
    sectorId: "",
  });

  const [pagination, setPagination] = useState({
    pageNumber: 1,
    pageSize: 10,
  });

  const { isBilling, colSpan } = useMemo(() => {
    // We check the global periods list for billing status
    const isB = globalPeriods.find(p => p.id === selectedPeriod)?.status === "OPEN"; // Assuming OPEN means active billing
    return { isBilling: isB, colSpan: 7 };
  }, [globalPeriods, selectedPeriod]);

  const fetchReadings = useCallback(async (periodId: string, page: number, size: number, customerId: string, sectorId: string) => {
    if (!periodId) return;
    
    try {
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: true }));
      });

      const readingsResp = await adminClient.getReadings({
        customerId,
        sectorId,
        period: periodId,
        pageNumber: page,
        pageSize: size,
      });

      startTransition(() => {
        setData((prev) => ({
          ...prev,
          readings: readingsResp.readings,
          totalCount: readingsResp.totalCount,
          loading: false,
        }));
      });
    } catch (err) {
      console.error("Failed to fetch readings:", err);
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: false }));
      });
    }
  }, []);

  const fetchStats = useCallback(async (periodId: string) => {
    if (!periodId) return;
    try {
      const statsResp = await adminClient.getDashboardStats({
        period: periodId,
      });

      const totalReadings = statsResp.totalReadingsPeriod;
      const pendingReadings = statsResp.pendingReadingsPeriod;
      const syncPercentage =
        totalReadings + pendingReadings > 0
          ? (totalReadings / (totalReadings + pendingReadings)) * 100
          : 0;

      setData((prev) => ({
        ...prev,
        stats: {
          totalRevenue: statsResp.totalRevenue,
          totalConsumptionKwh: statsResp.totalConsumptionKwh,
          syncPercentage: syncPercentage,
        },
      }));
    } catch (err) {
      console.error("Failed to fetch dashboard stats:", err);
    }
  }, []);

  // Fetch sectors once
  useEffect(() => {
    const initSectors = async () => {
      try {
        const resp = await adminClient.getSectors({});
        startTransition(() => {
          setData(prev => ({ ...prev, sectors: resp.sectors }));
        });
      } catch (err) {
        console.error("Failed to fetch sectors:", err);
      }
    };
    initSectors();
  }, []);

  const { customerId, sectorId } = filters;
  const { pageNumber, pageSize } = pagination;

  const [debouncedCustomerId, setDebouncedCustomerId] = useState(customerId);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedCustomerId(customerId);
    }, 500);

    return () => {
      clearTimeout(handler);
    };
  }, [customerId]);

  // Re-fetch stats when selected period changes
  useEffect(() => {
    if (selectedPeriod) {
      fetchStats(selectedPeriod);
    }
  }, [selectedPeriod, fetchStats]);

  // Re-fetch when global period or filters change
  useEffect(() => {
    if (selectedPeriod) {
      fetchReadings(selectedPeriod, pageNumber, pageSize, debouncedCustomerId, sectorId);
    }
  }, [selectedPeriod, pageNumber, pageSize, debouncedCustomerId, sectorId, fetchReadings]);

  const totalPages = Math.ceil(data.totalCount / pageSize);

  return {
    data,
    filters,
    setFilters,
    pagination,
    setPagination,
    isBilling,
    colSpan,
    totalPages,
    isPending,
    refresh: () => {
      fetchReadings(selectedPeriod, pageNumber, pageSize, customerId, sectorId);
      fetchStats(selectedPeriod);
    },
  };
}

