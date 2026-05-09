"use client";

import { useEffect } from "react";
import {
  Search,
  Save,
  ChevronLeft,
  Database,
  CheckCircle2,
  AlertCircle,
} from "lucide-react";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { useRouter } from "next/navigation";
import { useBulkReadings } from "../hooks/useBulkReadings";

export default function BulkReadingsPage() {
  const router = useRouter();
  const {
    loading,
    data,
    filters,
    setFilters,
    bulkReadings,
    syncedReadings,
    filteredCustomers,
    handleInputChange,
    handlePreviousInputChange,
    bulkPreviousReadings,
    handleSave,
    saveSingleReading,
    getPreviousPeriod,
  } = useBulkReadings();

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  }, [filters.page]);

  const isOldestPeriod =
    data.periods.length > 0 &&
    [...data.periods].sort((a, b) => a.id.localeCompare(b.id))[0].id ===
      filters.periodId;

  return (
    <div className="p-4 space-y-3 animate-in fade-in duration-1000">
      {/* Header Section Compact */}
      <div className="flex items-center justify-between border-b border-white/5 pb-2">
        <div className="flex items-center gap-4">
          <button
            onClick={() => router.back()}
            className="p-2 rounded-xl bg-white/5 hover:bg-white/10 transition-colors"
          >
            <ChevronLeft className="w-4 h-4" />
          </button>
          <div>
            <h1 className="text-xl font-black tracking-tighter flex items-center gap-2">
              Carga Masiva <span className="text-primary italic">Lecturas</span>
            </h1>
            <p className="text-muted-foreground/40 font-bold uppercase text-[8px] tracking-[0.2em]">
              {filters.periodId} • {filteredCustomers.length} Suministros
            </p>
          </div>
        </div>

        <div className="flex items-center gap-6">
          <div className="text-right">
            <p className="text-[8px] font-black uppercase tracking-widest text-muted-foreground/30">
              Progreso
            </p>
            <p className="text-sm font-black text-primary font-mono">
              {data.totalReadings} / {data.totalCount}
            </p>
          </div>

          <Button
            onClick={handleSave}
            className="h-10 px-6 font-black uppercase tracking-widest rounded-xl bg-primary text-black hover:scale-105 transition-all shadow-lg shadow-primary/20 disabled:opacity-20 text-[10px]"
          >
            <Save className="w-4 h-4 mr-2" />
            Guardar
          </Button>
        </div>
      </div>

      {/* Filters Bar Ultra Compact */}
      <div className="flex items-center gap-4 p-2 bg-white/5 backdrop-blur-md rounded-xl border border-white/5">
        <div className="flex-1 flex items-center gap-4">
          <div className="flex items-center gap-2">
            <Label className="text-[9px] font-black uppercase tracking-widest text-muted-foreground/40">
              Sector:
            </Label>
            <select
              className="bg-zinc-900 border border-white/10 rounded-lg px-2 py-1 text-[11px] font-bold focus:outline-none focus:border-primary/50"
              value={filters.sectorId}
              onChange={(e) =>
                setFilters((prev) => ({ ...prev, sectorId: e.target.value }))
              }
            >
              <option value="">Todos</option>
              {data.sectors.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.name}
                </option>
              ))}
            </select>
          </div>

          <div className="flex items-center gap-2 border-l border-white/10 pl-4">
            <Label className="text-[9px] font-black uppercase tracking-widest text-muted-foreground/40">
              Periodo:
            </Label>
            <select
              className="bg-zinc-900 border border-white/10 rounded-lg px-2 py-1 text-[11px] font-bold focus:outline-none focus:border-primary/50"
              value={filters.periodId}
              onChange={(e) =>
                setFilters((prev) => ({ ...prev, periodId: e.target.value }))
              }
            >
              {data.periods.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.id}
                </option>
              ))}
            </select>
          </div>

          <div className="flex-1 relative group pl-4 border-l border-white/10">
            <Search className="absolute left-6 top-1/2 -translate-y-1/2 w-3 h-3 text-muted-foreground/30" />
            <input
              placeholder="Buscar por nombre o código..."
              className="w-full bg-zinc-900 border border-white/10 rounded-lg py-1 pl-8 pr-3 text-[11px] font-bold focus:outline-none focus:border-primary/50"
              value={filters.searchQuery}
              onChange={(e) =>
                setFilters((prev) => ({ ...prev, searchQuery: e.target.value }))
              }
            />
          </div>

          <div className="flex items-center gap-2 pl-4 border-l border-white/10">
            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="checkbox"
                checked={filters.showMissing}
                onChange={(e) =>
                  setFilters((prev) => ({ ...prev, showMissing: e.target.checked }))
                }
                className="w-4 h-4 rounded bg-white/10 border-white/20 text-primary focus:ring-primary"
              />
              <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60">
                Solo Faltan
              </span>
            </label>
          </div>
        </div>
      </div>

      {/* Main Table Ultra Compact */}
      <Card className="border-white/5 bg-card/10 backdrop-blur-3xl overflow-hidden rounded-2xl shadow-xl">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-white/5 bg-white/2">
                <th className="px-4 py-2 text-left text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  #
                </th>
                <th className="px-4 py-2 text-left text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Cód
                </th>
                <th className="px-4 py-2 text-left text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Suministro
                </th>
                {!isOldestPeriod && (
                  <th className="px-4 py-2 text-center text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                    ANT
                  </th>
                )}
                <th className="px-4 py-2 text-center text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  ACT
                </th>
                <th className="px-4 py-2 text-center text-[9px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Consumo
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {loading ? (
                [1, 2, 3, 4, 5, 6, 7, 8].map((i) => (
                  <tr key={i} className="animate-pulse">
                    <td colSpan={6} className="px-8 py-6">
                      <div className="h-8 bg-white/5 rounded-2xl w-full" />
                    </td>
                  </tr>
                ))
              ) : filteredCustomers.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-8 py-20 text-center">
                    <div className="flex flex-col items-center gap-4 opacity-20">
                      <Database className="w-16 h-16" />
                      <p className="text-[10px] font-black uppercase tracking-[0.4em]">
                        No se encontraron suministros
                      </p>
                    </div>
                  </td>
                </tr>
              ) : (
                filteredCustomers.map((customer, index) => {
                  const isSynced = syncedReadings.has(customer.id);
                  const prevVal = (customer.lastReadingValue === 0 || isSynced) && 
                                   bulkPreviousReadings[customer.id] !== undefined && 
                                   bulkPreviousReadings[customer.id] !== "" 
                                   ? parseFloat(bulkPreviousReadings[customer.id]) 
                                   : customer.lastReadingValue;

                  return (
                    <tr
                      key={customer.id}
                      className="hover:bg-white/3 transition-all duration-300 group"
                    >
                      <td className="px-4 py-1.5">
                        <div className="text-[10px] font-black font-mono text-muted-foreground/40">
                          {(filters.page - 1) * 500 + index + 1}
                        </div>
                      </td>
                      <td className="px-4 py-1.5">
                        <div className="text-[10px] font-black font-mono text-primary">
                          {customer.code}
                        </div>
                      </td>
                      <td className="px-4 py-1.5">
                        <div className="flex flex-col">
                          <span className="text-[11px] font-black text-white group-hover:text-primary transition-colors tracking-tight">
                            {customer.name}
                          </span>
                        </div>
                      </td>
                      {!isOldestPeriod && (
                        <td className="px-4 py-1.5 text-center">
                          {customer.lastReadingValue === 0 ? (
                            <div className="relative w-20 mx-auto">
                              <input
                                type="text"
                                value={bulkPreviousReadings[customer.id] !== undefined ? bulkPreviousReadings[customer.id] : ""}
                                onChange={(e) => handlePreviousInputChange(customer.id, e.target.value)}
                                disabled={isSynced}
                                placeholder="0"
                                className={`w-full bg-black/40 border-2 rounded-xl px-2 py-1.5 text-xs font-black font-mono transition-all outline-none text-center 
                                  ${isSynced 
                                    ? "border-green-500/20 text-green-400/50 cursor-not-allowed" 
                                    : "border-white/10 text-muted-foreground focus:border-primary focus:bg-black/60"}`}
                              />
                            </div>
                          ) : (
                            <span className="text-xs font-black font-mono text-muted-foreground/30 tracking-tighter">
                              {prevVal.toLocaleString()}
                            </span>
                          )}
                        </td>
                      )}
                      <td className="px-4 py-1.5 flex justify-center">
                        <div className="relative w-32 group/input">
                          <input
                            id={`input-${customer.id}`}
                            type="text"
                            value={bulkReadings[customer.id] || ""}
                            onChange={(e) => handleInputChange(customer.id, e.target.value)}
                            onKeyDown={(e) => {
                              if (e.key === "Enter") {
                                // Save immediately on Enter
                                saveSingleReading(customer.id, bulkReadings[customer.id]);
                                
                                const nextInput = document.getElementById(
                                  `input-${filteredCustomers[filteredCustomers.indexOf(customer) + 1]?.id}`,
                                ) as HTMLInputElement;
                                if (nextInput) nextInput.focus();
                              }
                            }}
                            disabled={isSynced}
                            placeholder="0.00"
                            className={`w-full bg-black/40 border-2 rounded-2xl px-4 py-2 text-sm font-black font-mono transition-all outline-none text-center
                              ${isSynced 
                                ? "border-green-500/50 text-green-400 cursor-not-allowed" 
                                : "border-white/10 text-white focus:border-primary focus:bg-black/60 shadow-2xl focus:shadow-primary/20"}`}
                          />
                        </div>
                        <div className="ml-2 flex items-center">
                          {isSynced ? (
                            <CheckCircle2 className="w-4 h-4 text-green-500 animate-in zoom-in duration-300" />
                          ) : bulkReadings[customer.id] ? (
                            <div className="w-2 h-2 rounded-full bg-yellow-500 animate-pulse shadow-[0_0_10px_rgba(234,179,8,0.5)]" />
                          ) : null}
                        </div>
                      </td>
                      <td className="px-4 py-1.5 text-center">
                        {bulkReadings[customer.id] && (
                          <span
                            className={`text-xs font-black font-mono tracking-tighter ${
                              parseFloat(bulkReadings[customer.id]) - prevVal < 0 
                                ? "text-red-500" 
                                : "text-cyan-400 font-bold"
                            }`}
                          >
                            {(() => {
                              const isBilling = data.periods.find((p) => p.id === filters.periodId)?.isBillingPeriod !== false;
                              if (!isBilling && prevVal === 0) return "-";
                              return (parseFloat(bulkReadings[customer.id]) - prevVal).toFixed(2);
                            })()}
                          </span>
                        )}
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination Controls */}
        <div className="flex items-center justify-between px-6 py-4 bg-white/2 border-t border-white/5">
          <div className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
            Página {filters.page} de {Math.ceil(data.totalCount / 500) || 1} •
            Total: {data.totalCount}
          </div>
          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              size="sm"
              className="h-8 rounded-lg border-white/5 bg-white/2 hover:bg-white/5 text-[10px] font-black uppercase tracking-widest disabled:opacity-20"
              onClick={() =>
                setFilters((prev) => ({
                  ...prev,
                  page: Math.max(1, prev.page - 1),
                }))
              }
              disabled={filters.page === 1 || loading}
            >
              Anterior
            </Button>
            <Button
              variant="outline"
              size="sm"
              className="h-8 rounded-lg border-white/5 bg-white/2 hover:bg-white/5 text-[10px] font-black uppercase tracking-widest disabled:opacity-20"
              onClick={() =>
                setFilters((prev) => ({ ...prev, page: prev.page + 1 }))
              }
              disabled={
                filters.page >= Math.ceil(data.totalCount / 500) || loading
              }
            >
              Siguiente
            </Button>
          </div>
        </div>
      </Card>

      {/* Footer Info Compact */}
      <div className="flex items-center justify-center gap-8 py-2 opacity-20">
        <div className="flex items-center gap-2">
          <AlertCircle className="w-3 h-3" />
          <span className="text-[8px] font-black uppercase tracking-[0.1em]">
            Cálculos automáticos en servidor
          </span>
        </div>
      </div>
    </div>
  );
}
