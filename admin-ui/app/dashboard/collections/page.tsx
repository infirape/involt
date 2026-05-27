"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { adminClient } from "@/lib/rpc";
import { API_BASE_URL, getAdminToken } from "@/lib/utils";
import { toast } from "sonner";
import {
  DollarSign,
  FileText,
  CheckCircle2,
  XCircle,
  Loader2,
  ChevronDown,
  ChevronRight,
} from "lucide-react";
import {
  GetCollectionsRequestSchema,
  TogglePaymentStatusRequestSchema,
} from "@/app/gen/involt/v1/admin_pb";
import {
  GetCommunitiesRequestSchema,
} from "@/app/gen/involt/v1/admin_pb";
import { create } from "@bufbuild/protobuf";

// ── Types ──────────────────────────────────────────────────────────────────

interface SectorTab {
  id: string;
  name: string;
  communityId: string;
  communityName: string;
}

interface Reading {
  id: string;
  customerId: string;
  customerName: string;
  period: string;
  totalToPay: number;
  isPaid: boolean;
}

interface CustomerRow {
  customerId: string;
  customerName: string;
  readings: Record<string, Reading | null>; // period -> reading
}

// ── Helpers ────────────────────────────────────────────────────────────────

function getLastNPeriods(n: number): string[] {
  const periods: string[] = [];
  const now = new Date();
  for (let i = 0; i < n; i++) {
    const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
    periods.push(`${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}`);
  }
  return periods;
}

function formatPeriod(period: string): string {
  const [year, month] = period.split("-");
  const months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
  return `${months[parseInt(month) - 1]} ${year}`;
}

// ── Main Component ─────────────────────────────────────────────────────────

