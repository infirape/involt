"use client";

import {
  Plus,
  Search,
  ChevronLeft,
  ChevronRight,
  Filter,
  ArrowUpRight,
  Users,
  Trash2,
} from "lucide-react";
import { ConnectionType } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import dynamic from "next/dynamic";
import { useAuth } from "@/lib/hooks/useAuth";
import { useCustomers } from "./hooks/useCustomers";
import { X } from "lucide-react";

const LocationPicker = dynamic(
  () => import("@/components/dashboard/LocationPicker"),
  {
    ssr: false,
    loading: () => (
      <div className="h-64 w-full rounded-2xl bg-white/5 animate-pulse flex items-center justify-center border border-white/10">
        <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
          Cargando Mapa de Georeferencia...
        </span>
      </div>
    ),
  },
);

export default function CustomersPage() {
  const { isAdmin } = useAuth();
  const {
    data,
    pagination,
    setPagination,
    filters,
    setFilters,
    isModalOpen,
    setIsModalOpen,
    editingCustomer,
    setEditingCustomer,
    saving,
    handleOpenModal,
    handleSave,
    handleDeleteCustomer,
    totalPages,
  } = useCustomers();

  if (!isAdmin) return null;

  return (
    <div className="p-8 space-y-8 animate-in fade-in duration-700">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-linear-to-br from-white to-white/40 bg-clip-text text-transparent">
            Gestión de Suministros
          </h1>
          <p className="text-muted-foreground font-medium">
            Padrón general de clientes y medidores de Qarwaqiru
          </p>
        </div>
        <Button
          onClick={() => handleOpenModal()}
          className="h-11 font-black uppercase tracking-tighter rounded-xl group transition-all duration-500 hover:shadow-lg hover:shadow-primary/20"
        >
          <Plus className="w-4 h-4 mr-2 transition-transform group-hover:rotate-90" />
          Nuevo Suministro
        </Button>
      </div>

      <div className="grid gap-6 md:grid-cols-4">
        <Card className="md:col-span-3 border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl overflow-hidden">
          <div className="p-6 border-b border-white/5 flex flex-col gap-4 md:flex-row md:items-center justify-between">
            <div className="relative group max-w-md w-full">
              <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
              <Input
                placeholder="Buscar por código o nombre..."
                value={filters.searchQuery}
                onChange={(e) =>
                  setFilters((prev) => ({
                    ...prev,
                    searchQuery: e.target.value,
                  }))
                }
                className="pl-10 h-11 bg-white/5 border-white/5 focus:border-primary/30 rounded-xl transition-all"
              />
            </div>
            <div className="flex items-center gap-2">
              <Filter className="w-4 h-4 text-muted-foreground" />
              <select
                value={filters.sectorId}
                onChange={(e) =>
                  setFilters((prev) => ({ ...prev, sectorId: e.target.value }))
                }
                className="h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-xs font-bold uppercase tracking-widest focus:border-primary/30 outline-none transition-all cursor-pointer"
              >
                <option value="">Todos los Sectores</option>
                {data.sectors.map((s) => (
                  <option key={s.id} value={s.id}>
                    {s.name}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-white/5">
                <tr className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 border-b border-white/5">
                  <th className="px-6 py-4">Código</th>
                  <th className="px-6 py-4">Cliente</th>
                  <th className="px-6 py-4">Sector</th>
                  <th className="px-6 py-4">Conexión</th>
                  <th className="px-6 py-4 text-right">Acciones</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {data.loading
                  ? [1, 2, 3, 4, 5].map((i) => (
                      <tr key={i} className="animate-pulse">
                        <td colSpan={5} className="px-6 py-6">
                          <div className="h-4 bg-white/5 rounded w-full" />
                        </td>
                      </tr>
                    ))
                  : data.customers.map((c) => (
                      <tr
                        key={c.id}
                        className="group hover:bg-white/2 transition-colors"
                      >
                        <td className="px-6 py-4">
                          <span className="font-mono text-xs font-bold text-primary/80 bg-primary/5 px-2 py-1 rounded">
                            {c.code}
                          </span>
                        </td>
                        <td className="px-6 py-4">
                          <div className="flex flex-col">
                            <span className="font-bold text-sm tracking-tight">
                              {c.name}
                            </span>
                            <span className="text-[10px] opacity-40 uppercase font-medium">
                              {c.address}
                            </span>
                          </div>
                        </td>
                        <td className="px-6 py-4">
                          <span className="text-[10px] font-bold uppercase tracking-widest opacity-60">
                            {data.sectors.find((s) => s.id === c.sectorId)
                              ?.name || "S/S"}
                          </span>
                        </td>
                        <td className="px-6 py-4">
                          <span className="text-[9px] font-black uppercase bg-white/5 border border-white/10 px-2 py-1 rounded-md">
                            {ConnectionType[c.connectionType]}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-right">
                          <div className="flex justify-end gap-2">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleOpenModal(c)}
                              className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                            >
                              <ArrowUpRight className="w-4 h-4" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleDeleteCustomer(c.id)}
                              className="w-8 h-8 rounded-lg hover:bg-red-500/10 text-red-500/40 hover:text-red-500 transition-all"
                            >
                              <Trash2 className="w-4 h-4" />
                            </Button>
                          </div>
                        </td>
                      </tr>
                    ))}
              </tbody>
            </table>
          </div>

          <div className="p-6 border-t border-white/5 flex items-center justify-between bg-white/2">
            <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
              Mostrando {data.customers.length} de {data.totalCount} Suministros
            </p>
            <div className="flex items-center gap-2">
              <Button
                variant="outline"
                size="icon"
                disabled={pagination.pageNumber === 1}
                onClick={() =>
                  setPagination((p) => ({ ...p, pageNumber: p.pageNumber - 1 }))
                }
                className="w-8 h-8 rounded-lg border-white/10 hover:bg-white/10"
              >
                <ChevronLeft className="w-4 h-4" />
              </Button>
              <span className="text-[10px] font-black uppercase tracking-widest">
                {pagination.pageNumber} / {totalPages}
              </span>
              <Button
                variant="outline"
                size="icon"
                disabled={pagination.pageNumber === totalPages}
                onClick={() =>
                  setPagination((p) => ({ ...p, pageNumber: p.pageNumber + 1 }))
                }
                className="w-8 h-8 rounded-lg border-white/10 hover:bg-white/10"
              >
                <ChevronRight className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </Card>

        <div className="space-y-6">
          <Card className="p-6 border-white/5 bg-primary/5 backdrop-blur-sm relative overflow-hidden group">
            <div className="absolute top-0 right-0 p-4 opacity-5 pointer-events-none group-hover:scale-110 transition-transform duration-700">
              <Users className="w-24 h-24 rotate-12" />
            </div>
            <div className="relative space-y-4">
              <div className="space-y-1">
                <p className="text-[10px] font-black uppercase tracking-widest text-primary/60">
                  Total Registrados
                </p>
                <p className="text-4xl font-black tracking-tighter text-primary">
                  {data.totalCount}
                </p>
              </div>
              <p className="text-[10px] font-medium text-muted-foreground/60 leading-relaxed uppercase tracking-widest">
                Todos los suministros están georeferenciados para facilitar la
                lectura mensual.
              </p>
            </div>
          </Card>
        </div>
      </div>

      {/* Premium Customer Modal */}
      {isModalOpen && editingCustomer && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
          <Card className="w-full max-w-4xl border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300 overflow-hidden">
            <div className="grid md:grid-cols-2">
              <div className="p-8 border-r border-white/5">
                <div className="flex items-center justify-between mb-8">
                  <div className="space-y-1">
                    <h2 className="text-2xl font-black uppercase tracking-tighter">
                      {data.customers.find((c) => c.id === editingCustomer.id)
                        ? "Editar Suministro"
                        : "Nuevo Suministro"}
                    </h2>
                    <p className="text-xs text-muted-foreground font-medium uppercase tracking-widest">
                      Datos maestros del cliente
                    </p>
                  </div>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setIsModalOpen(false)}
                    className="rounded-full hover:bg-white/10 md:hidden"
                  >
                    <X className="w-4 h-4" />
                  </Button>
                </div>

                <form onSubmit={handleSave} className="space-y-6">
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                        Código de Suministro
                      </Label>
                      <Input
                        required
                        value={editingCustomer.code}
                        onChange={(e) =>
                          setEditingCustomer((prev) =>
                            prev
                              ? { ...prev, code: e.target.value.toUpperCase() }
                              : null,
                          )
                        }
                        className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11 uppercase font-mono"
                        placeholder="ACH001"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                        Sector
                      </Label>
                      <select
                        value={editingCustomer.sectorId}
                        onChange={(e) =>
                          setEditingCustomer((prev) =>
                            prev ? { ...prev, sectorId: e.target.value } : null,
                          )
                        }
                        className="w-full h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-sm font-bold focus:border-primary/30 outline-none transition-all cursor-pointer"
                      >
                        {data.sectors.map((s) => (
                          <option key={s.id} value={s.id}>
                            {s.name}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="space-y-2">
                    <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                      Nombre Completo
                    </Label>
                    <Input
                      required
                      value={editingCustomer.name}
                      onChange={(e) =>
                        setEditingCustomer((prev) =>
                          prev ? { ...prev, name: e.target.value } : null,
                        )
                      }
                      className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                      placeholder="Nombre del titular"
                    />
                  </div>

                  <div className="space-y-2">
                    <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                      Dirección
                    </Label>
                    <Input
                      required
                      value={editingCustomer.address}
                      onChange={(e) =>
                        setEditingCustomer((prev) =>
                          prev ? { ...prev, address: e.target.value } : null,
                        )
                      }
                      className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                      placeholder="Ubicación física"
                    />
                  </div>

                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                        Tipo de Conexión
                      </Label>
                      <select
                        value={editingCustomer.connectionType}
                        onChange={(e) =>
                          setEditingCustomer((prev) =>
                            prev
                              ? {
                                  ...prev,
                                  connectionType: parseInt(
                                    e.target.value,
                                    10,
                                  ) as ConnectionType,
                                }
                              : null,
                          )
                        }
                        className="w-full h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-sm font-bold focus:border-primary/30 outline-none transition-all cursor-pointer"
                      >
                        <option value={ConnectionType.MONOFASICA}>
                          Monofásica
                        </option>
                        <option value={ConnectionType.TRIFASICA}>
                          Trifásica
                        </option>
                      </select>
                    </div>
                    <div className="space-y-2">
                      <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                        Tarifa (S/ x kWh)
                      </Label>
                      <Input
                        type="number"
                        step="0.01"
                        value={editingCustomer.tariff}
                        onChange={(e) =>
                          setEditingCustomer((prev) =>
                            prev
                              ? { ...prev, tariff: parseFloat(e.target.value) }
                              : null,
                          )
                        }
                        className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                      />
                    </div>
                  </div>

                  <div className="pt-6 border-t border-white/5 flex gap-3">
                    <Button
                      type="button"
                      variant="ghost"
                      onClick={() => setIsModalOpen(false)}
                      className="h-12 flex-1 font-bold uppercase tracking-widest rounded-xl hover:bg-white/10"
                    >
                      Cancelar
                    </Button>
                    <Button
                      type="submit"
                      disabled={saving}
                      className="h-12 flex-1 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all shadow-xl shadow-primary/20"
                    >
                      {saving ? "Guardando..." : "Guardar"}
                    </Button>
                  </div>
                </form>
              </div>

              <div className="bg-white/2 p-8 space-y-6">
                <div className="flex items-center justify-between">
                  <div className="space-y-1">
                    <h3 className="text-sm font-black uppercase tracking-widest">
                      Georeferencia
                    </h3>
                    <p className="text-[10px] text-muted-foreground uppercase">
                      Ubica el medidor en el mapa
                    </p>
                  </div>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => setIsModalOpen(false)}
                    className="rounded-full hover:bg-white/10 hidden md:flex"
                  >
                    <X className="w-4 h-4" />
                  </Button>
                </div>

                <LocationPicker
                  lat={editingCustomer.latitude || 0}
                  lng={editingCustomer.longitude || 0}
                  onChange={(lat, lng) =>
                    setEditingCustomer((prev) =>
                      prev ? { ...prev, latitude: lat, longitude: lng } : null,
                    )
                  }
                />

                <div className="grid grid-cols-2 gap-4">
                  <div className="p-4 rounded-2xl bg-white/5 border border-white/5">
                    <p className="text-[10px] font-black uppercase opacity-40 mb-1">
                      Latitud
                    </p>
                    <p className="text-xs font-mono font-bold">
                      {editingCustomer.latitude?.toFixed(6) || "0.000000"}
                    </p>
                  </div>
                  <div className="p-4 rounded-2xl bg-white/5 border border-white/5">
                    <p className="text-[10px] font-black uppercase opacity-40 mb-1">
                      Longitud
                    </p>
                    <p className="text-xs font-mono font-bold">
                      {editingCustomer.longitude?.toFixed(6) || "0.000000"}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </Card>
        </div>
      )}
    </div>
  );
}
