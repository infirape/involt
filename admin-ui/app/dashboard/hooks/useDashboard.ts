import { useState, useCallback, useEffect, useTransition, useMemo } from "react";
import { adminClient } from "@/lib/rpc";
import type { GetDashboardStatsResponse } from "@/app/gen/involt/v1/admin_pb";
import { toast } from "sonner";
import { useConfigStore } from "@/lib/store/useConfigStore";

export function useDashboard() {
  const [isPending, startTransition] = useTransition();
  const { selectedPeriod } = useConfigStore();
  
  const [data, setData] = useState<{
    stats: GetDashboardStatsResponse | null;
    loading: boolean;
  }>({
    stats: null,
    loading: true,
  });

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

  // Sync stats with global selected period
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
    consumptionDelta,
    isPending,
    refresh: () => selectedPeriod && fetchStats(selectedPeriod),
  };
}