export default function CollectionsPage() {
  const [sectors, setSectors] = useState<SectorTab[]>([]);
  const [selectedSectorId, setSelectedSectorId] = useState<string>("");
  const [periods] = useState<string[]>(getLastNPeriods(6));
  const [customerRows, setCustomerRows] = useState<CustomerRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [togglingId, setTogglingId] = useState<string | null>(null);
  const [expandedCommunities, setExpandedCommunities] = useState<Set<string>>(new Set());
  const hasFetched = useRef(false);

  // Load communities & sectors
  useEffect(() => {
    if (hasFetched.current) return;
    hasFetched.current = true;

    async function loadSectors() {
      try {
        const resp = await adminClient.getCommunities(
          create(GetCommunitiesRequestSchema, {})
        );
        const tabs: SectorTab[] = [];
        for (const comm of resp.communities) {
          for (const sector of comm.sectors) {
            tabs.push({
              id: sector.id,
              name: sector.name,
              communityId: comm.id,
              communityName: comm.name,
            });
          }
        }
        setSectors(tabs);
        if (tabs.length > 0) {
          setSelectedSectorId(tabs[0].id);
          // Expand first community
          setExpandedCommunities(new Set([tabs[0].communityId]));
        }
      } catch {
        toast.error("Error al cargar los caseríos");
      }
    }
    loadSectors();
  }, []);

  // Load readings when sector changes
  const loadCollections = useCallback(async (sectorId: string) => {
    if (!sectorId) return;
    setLoading(true);
    try {
      const resp = await adminClient.getCollections(
        create(GetCollectionsRequestSchema, { sectorId, periods })
      );

      // Build customer-keyed map
      const rowMap: Record<string, CustomerRow> = {};
      for (const r of resp.readings) {
        if (!rowMap[r.customerId]) {
          rowMap[r.customerId] = {
            customerId: r.customerId,
            customerName: r.customerName,
            readings: {},
          };
          // Initialize all periods as null
          for (const p of periods) {
            rowMap[r.customerId].readings[p] = null;
          }
        }
        rowMap[r.customerId].readings[r.period] = {
          id: r.id,
          customerId: r.customerId,
          customerName: r.customerName,
          period: r.period,
          totalToPay: r.totalToPay,
          isPaid: r.isPaid,
        };
      }

      setCustomerRows(Object.values(rowMap).sort((a, b) =>
        a.customerName.localeCompare(b.customerName)
      ));
    } catch {
      toast.error("Error al cargar datos de cobranza");
    } finally {
      setLoading(false);
    }
  }, [periods]);

  useEffect(() => {
    if (selectedSectorId) {
      loadCollections(selectedSectorId);
    }
  }, [selectedSectorId, loadCollections]);

  // Toggle payment status
  const handleToggle = useCallback(async (reading: Reading) => {
    setTogglingId(reading.id);
    const newStatus = !reading.isPaid;

    // Optimistic update
    setCustomerRows(prev =>
      prev.map(row => {
        if (row.customerId !== reading.customerId) return row;
        return {
          ...row,
          readings: {
            ...row.readings,
            [reading.period]: { ...reading, isPaid: newStatus },
          },
        };
      })
    );

    try {
      await adminClient.togglePaymentStatus(
        create(TogglePaymentStatusRequestSchema, {
          readingId: reading.id,
          isPaid: newStatus,
        })
      );
      toast.success(newStatus ? "Marcado como PAGADO ✓" : "Marcado como PENDIENTE");
    } catch {
      // Revert on error
      setCustomerRows(prev =>
        prev.map(row => {
          if (row.customerId !== reading.customerId) return row;
          return {
            ...row,
            readings: {
              ...row.readings,
              [reading.period]: { ...reading, isPaid: reading.isPaid },
            },
          };
        })
      );
      toast.error("Error al actualizar el estado de pago");
    } finally {
      setTogglingId(null);
    }
  }, []);

  // Open PDF
  const openPDF = (readingId: string) => {
    const token = getAdminToken();
    const url = `${API_BASE_URL}/admin/readings/pdf/${readingId}?token=${token}`;
    window.open(url, "_blank");
  };

  // Group sectors by community for sidebar
  const communitiesWithSectors = sectors.reduce<Record<string, { name: string; sectors: SectorTab[] }>>(
    (acc, s) => {
      if (!acc[s.communityId]) {
        acc[s.communityId] = { name: s.communityName, sectors: [] };
      }
      acc[s.communityId].sectors.push(s);
      return acc;
    },
    {}
  );

  const toggleCommunity = (commId: string) => {
    setExpandedCommunities(prev => {
      const next = new Set(prev);
      if (next.has(commId)) {
        next.delete(commId);
      } else {
        next.add(commId);
      }
      return next;
    });
  };

  const selectedSector = sectors.find(s => s.id === selectedSectorId);

  return (
    <div className="h-full flex flex-col gap-6 p-6">
      {/* ── Header ── */}
      <div className="flex items-center gap-3">
        <div className="p-2 rounded-xl bg-emerald-500/10 border border-emerald-500/20">
          <DollarSign className="w-6 h-6 text-emerald-400" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-white">Cobranzas</h1>
          <p className="text-sm text-zinc-400">Control manual de pagos por caserío</p>
        </div>
      </div>

      <div className="flex gap-4 flex-1 min-h-0">
        {/* ── Sector Sidebar ── */}
        <aside className="w-56 shrink-0 bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-hidden flex flex-col">
          <div className="p-3 border-b border-zinc-800">
            <p className="text-xs font-semibold text-zinc-500 uppercase tracking-wider">Seleccionar Caserío</p>
          </div>
          <nav className="flex-1 overflow-y-auto p-2 space-y-1">
            {Object.entries(communitiesWithSectors).map(([commId, comm]) => (
              <div key={commId}>
                <button
                  onClick={() => toggleCommunity(commId)}
                  className="w-full flex items-center gap-2 px-2 py-1.5 rounded-lg text-left text-xs font-semibold text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800/50 transition-colors"
                >
                  {expandedCommunities.has(commId)
                    ? <ChevronDown className="w-3 h-3 shrink-0" />
                    : <ChevronRight className="w-3 h-3 shrink-0" />}
                  <span className="truncate">{comm.name}</span>
                </button>
                {expandedCommunities.has(commId) && (
                  <div className="ml-3 mt-0.5 space-y-0.5">
                    {comm.sectors.map(sector => (
                      <button
                        key={sector.id}
                        onClick={() => setSelectedSectorId(sector.id)}
                        className={`w-full text-left px-3 py-1.5 rounded-lg text-xs transition-all duration-150 ${
                          selectedSectorId === sector.id
                            ? "bg-emerald-500/15 text-emerald-400 font-semibold border border-emerald-500/25"
                            : "text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800/50"
                        }`}
                      >
                        {sector.name}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </nav>
        </aside>

        {/* ── Payment Matrix ── */}
        <div className="flex-1 min-w-0 bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-hidden flex flex-col">
          {/* Table header */}
          <div className="p-4 border-b border-zinc-800 flex items-center justify-between">
            <div>
              <h2 className="text-sm font-semibold text-white">
                {selectedSector ? selectedSector.name : "Seleccioná un caserío"}
              </h2>
              <p className="text-xs text-zinc-500 mt-0.5">
                {customerRows.length} suministros · Últimos 6 meses
              </p>
            </div>
            {loading && (
              <Loader2 className="w-4 h-4 text-zinc-500 animate-spin" />
            )}
          </div>

          {/* Scrollable matrix */}
          <div className="flex-1 overflow-auto">
            {!selectedSectorId ? (
              <div className="flex flex-col items-center justify-center h-full gap-3 text-zinc-600">
                <DollarSign className="w-12 h-12 opacity-30" />
                <p className="text-sm">Seleccioná un caserío para ver los pagos</p>
              </div>
            ) : loading ? (
              <div className="flex items-center justify-center h-full">
                <Loader2 className="w-8 h-8 text-zinc-600 animate-spin" />
              </div>
            ) : customerRows.length === 0 ? (
              <div className="flex flex-col items-center justify-center h-full gap-3 text-zinc-600">
                <XCircle className="w-10 h-10 opacity-30" />
                <p className="text-sm">Sin lecturas en los últimos 6 meses</p>
              </div>
            ) : (
              <table className="w-full text-xs border-collapse">
                <thead className="sticky top-0 z-10">
                  <tr className="bg-zinc-900 border-b border-zinc-800">
                    <th className="text-left px-4 py-3 text-zinc-400 font-semibold w-52 min-w-[200px]">
                      Suministro
                    </th>
                    {periods.map(p => (
                      <th key={p} className="text-center px-3 py-3 text-zinc-400 font-semibold min-w-[90px]">
                        {formatPeriod(p)}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {customerRows.map((row, idx) => (
                    <tr
                      key={row.customerId}
                      className={`border-b border-zinc-800/50 transition-colors hover:bg-zinc-800/20 ${
                        idx % 2 === 0 ? "" : "bg-zinc-900/30"
                      }`}
                    >
                      {/* Customer name */}
                      <td className="px-4 py-2.5 text-zinc-300 font-medium truncate max-w-[200px]">
                        {row.customerName}
                      </td>

                      {/* Payment cells per period */}
                      {periods.map(period => {
                        const reading = row.readings[period];
                        const isToggling = reading && togglingId === reading.id;

                        return (
                          <td key={period} className="px-2 py-2 text-center">
                            {reading ? (
                              <div className="relative group inline-flex flex-col items-center gap-1">
                                {/* Toggle button */}
                                <button
                                  onClick={() => !isToggling && handleToggle(reading)}
                                  disabled={!!isToggling}
                                  title={reading.isPaid ? "Clic para marcar como pendiente" : "Clic para marcar como pagado"}
                                  className={`
                                    relative flex items-center gap-1 px-2.5 py-1 rounded-lg font-semibold text-[10px] 
                                    transition-all duration-200 cursor-pointer select-none
                                    ${isToggling ? "opacity-60 cursor-wait" : "hover:scale-105 active:scale-95"}
                                    ${reading.isPaid
                                      ? "bg-emerald-500/15 text-emerald-400 border border-emerald-500/25 hover:bg-emerald-500/25"
                                      : "bg-red-500/10 text-red-400 border border-red-500/20 hover:bg-red-500/20"
                                    }
                                  `}
                                >
                                  {isToggling ? (
                                    <Loader2 className="w-3 h-3 animate-spin" />
                                  ) : reading.isPaid ? (
                                    <CheckCircle2 className="w-3 h-3" />
                                  ) : (
                                    <XCircle className="w-3 h-3" />
                                  )}
                                  {reading.isPaid ? "PAGADO" : "PENDIENTE"}
                                </button>

                                {/* PDF button — visible on hover */}
                                <button
                                  onClick={() => openPDF(reading.id)}
                                  title="Ver recibo PDF"
                                  className="
                                    absolute -top-1 -right-1 w-5 h-5 
                                    flex items-center justify-center rounded-full
                                    bg-zinc-700 hover:bg-fuchsia-600 
                                    border border-zinc-600 hover:border-fuchsia-500
                                    text-zinc-400 hover:text-white
                                    opacity-0 group-hover:opacity-100
                                    transition-all duration-150 scale-75 group-hover:scale-100
                                    shadow-lg
                                  "
                                >
                                  <FileText className="w-2.5 h-2.5" />
                                </button>

                                {/* Amount tooltip */}
                                <span className="text-[9px] text-zinc-600">
                                  S/ {reading.totalToPay.toFixed(2)}
                                </span>
                              </div>
                            ) : (
                              <span className="text-zinc-700 text-[10px]">—</span>
                            )}
                          </td>
                        );
                      })}
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>

          {/* Legend */}
          {customerRows.length > 0 && !loading && (
            <div className="p-3 border-t border-zinc-800 flex items-center gap-4 text-[10px] text-zinc-500">
              <div className="flex items-center gap-1.5">
                <div className="w-3 h-3 rounded bg-emerald-500/20 border border-emerald-500/30" />
                <span>PAGADO</span>
              </div>
              <div className="flex items-center gap-1.5">
                <div className="w-3 h-3 rounded bg-red-500/10 border border-red-500/20" />
                <span>PENDIENTE</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="text-zinc-700 font-bold">—</span>
                <span>Sin lectura registrada</span>
              </div>
              <div className="flex items-center gap-1.5 ml-auto">
                <FileText className="w-3 h-3 text-fuchsia-500" />
                <span>Pasá el cursor por una celda para ver el PDF</span>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
