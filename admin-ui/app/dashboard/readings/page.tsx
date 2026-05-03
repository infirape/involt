"use client";

import {
  Calendar,
  Receipt,
  ChevronLeft,
  ChevronRight,
  Activity,
  Zap,
  DollarSign,
  CheckCircle2,
  Search,
  Filter,
} from "lucide-react";
import { useEffect, useState, useCallback, useMemo } from "react";
import type { Reading } from "@/app/gen/involt/v1/models_pb";
import { Card } from "@/components/ui/card";
import { adminClient } from "@/lib/rpc";

export default function ReadingsPage() {
  const [data, setData] = useState<{
    readings: Reading[];
    totalCount: number;
    loading: boolean;
  }>({
    readings: [],
    totalCount: 0,
    loading: true,
  });

  const [pagination, setPagination] = useState({
    pageNumber: 1,
    pageSize: 15,
  });

  const [filters, setFilters] = useState({
    customerId: "",
    sectorId: "",
    period: "",
  });

  const fetchReadings = useCallback(async () => {
    try {
      setData((prev) => ({ ...prev, loading: true }));
      const resp = await adminClient.getReadings({
        customerId: filters.customerId,
        sectorId: filters.sectorId,
        period: filters.period,
        pageNumber: pagination.pageNumber,
        pageSize: pagination.pageSize,
      });

      setData({
        readings: resp.readings,
        totalCount: resp.totalCount,
        loading: false,
      });
    } catch (err) {
      console.error("Failed to fetch readings:", err);
      setData((prev) => ({ ...prev, loading: false }));
    }
  }, [filters, pagination]);

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchReadings();
    }, 0);
    return () => clearTimeout(timer);
  }, [fetchReadings]);

  const totalPages = useMemo(
    () => Math.ceil(data.totalCount / pagination.pageSize),
    [data.totalCount, pagination.pageSize],
  );

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
            {data.totalCount} Registros • Telemetría General
          </p>
        </div>
        <div className="flex gap-3">
          <button className="flex items-center gap-2 px-6 py-3 rounded-2xl bg-white/5 border border-white/10 hover:bg-white/10 transition-all text-[10px] font-black uppercase tracking-widest">
            <Calendar className="w-4 h-4 text-primary" />
            Mayo 2026
          </button>
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
            <option value="">Todos los Sectores</option>
            <option value="sector-1">Chetilla Centro</option>
            <option value="sector-2">Tambillo</option>
          </select>
        </div>
        <div className="relative group">
          <Calendar className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground/30 group-focus-within:text-primary transition-colors" />
          <input
            type="month"
            className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-14 pr-5 text-xs font-bold focus:outline-none focus:border-primary/50 transition-all appearance-none cursor-pointer scheme-dark"
            value={filters.period}
            onChange={(e) => {
              setFilters((prev) => ({ ...prev, period: e.target.value }));
              setPagination((prev) => ({ ...prev, pageNumber: 1 }));
            }}
          />
        </div>
      </div>

      {/* Stats Quick View */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="bg-primary/5 border-primary/10 rounded-2xl p-4 group hover:bg-primary/10 transition-all duration-500">
          <div className="flex items-center gap-2 mb-1 opacity-60">
            <Zap className="w-3.5 h-3.5 text-primary" />
            <p className="text-[9px] font-black uppercase tracking-widest text-primary">
              Consumo Promedio
            </p>
          </div>
          <p className="text-xl font-black tracking-tighter text-white">
            124.5 <span className="text-xs opacity-40">kWh</span>
          </p>
        </Card>
        <Card className="bg-cyan-500/5 border-cyan-500/10 rounded-2xl p-4 group hover:bg-cyan-500/10 transition-all duration-500">
          <div className="flex items-center gap-2 mb-1 opacity-60">
            <DollarSign className="w-3.5 h-3.5 text-cyan-500" />
            <p className="text-[9px] font-black uppercase tracking-widest text-cyan-500">
              Ticket Promedio
            </p>
          </div>
          <p className="text-xl font-black tracking-tighter text-white">
            S/ 84.20
          </p>
        </Card>
        <Card className="bg-emerald-500/5 border-emerald-500/10 rounded-2xl p-4 group hover:bg-emerald-500/10 transition-all duration-500">
          <div className="flex items-center gap-2 mb-1 opacity-60">
            <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500" />
            <p className="text-[9px] font-black uppercase tracking-widest text-emerald-500">
              Sincronización
            </p>
          </div>
          <p className="text-xl font-black tracking-tighter text-white">
            100% <span className="text-xs opacity-40">OK</span>
          </p>
        </Card>
      </div>

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
                    <td colSpan={6} className="px-8 py-4">
                      <div className="h-5 bg-white/5 rounded-xl w-full" />
                    </td>
                  </tr>
                ))
              ) : data.readings.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-8 py-12 text-center">
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
                          const baseUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080";
                          window.open(`${baseUrl}/admin/readings/pdf/${reading.id}`, '_blank');
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
    </div>
  );
}
