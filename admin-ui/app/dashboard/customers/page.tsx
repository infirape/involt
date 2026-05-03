"use client";

import {
  Plus,
  Search,
  X,
  ChevronLeft,
  ChevronRight,
  Filter,
  ArrowUpRight,
  Users,
  Trash2,
} from "lucide-react";
import { useCallback, useEffect, useState, useMemo } from "react";
import {
  type Customer,
  ConnectionType,
  type Sector,
} from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { adminClient } from "@/lib/rpc";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import dynamic from "next/dynamic";
import { useAuth } from "@/lib/hooks/useAuth";

const LocationPicker = dynamic(() => import("@/components/dashboard/LocationPicker"), {
  ssr: false,
  loading: () => (
    <div className="h-64 w-full rounded-2xl bg-white/5 animate-pulse flex items-center justify-center border border-white/10">
      <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">Cargando Mapa de Georeferencia...</span>
    </div>
  ),
});

export default function CustomersPage() {
  const { isAdmin } = useAuth();
  const [data, setData] = useState<{
    customers: Customer[];
    sectors: Sector[];
    totalCount: number;
    loading: boolean;
  }>({
    customers: [],
    sectors: [],
    totalCount: 0,
    loading: true,
  });

  const [pagination, setPagination] = useState({
    pageNumber: 1,
    pageSize: 15,
  });

  const [filters, setFilters] = useState({
    sectorId: "",
    searchQuery: "",
  });

  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCustomer, setEditingCustomer] =
    useState<Partial<Customer> | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchAll = useCallback(async () => {
    try {
      setData((prev) => ({ ...prev, loading: true }));
      const [customersResp, sectorsResp] = await Promise.all([
        adminClient.getCustomers({
          sectorId: filters.sectorId,
          searchQuery: filters.searchQuery,
          pageNumber: pagination.pageNumber,
          pageSize: pagination.pageSize,
        }),
        adminClient.getSectors({}),
      ]);

      setData({
        customers: customersResp.customers,
        sectors: sectorsResp.sectors,
        totalCount: customersResp.totalCount,
        loading: false,
      });
    } catch (err) {
      console.error("Failed to fetch data:", err);
      setData((prev) => ({ ...prev, loading: false }));
    }
  }, [filters, pagination]);

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchAll();
    }, 0);
    return () => clearTimeout(timer);
  }, [fetchAll]);

  const totalPages = useMemo(
    () => Math.ceil(data.totalCount / pagination.pageSize),
    [data.totalCount, pagination.pageSize],
  );

  const handleOpenModal = (customer: Partial<Customer> | null = null) => {
    setEditingCustomer(
      customer || {
        id: crypto.randomUUID(),
        name: "",
        code: "",
        address: "",
        connectionType: ConnectionType.MONOFASICA,
        sectorId: data.sectors[0]?.id || "",
        latitude: 0,
        longitude: 0,
        initialReading: 0,
        tariff: 1.5, // Default tariff
      },
    );
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingCustomer) return;
    setSaving(true);
    try {
      // Resolve communityId from the selected sector
      const selectedSector = data.sectors.find(s => s.id === editingCustomer.sectorId);
      const customerToSave = {
        ...editingCustomer,
        communityId: selectedSector?.communityId || "COM-001"
      } as Customer;

      await adminClient.upsertCustomer({
        customer: customerToSave,
      });
      await fetchAll();
      setIsModalOpen(false);
    } catch (err) {
      console.error("Failed to save customer:", err);
    } finally {
      setSaving(false);
    }
  };

  const handleDeleteCustomer = async (id: string) => {
    if (!confirm("¿Estás seguro de que deseas dar de baja este suministro? Esta acción no se puede deshacer.")) {
      return;
    }

    try {
      await adminClient.deleteCustomer({ id });
      await fetchAll();
      setIsModalOpen(false);
    } catch (err) {
      console.error("Failed to delete customer:", err);
    }
  };

  return (
    <div className="p-8 space-y-6 animate-in fade-in duration-1000">
      {/* Header Section */}
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between border-b border-white/5 pb-6">
        <div className="space-y-1">
          <div className="flex items-center gap-2 mb-2">
            <span className="px-2 py-0.5 rounded-full bg-primary/10 border border-primary/20 text-[9px] font-black uppercase tracking-widest text-primary">
              Padron Maestro
            </span>
          </div>
          <h1 className="text-3xl font-black tracking-tighter leading-none">
            Gestión de <span className="text-primary italic">Clientes</span>
          </h1>
          <p className="text-muted-foreground/40 font-bold uppercase text-[10px] tracking-[0.3em] mt-2">
            {data.totalCount} Registros Totales • Chetilla
          </p>
        </div>
        {isAdmin && (
          <Button
            onClick={() => handleOpenModal()}
            className="h-14 px-8 font-black uppercase tracking-widest rounded-2xl bg-primary text-black hover:scale-105 transition-all shadow-[0_0_30px_rgba(255,0,255,0.2)]"
          >
            <Plus className="w-5 h-5 mr-2" />
            Nuevo Suministro
          </Button>
        )}
      </div>

      {/* Filters Bar */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="md:col-span-2 relative group">
          <Search className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground/30 group-focus-within:text-primary transition-colors" />
          <input
            type="text"
            placeholder="Buscar por nombre, código o medidor..."
            className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-14 pr-5 text-xs font-bold focus:outline-none focus:border-primary/50 transition-all placeholder:text-muted-foreground/20"
            value={filters.searchQuery}
            onChange={(e) => {
              setFilters((prev) => ({ ...prev, searchQuery: e.target.value }));
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
            {data.sectors.map((s) => (
              <option key={s.id} value={s.id}>
                {s.name}
              </option>
            ))}
          </select>
        </div>
        <div className="flex items-center justify-center bg-white/2 border border-white/5 rounded-2xl px-4">
          <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
            Mostrando {data.customers.length} de {data.totalCount}
          </span>
        </div>
      </div>

      {/* Table Section */}
      <Card className="border-white/5 bg-card/10 backdrop-blur-3xl overflow-hidden rounded-[2.5rem] shadow-2xl">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-white/5 bg-white/2">
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Código
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Cliente / Dirección
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Conexión
                </th>
                <th className="px-8 py-3 text-left text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Última Lectura
                </th>
                <th className="px-8 py-3 text-right text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/40">
                  Ficha
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {data.loading ? (
                [1, 2, 3, 4, 5, 6].map((i) => (
                  <tr key={i} className="animate-pulse">
                    <td colSpan={5} className="px-8 py-4">
                      <div className="h-5 bg-white/5 rounded-xl w-full" />
                    </td>
                  </tr>
                ))
              ) : data.customers.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-8 py-12 text-center">
                    <div className="flex flex-col items-center gap-4 opacity-20">
                      <Users className="w-12 h-12" />
                      <p className="text-[10px] font-black uppercase tracking-[0.3em]">
                        Sin resultados encontrados
                      </p>
                    </div>
                  </td>
                </tr>
              ) : (
                data.customers.map((customer) => (
                  <tr
                    key={customer.id}
                    className="hover:bg-white/3 transition-all duration-300 group"
                  >
                    <td className="px-8 py-3">
                      <div className="inline-flex px-3 py-1.5 rounded-xl bg-primary/5 border border-primary/10 text-[11px] font-black font-mono text-primary group-hover:scale-105 transition-transform">
                        {customer.code}
                      </div>
                    </td>
                    <td className="px-8 py-3">
                      <div className="flex flex-col">
                        <span className="text-sm font-black text-white group-hover:text-primary transition-colors tracking-tight">
                          {customer.name}
                        </span>
                        <span className="text-[10px] font-bold text-muted-foreground/30 uppercase mt-0.5">
                          {customer.address}
                        </span>
                      </div>
                    </td>
                    <td className="px-8 py-3">
                      <div className="flex items-center gap-3">
                        <div
                          className={`w-2 h-2 rounded-full shadow-[0_0_10px_currentColor] ${customer.connectionType === ConnectionType.MONOFASICA ? "text-cyan-500 bg-cyan-500" : "text-amber-500 bg-amber-500"}`}
                        />
                        <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60">
                          {customer.connectionType === ConnectionType.MONOFASICA
                            ? "Monofásica"
                            : "Trifásica"}
                        </span>
                      </div>
                    </td>
                    <td className="px-8 py-3">
                      <div className="flex items-baseline gap-1.5">
                        <span className="text-sm font-black font-mono text-white tracking-tighter">
                          {customer.lastReadingValue.toLocaleString()}
                        </span>
                        <span className="text-[9px] font-bold text-muted-foreground/30 uppercase">
                          kWh
                        </span>
                      </div>
                    </td>
                    <td className="px-8 py-3 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <button
                          onClick={() => handleOpenModal(customer)}
                          className="inline-flex items-center justify-center w-8 h-8 rounded-xl bg-white/5 border border-white/5 hover:bg-primary hover:text-black hover:border-primary transition-all group/btn"
                        >
                          <ArrowUpRight className="w-3.5 h-3.5 transition-transform group-hover/btn:translate-x-0.5 group-hover/btn:-translate-y-0.5" />
                        </button>
                        {isAdmin && (
                          <button
                            onClick={() => handleDeleteCustomer(customer.id)}
                            className="inline-flex items-center justify-center w-8 h-8 rounded-xl bg-white/5 border border-white/5 hover:bg-red-500 hover:text-black hover:border-red-500 transition-all group/btn"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination Bar */}
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

      {/* Premium Edit Modal */}
      {isModalOpen && editingCustomer && (
        <div className="fixed inset-0 z-100 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-in fade-in duration-300">
          <Card className="w-full max-w-2xl bg-zinc-900 border-white/10 rounded-[2.5rem] overflow-hidden shadow-[0_0_50px_rgba(0,0,0,0.5)] border-t-primary/20">
            <form onSubmit={handleSave}>
              <div className="px-8 py-6 border-b border-white/5 flex items-center justify-between bg-white/2">
                <div className="space-y-1">
                  <h2 className="text-2xl font-black tracking-tighter uppercase italic text-primary">
                    Ficha de Suministro
                  </h2>
                  <p className="text-[10px] font-bold text-muted-foreground/40 uppercase tracking-widest">
                    Editor de Punto de Entrega
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="p-2 hover:bg-white/5 rounded-full transition-colors"
                >
                  <X className="w-6 h-6 text-muted-foreground/40" />
                </button>
              </div>

              <div className="p-8 grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Nombre Completo
                  </Label>
                  <Input
                    required
                    value={editingCustomer.name}
                    onChange={(e) =>
                      setEditingCustomer({
                        ...editingCustomer,
                        name: e.target.value,
                      })
                    }
                    className="h-12 bg-white/5 border-white/10 rounded-xl font-bold text-sm focus:border-primary/50"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Código del Suministro
                  </Label>
                  <Input
                    required
                    value={editingCustomer.code}
                    onChange={(e) =>
                      setEditingCustomer({
                        ...editingCustomer,
                        code: e.target.value,
                      })
                    }
                    className="h-12 bg-white/5 border-white/10 rounded-xl font-bold font-mono text-sm focus:border-primary/50"
                  />
                </div>
                <div className="space-y-2 md:col-span-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Dirección / Referencia del Suministro
                  </Label>
                  <Input
                    value={editingCustomer.address}
                    onChange={(e) =>
                      setEditingCustomer({
                        ...editingCustomer,
                        address: e.target.value,
                      })
                    }
                    className="h-12 bg-white/5 border-white/10 rounded-xl font-bold text-sm focus:border-primary/50"
                    placeholder="Ej: Frente a la plaza de armas, poste 12"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Latitud (GPS)
                  </Label>
                  <Input
                    type="number"
                    step="any"
                    value={editingCustomer.latitude}
                    onChange={(e) =>
                      setEditingCustomer({
                        ...editingCustomer,
                        latitude: parseFloat(e.target.value),
                      })
                    }
                    className="h-12 bg-white/5 border-white/10 rounded-xl font-bold font-mono text-sm focus:border-primary/50"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Longitud (GPS)
                  </Label>
                  <Input
                    type="number"
                    step="any"
                    value={editingCustomer.longitude}
                    onChange={(e) =>
                      setEditingCustomer({
                        ...editingCustomer,
                        longitude: parseFloat(e.target.value),
                      })
                    }
                    className="h-12 bg-white/5 border-white/10 rounded-xl font-bold font-mono text-sm focus:border-primary/50"
                  />
                </div>
                <div className="space-y-2 md:col-span-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Ubicación Georeferenciada
                  </Label>
                  <div className="rounded-2xl overflow-hidden border border-white/10">
                    <LocationPicker 
                      lat={editingCustomer.latitude || 0}
                      lng={editingCustomer.longitude || 0}
                      onChange={(lat, lng) => setEditingCustomer({
                        ...editingCustomer,
                        latitude: lat,
                        longitude: lng
                      })}
                    />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Tipo de Conexión
                  </Label>
                  <select
                    className="w-full h-12 bg-white/5 border border-white/10 rounded-xl px-4 text-sm font-bold focus:outline-none focus:border-primary/50 transition-all appearance-none cursor-pointer"
                    value={editingCustomer.connectionType}
                    onChange={(e) =>
                      setEditingCustomer({
                        ...editingCustomer,
                        connectionType: parseInt(e.target.value),
                      })
                    }
                  >
                    <option value={ConnectionType.MONOFASICA}>
                      Monofásica
                    </option>
                    <option value={ConnectionType.TRIFASICA}>Trifásica</option>
                  </select>
                </div>
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/60 ml-1">
                    Sector
                  </Label>
                  <select
                    className="w-full h-12 bg-white/5 border border-white/10 rounded-xl px-4 text-sm font-bold focus:outline-none focus:border-primary/50 transition-all appearance-none cursor-pointer"
                    value={editingCustomer.sectorId}
                    onChange={(e) =>
                      setEditingCustomer({
                        ...editingCustomer,
                        sectorId: e.target.value,
                      })
                    }
                  >
                    {data.sectors.map((s) => (
                      <option key={s.id} value={s.id}>
                        {s.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="px-8 py-6 bg-white/2 border-t border-white/5 flex items-center justify-between">
                {isAdmin && editingCustomer?.id && (
                  <Button
                    type="button"
                    variant="ghost"
                    onClick={() => handleDeleteCustomer(editingCustomer.id!)}
                    className="rounded-xl font-black uppercase text-[10px] tracking-widest text-red-500 hover:bg-red-500/10 hover:text-red-500"
                  >
                    <Trash2 className="w-4 h-4 mr-2" />
                    Dar de Baja
                  </Button>
                )}
                <div className="flex items-center gap-3 ml-auto">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => setIsModalOpen(false)}
                    className="rounded-xl font-black uppercase text-[10px] tracking-widest"
                  >
                    Cancelar
                  </Button>
                  <Button
                    type="submit"
                    disabled={saving || !isAdmin}
                    className="rounded-xl bg-primary text-black font-black uppercase text-[10px] tracking-widest px-8 shadow-[0_0_20px_rgba(255,0,255,0.2)]"
                  >
                    {saving ? "Guardando..." : "Guardar Cambios"}
                  </Button>
                </div>
              </div>
            </form>
          </Card>
        </div>
      )}
    </div>
  );
}
