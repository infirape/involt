import { useState, useCallback, useEffect, useMemo, useTransition } from "react";
import { adminClient } from "@/lib/rpc";
import type { Reading, Sector, Period } from "@/app/gen/involt/v1/models_pb";
import { PeriodStatus } from "@/app/gen/involt/v1/models_pb";

export function useReadings() {
  const [isPending, startTransition] = useTransition();
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
    periods: Period[];
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
    periods: [],
  });

  const [filters, setFilters] = useState({
    customerId: "",
    sectorId: "",
    period: "",
  });

  const [pagination, setPagination] = useState({
    pageNumber: 1,
    pageSize: 10,
  });

  const { isBilling, colSpan } = useMemo(() => {
    const isB = data.periods.find(p => p.id === filters.period)?.isBillingPeriod !== false;
    return { isBilling: isB, colSpan: 7 };
  }, [data.periods, filters.period]);

  const fetchReadings = useCallback(async (periodId: string, page: number, size: number, customerId: string, sectorId: string) => {
    if (!periodId) return;
    
    try {
      // Use a transition to avoid cascading render warnings
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: true }));
      });

      const [readingsResp, statsResp] = await Promise.all([
        adminClient.getReadings({
          customerId,
          sectorId,
          period: periodId,
          pageNumber: page,
          pageSize: size,
        }),
        adminClient.getDashboardStats({
          period: periodId,
        }),
      ]);

      const totalReadings = statsResp.totalReadingsPeriod;
      const pendingReadings = statsResp.pendingReadingsPeriod;
      const syncPercentage =
        totalReadings + pendingReadings > 0
          ? (totalReadings / (totalReadings + pendingReadings)) * 100
          : 0;

      startTransition(() => {
        setData((prev) => ({
          ...prev,
          readings: readingsResp.readings,
          totalCount: readingsResp.totalCount,
          loading: false,
          stats: {
            totalRevenue: statsResp.totalRevenue,
            totalConsumptionKwh: statsResp.totalConsumptionKwh,
            syncPercentage: syncPercentage,
          },
        }));
      });
    } catch (err) {
      console.error("Failed to fetch readings:", err);
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: false }));
      });
    }
  }, []);

  // Initialization
  useEffect(() => {
    let isMounted = true;
    const initPage = async () => {
      try {
        const [sectorsResp, periodsResp] = await Promise.all([
          adminClient.getSectors({}),
          adminClient.listPeriods({}),
        ]);

        if (!isMounted) return;

        const dbPeriods = periodsResp.periods;
        const currentOpen = dbPeriods.find((p) => p.status === PeriodStatus.OPEN);
        const initialPeriod = currentOpen?.id || (dbPeriods.length > 0 ? dbPeriods[0].id : "");

        startTransition(() => {
          setData((prev) => ({
            ...prev,
            sectors: sectorsResp.sectors,
            periods: dbPeriods,
          }));

          if (initialPeriod) {
            setFilters((prev) => ({ ...prev, period: initialPeriod }));
          }
        });

        // The fetch will be triggered by the second useEffect when filters.period changes
      } catch (err) {
        console.error("Failed to init readings page:", err);
      }
    };

    initPage();
    return () => { isMounted = false; };
  }, []); // Only once on mount

  // Use primitive dependencies to avoid object-identity issues
  const { customerId, sectorId, period } = filters;
  const { pageNumber, pageSize } = pagination;

  useEffect(() => {
    if (data.periods.length > 0 && period) {
      fetchReadings(period, pageNumber, pageSize, customerId, sectorId);
    }
  }, [period, pageNumber, pageSize, customerId, sectorId, data.periods.length, fetchReadings]);

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
    refresh: () => fetchReadings(period, pageNumber, pageSize, customerId, sectorId),
  };
}
