import { useState, useCallback, useEffect, useTransition, useMemo } from "react";
import { adminClient } from "@/lib/rpc";
import type { GetDashboardStatsResponse } from "@/app/gen/involt/v1/admin_pb";
import { PeriodStatus } from "@/app/gen/involt/v1/models_pb";
import type { Period } from "@/app/gen/involt/v1/models_pb";
import { toast } from "sonner";

export function useDashboard() {
  const [isPending, startTransition] = useTransition();
  const [data, setData] = useState<{
    stats: GetDashboardStatsResponse | null;
    loading: boolean;
  }>({
    stats: null,
    loading: true,
  });

  const [periods, setPeriods] = useState<Period[]>([]);
  const [selectedPeriod, setSelectedPeriod] = useState<string | null>(null);

  const fetchStats = useCallback(async (periodId: string) => {
    if (!periodId) return;
    
    try {
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: true }));
      });

      const resp = await adminClient.getDashboardStats({
        period: periodId,
      });

      startTransition(() => {
        setData({
          stats: resp,
          loading: false,
        });
      });
    } catch (err) {
      console.error("Failed to fetch dashboard stats:", err);
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: false }));
      });
      toast.error("Error al cargar estadísticas");
    }
  }, []);

  // Initialization: fetch periods
  useEffect(() => {
    let isMounted = true;
    const init = async () => {
      try {
        const resp = await adminClient.listPeriods({});
        if (!isMounted) return;

        const dbPeriods = resp.periods;
        setPeriods(dbPeriods);

        const current = dbPeriods.find((p) => p.status === PeriodStatus.OPEN) || dbPeriods[0];
        const initialPeriodId = current?.id || new Date().toISOString().slice(0, 7);
        
        setSelectedPeriod(initialPeriodId);
      } catch (err) {
        console.error("Failed to list periods:", err);
      }
    };
    init();
    return () => { isMounted = false; };
  }, []);

  // Sync stats with selected period
  useEffect(() => {
    if (selectedPeriod) {
      fetchStats(selectedPeriod);
    }
  }, [selectedPeriod, fetchStats]);

  const consumptionDelta = useMemo(() => {
    if (!data.stats || data.stats.previousConsumptionKwh === 0) return 0;
    return (
      ((data.stats.totalConsumptionKwh - data.stats.previousConsumptionKwh) /
        data.stats.previousConsumptionKwh) *
      100
    );
  }, [data.stats]);

  return {
    data,
    periods,
    selectedPeriod,
    setSelectedPeriod,
    consumptionDelta,
    isPending,
    refresh: () => selectedPeriod && fetchStats(selectedPeriod),
  };
}
