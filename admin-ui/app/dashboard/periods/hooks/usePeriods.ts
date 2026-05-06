import { useState, useCallback, useEffect, useTransition } from "react";
import { adminClient } from "@/lib/rpc";
import type { Period } from "@/app/gen/involt/v1/models_pb";
import { PeriodStatus } from "@/app/gen/involt/v1/models_pb";
import type { GetPeriodStatsResponse } from "@/app/gen/involt/v1/admin_pb";
import { toast } from "sonner";

export function usePeriods() {
  const [isPending, startTransition] = useTransition();
  const [loading, setLoading] = useState(true);
  const [closing, setClosing] = useState(false);
  
  const [data, setData] = useState<{
    periods: Period[];
    currentPeriod: Period | null;
    stats: GetPeriodStatsResponse | null;
  }>({
    periods: [],
    currentPeriod: null,
    stats: null,
  });

  const fetchData = useCallback(async () => {
    try {
      const periodsResp = await adminClient.listPeriods({});
      const current = periodsResp.periods.find(p => p.status === PeriodStatus.OPEN) || null;
      
      let stats: GetPeriodStatsResponse | null = null;
      if (current) {
        stats = await adminClient.getPeriodStats({ periodId: current.id });
      }

      startTransition(() => {
        setData({
          periods: periodsResp.periods,
          currentPeriod: current,
          stats: stats,
        });
      });
    } catch (err) {
      console.error("Failed to fetch periods:", err);
      toast.error("Error al cargar los periodos");
    } finally {
      startTransition(() => {
        setLoading(false);
      });
    }
  }, []);

  const handleClosePeriod = useCallback(async (periodId: string) => {
    if (!confirm("¿Estás seguro de cerrar este periodo? Se aperturará el siguiente automáticamente.")) return;
    
    setClosing(true);
    try {
      await adminClient.closePeriod({ id: periodId, openNext: true });
      toast.success("Periodo cerrado correctamente");
      await fetchData();
    } catch (err) {
      console.error("Failed to close period:", err);
      toast.error("Error al cerrar el periodo");
    } finally {
      setClosing(false);
    }
  }, [fetchData]);

  const handleOpenManual = useCallback(async (periodId: string) => {
    if (!periodId) return;
    
    // Simple dates for manual open
    const start = `${periodId}-01`;
    const end = new Date(new Date(start).getFullYear(), new Date(start).getMonth() + 1, 0).toISOString().slice(0, 10);

    try {
      await adminClient.openPeriod({ id: periodId, startDate: start, endDate: end });
      toast.success(`Periodo ${periodId} aperturado`);
      await fetchData();
    } catch (err) {
      console.error("Failed to open period:", err);
      toast.error("Error al aperturar periodo");
    }
  }, [fetchData]);

  useEffect(() => {
    let isMounted = true;
    const init = async () => {
      await fetchData();
      if (!isMounted) return;
    };
    init();
    return () => { isMounted = false; };
  }, [fetchData]);

  return {
    loading,
    closing,
    data,
    isPending,
    handleClosePeriod,
    handleOpenManual,
    refresh: fetchData,
  };
}
