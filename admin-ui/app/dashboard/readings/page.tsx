"use client";

import {
  Calendar,
  Receipt,
  ChevronLeft,
  ChevronRight,
  Activity,
  Zap,
  Search,
  Filter,
  Download,
} from "lucide-react";
import { useEffect, useState } from "react";
import { Card } from "@/components/ui/card";
import { useAuth } from "@/lib/hooks/useAuth";
import { ExportModal } from "@/components/dashboard/readings/ExportModal";
import { getAdminToken, API_BASE_URL, downloadFile } from "@/lib/utils";
import { ReadingsStats } from "@/components/dashboard/readings/ReadingsStats";
import { useReadings } from "./hooks/useReadings";
import { useRouter } from "next/navigation";

export default function ReadingsPage() {
  const router = useRouter();
  const { isReader } = useAuth();
  const {
    data,
    filters,
    setFilters,
    pagination,
    setPagination,
    isBilling,
    colSpan,
    totalPages,
  } = useReadings();

  const [isExportModalOpen, setIsExportModalOpen] = useState(false);
  const [exportFilters, setExportFilters] = useState({
    period: "",
    sectorId: "",
  });

  useEffect(() => {
    if (filters.period && !exportFilters.period) {
      // Defer to next tick to avoid cascading render warning
      Promise.resolve().then(() => {
        setExportFilters((prev) => ({ ...prev, period: filters.period }));
      });
    }
  }, [filters.period, exportFilters.period]);

  return (
    <div className="p-8 space-y-6 animate-in fade-in duration-1000">
      {/* Header Section */}
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between border-b border-white/5 pb-6">
        <div className="space-y-1">
          <div className="flex items-center gap-2 mb-2">
            <span className="px-2 py-0.5 rounded-full bg-cyan-500/10 border border-cyan-500/20 text-[9px] font-black uppercase tracking-widest text-cyan-500">
              Historial de Consumo
            </span>
          </div>
          <h1 className="text-3xl font-black tracking-tighter leading-none">
            Control de <span className="text-primary italic">Lecturas</span>
          </h1>
          <p className="text-muted-foreground/40 font-bold uppercase text-[10px] tracking-[0.3em] mt-2">
            {data.totalCount} Registros • General
          </p>
        </div>
        <div className="flex gap-3">
          {!isReader && (
            <>
              <button
                onClick={() => router.push("/dashboard/readings/bulk")}
                className="flex items-center gap-2 px-6 py-3 rounded-2xl bg-white/5 border border-white/10 text-white hover:bg-white/10 transition-all text-[10px] font-black uppercase tracking-widest"
              >
                <Zap className="w-4 h-4 text-primary" />
                Carga Masiva
              </button>
              <button
                onClick={() => setIsExportModalOpen(true)}
                className="flex items-center gap-2 px-6 py-3 rounded-2xl bg-primary text-black hover:bg-primary/90 transition-all text-[10px] font-black uppercase tracking-widest shadow-lg shadow-primary/20"
              >
                <Download className="w-4 h-4" />
                Descargar Recibos
              </button>
            </>
          )}
          <div className="relative group">
            <select
              className="flex items-center gap-2 px-10 py-3 rounded-2xl bg-white/5 border border-white/10 hover:bg-white/10 transition-all text-[10px] font-black uppercase tracking-widest cursor-pointer outline-none focus:ring-2 focus:ring-primary/20 appearance-none bg-zinc-900 min-w-[160px]"
              value={filters.period}
              onChange={(e) => {
                setFilters((prev) => ({ ...prev, period: e.target.value }));
                setPagination((prev) => ({ ...prev, pageNumber: 1 }));
              }}
            >
              {data.periods.map((p) => (
                <option
                  key={p.id}
                  value={p.id}
                  className="bg-zinc-900 text-white"
                >
                  {p.id}
                </option>
              ))}
            </select>
            <Calendar className="w-4 h-4 text-primary absolute left-4 top-1/2 -translate-y-1/2 pointer-events-none" />
          </div>
        </div>
      </div>

      {/* Filters Bar */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="md:col-span-2 relative group">
          <Search className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground/30 group-focus-within:text-primary transition-colors" />
          <input
            type="text"
            placeholder="Buscar por ID de cliente..."
            className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-14 pr-5 text-xs font-bold focus:outline-none focus:border-primary/50 transition-all placeholder:text-muted-foreground/20"
            value={filters.customerId}
            onChange={(e) => {
              setFilters((prev) => ({ ...prev, customerId: e.target.value }));
              setPagination((prev) => ({ ...prev, pageNumber: 1 }));
            }}
          />
        </div>
        <div className="relative group">
          <Filter className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground/30 group-focus-within:text-primary transition-colors" />
          <select
            className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-14 pr-5 text-xs font-bold focus:outline-none focus:border-primary/50 transition-all appearance-none cursor-pointer"
            value={filters.sectorId}
            onChange={(e) => {
              setFilters((prev) => ({ ...prev, sectorId: e.target.value }));
              setPagination((prev) => ({ ...prev, pageNumber: 1 }));
            }}
          >
            <option value="" className="bg-zinc-900 text-white">
              Todos los Sectores
            </option>
            {data.sectors.map((s) => (
              <option
                key={s.id}
                value={s.id}
                className="bg-zinc-900 text-white"
              >
                {s.name}
              </option>
            ))}
          </select>
        </div>
        <div className="relative group">
          <Calendar className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground/30 group-focus-within:text-primary transition-colors" />
          <select
            className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-14 pr-5 text-xs font-bold focus:outline-none focus:border-primary/50 transition-all appearance-none cursor-pointer"
            value={filters.period}
            onChange={(e) => {
              setFilters((prev) => ({ ...prev, period: e.target.value }));
              setPagination((prev) => ({ ...prev, pageNumber: 1 }));
            }}
          >
            {data.periods.map((p) => (
              <option
                key={p.id}
                value={p.id}
                className="bg-zinc-900 text-white"
              >
                {p.id}
              </option>
            ))}
          </select>
        </div>
      </div>

      <ReadingsStats
        totalConsumptionKwh={data.stats.totalConsumptionKwh}
        totalRevenue={data.stats.totalRevenue}
        syncPercentage={data.stats.syncPercentage}
      />

      {/* Main Table Card */}
      <Card className="border-white/5 bg-card/10 backdrop-blur-3xl overflow-hidden rounded-[2.5rem] shadow-2xl">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-white/5 bg-white/2">
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Timestamp
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  ID Cliente
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Lectura (Ant / Act)
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Consumo
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Observación
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Monto
                </th>
                <th className="px-8 py-3 text-right text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Recibo
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {data.loading ? (
                [1, 2, 3, 4, 5, 6].map((i) => (
                  <tr key={i} className="animate-pulse">
                    <td colSpan={colSpan} className="px-8 py-4">
                      <div className="h-5 bg-white/5 rounded-xl w-full" />
                    </td>
                  </tr>
                ))
              ) : data.readings.length === 0 ? (
                <tr>
                  <td colSpan={colSpan} className="px-8 py-12 text-center">
                    <div className="flex flex-col items-center gap-4 opacity-20">
                      <Activity className="w-12 h-12" />
                      <p className="text-[10px] font-black uppercase tracking-[0.3em]">
                        No hay lecturas en este periodo
                      </p>
                    </div>
                  </td>
                </tr>
              ) : (
                data.readings.map((reading) => (
                  <tr
                    key={reading.id}
                    className="hover:bg-white/3 transition-all duration-300 group"
                  >
                    <td className="px-8 py-3">
                      <div className="flex flex-col">
                        <span className="text-[10px] font-black text-white group-hover:text-primary transition-colors">
                          {new Date(reading.timestamp).toLocaleDateString()}
                        </span>
                        <span className="text-[9px] font-bold text-muted-foreground/40 uppercase">
                          {new Date(reading.timestamp).toLocaleTimeString()}
                        </span>
                      </div>
                    </td>
                    <td className="px-8 py-3">
                      <span className="text-[10px] font-black font-mono text-muted-foreground/60">
                        {reading.customerId.slice(0, 8)}...
                      </span>
                    </td>
                    <td className="px-8 py-3">
                      <div className="flex items-center gap-2 text-[10px] font-bold text-muted-foreground/40">
                        <span>{Math.round(reading.previousValue)}</span>
                        <ChevronRight className="w-3 h-3" />
                        <span className="text-white font-black">
                          {Math.round(reading.currentValue)}
                        </span>
                      </div>
                    </td>
                    <td className="px-8 py-3">
                      <div className="flex items-baseline gap-1.5">
                        <span className="text-sm font-black font-mono text-primary tracking-tighter">
                          {reading.consumption.toLocaleString()}
                        </span>
                        <span className="text-[9px] font-bold text-muted-foreground/30 uppercase">
                          kWh
                        </span>
                      </div>
                    </td>
                    <td className="px-8 py-3">
                      {reading.observation ? (
                        <div className="flex items-center gap-2">
                          <span className="px-2 py-0.5 rounded-full bg-amber-500/10 border border-amber-500/20 text-[9px] font-black uppercase tracking-widest text-amber-500">
                            {reading.observation}
                          </span>
                        </div>
                      ) : (
                        <span className="text-[10px] font-bold text-muted-foreground/20 italic">
                          Sin obs.
                        </span>
                      )}
                    </td>
                    <td className="px-8 py-3">
                      <span className="text-[11px] font-black text-white">
                        S/{" "}
                        {reading.totalToPay.toLocaleString(undefined, {
                          minimumFractionDigits: 2,
                        })}
                      </span>
                    </td>
                    <td className="px-8 py-3 text-right">
                      <button
                        onClick={() => {
                          const token = getAdminToken();
                          window.open(
                            `${API_BASE_URL}/admin/readings/pdf/${reading.id}?token=${encodeURIComponent(token || "")}`,
                            "_blank",
                          );
                        }}
                        className="inline-flex items-center justify-center w-8 h-8 rounded-xl bg-white/5 border border-white/5 hover:bg-primary hover:text-black hover:border-primary transition-all group/btn"
                      >
                        <Receipt className="w-3.5 h-3.5" />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Premium Pagination Bar */}
        <div className="px-8 py-6 bg-white/3 border-t border-white/5 flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-3">
            <span className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
              Página <span className="text-white">{pagination.pageNumber}</span>{" "}
              de <span className="text-white">{totalPages || 1}</span>
            </span>
          </div>

          <div className="flex items-center gap-3">
            <button
              disabled={pagination.pageNumber <= 1 || data.loading}
              onClick={() =>
                setPagination((prev) => ({
                  ...prev,
                  pageNumber: prev.pageNumber - 1,
                }))
              }
              className="px-4 py-2 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 disabled:opacity-20 disabled:hover:bg-white/5 transition-all text-[10px] font-black uppercase tracking-widest flex items-center gap-2"
            >
              <ChevronLeft className="w-4 h-4" />
              Anterior
            </button>

            <div className="flex items-center gap-1.5 mx-2">
              {Array.from({ length: Math.min(5, totalPages) }).map((_, i) => {
                const p = i + 1;
                return (
                  <button
                    key={p}
                    onClick={() =>
                      setPagination((prev) => ({ ...prev, pageNumber: p }))
                    }
                    className={`w-10 h-10 rounded-xl text-[10px] font-black transition-all border ${pagination.pageNumber === p ? "bg-primary text-black border-primary shadow-[0_0_15px_rgba(255,0,255,0.2)]" : "bg-white/5 border-white/10 hover:bg-white/10 text-white"}`}
                  >
                    {p}
                  </button>
                );
              })}
              {totalPages > 5 && (
                <span className="text-muted-foreground/30 px-2 font-black">
                  ...
                </span>
              )}
            </div>

            <button
              disabled={pagination.pageNumber >= totalPages || data.loading}
              onClick={() =>
                setPagination((prev) => ({
                  ...prev,
                  pageNumber: prev.pageNumber + 1,
                }))
              }
              className="px-4 py-2 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 disabled:opacity-20 disabled:hover:bg-white/5 transition-all text-[10px] font-black uppercase tracking-widest flex items-center gap-2"
            >
              Siguiente
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </Card>

      {/* Export Selection Modal */}
      <ExportModal
        isOpen={isExportModalOpen}
        onClose={() => setIsExportModalOpen(false)}
        periods={data.periods}
        sectors={data.sectors}
        filters={exportFilters}
        onFilterChange={setExportFilters}
        onExport={async () => {
          const token = getAdminToken();
          const url = `${API_BASE_URL}/admin/readings/bulk-pdf?period=${exportFilters.period}&sectorId=${exportFilters.sectorId}&token=${encodeURIComponent(token || "")}`;

          try {
            await downloadFile(url, `recibos_${exportFilters.period}.pdf`);
            setIsExportModalOpen(false);
          } catch (err) {
            console.error("Export error:", err);
            alert("Error al generar el PDF. Por favor re-ingresa al sistema.");
          }
        }}
      />
    </div>
  );
}
