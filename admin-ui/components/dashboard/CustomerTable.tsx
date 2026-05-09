"use client";

import { useCallback, useEffect, forwardRef, useImperativeHandle } from "react";
import {
  Search,
  ChevronLeft,
  ChevronRight,
  Filter,
  ArrowUpRight,
  Trash2,
  X,
  Plus,
} from "lucide-react";
import { ConnectionType, type Customer, Sector } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { useCustomers } from "@/app/dashboard/customers/hooks/useCustomers";
import dynamic from "next/dynamic";
import { createPortal } from "react-dom";

const LocationPicker = dynamic(
  () => import("@/components/dashboard/LocationPicker"),
  {
    ssr: false,
    loading: () => (
      <div className="h-64 w-full rounded-2xl bg-white/5 animate-pulse flex items-center justify-center border border-white/10">
        <span className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
          Cargando Mapa...
        </span>
      </div>
    ),
  },
);

export interface CustomerTableHandle {
  openNewModal: () => void;
}

interface CustomerTableProps {
  communityId?: string;
  showActions?: boolean;
  hideHeaderButtons?: boolean;
}

export const CustomerTable = forwardRef<CustomerTableHandle, CustomerTableProps>(
  ({ communityId, showActions = true, hideHeaderButtons = false }, ref) => {
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

    // Expose openNewModal to parent
    useImperativeHandle(ref, () => ({
      openNewModal: () => {
        const defaultSector = data.sectors.find(s => s.communityId === communityId);
        handleOpenModal(defaultSector ? { sectorId: defaultSector.id } : null);
      },
    }));

    useEffect(() => {
      if (communityId) {
        setFilters((prev) => ({ ...prev, communityId }));
      }
    }, [communityId, setFilters]);

    return (
      <div className="space-y-4">
        <div className="flex flex-col gap-4 md:flex-row md:items-center justify-between">
          {/* Search bar - ALWAYS VISIBLE */}
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
              className="pl-10 h-10 bg-white/5 border-white/5 focus:border-primary/30 rounded-xl transition-all text-sm"
            />
          </div>

          <div className="flex items-center gap-3">
            {/* Header buttons - HIDDEN IF hideHeaderButtons is true */}
            {!hideHeaderButtons && !communityId && (
              <Button
                onClick={() => handleOpenModal()}
                size="sm"
                className="h-10 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all"
              >
                <Plus className="w-4 h-4 mr-2" />
                Nuevo Suministro
              </Button>
            )}
            {!hideHeaderButtons && !communityId && (
              <div className="flex items-center gap-2">
                <Filter className="w-4 h-4 text-muted-foreground" />
                <select
                  value={filters.sectorId}
                  onChange={(e) =>
                    setFilters((prev) => ({ ...prev, sectorId: e.target.value }))
                  }
                  className="h-10 px-4 bg-white/5 border border-white/5 rounded-xl text-[10px] font-bold uppercase tracking-widest focus:border-primary/30 outline-none transition-all cursor-pointer"
                >
                  <option value="">Todos los Sectores</option>
                  {data.sectors.map((s) => (
                    <option key={s.id} value={s.id}>
                      {s.name}
                    </option>
                  ))}
                </select>
              </div>
            )}
          </div>
        </div>

        <div className="overflow-x-auto rounded-xl border border-white/5">
          <table className="w-full text-left">
            <thead className="bg-white/5">
              <tr className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 border-b border-white/5">
                <th className="px-6 py-4">Código</th>
                <th className="px-6 py-4">Cliente</th>
                <th className="px-6 py-4">{communityId ? "Sector" : "Comunidad"}</th>
                <th className="px-6 py-4">Conexión</th>
                {showActions && (
                  <th className="px-6 py-4 text-right">Acciones</th>
                )}
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {data.loading && data.customers.length === 0
                ? [1, 2, 3].map((i) => (
                    <tr key={i} className="animate-pulse">
                      <td colSpan={showActions ? 5 : 4} className="px-6 py-6">
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
                        <span className="font-mono text-[10px] font-bold text-primary/80 bg-primary/5 px-2 py-1 rounded">
                          {c.code}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex flex-col">
                          <span className="font-bold text-sm tracking-tight">
                            {c.name}
                          </span>
                          <span className="text-[9px] opacity-40 uppercase font-medium">
                            {c.address}
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-[10px] font-bold uppercase tracking-widest opacity-60">
                          {data.sectors.find((s) => s.id === c.sectorId)?.name ||
                            "S/S"}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-[9px] font-black uppercase bg-white/5 border border-white/10 px-2 py-1 rounded-md">
                          {ConnectionType[c.connectionType]}
                        </span>
                      </td>
                      {showActions && (
                        <td className="px-6 py-4 text-right">
                          <div className="flex justify-end gap-2">
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleOpenModal(c)}
                              className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                            >
                              <ArrowUpRight className="w-4 h-4 text-primary" />
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
                      )}
                    </tr>
                  ))}
            </tbody>
          </table>
        </div>

        {/* Paginator - ALWAYS VISIBLE */}
        <div className="flex items-center justify-between py-2">
          <p className="text-[10px] font-black uppercase tracking-widest text-muted-foreground/40">
            Total: {data.totalCount} suministros
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
              {pagination.pageNumber} / {totalPages || 1}
            </span>
            <Button
              variant="outline"
              size="icon"
              disabled={pagination.pageNumber === totalPages || totalPages === 0}
              onClick={() =>
                setPagination((p) => ({ ...p, pageNumber: p.pageNumber + 1 }))
              }
              className="w-8 h-8 rounded-lg border-white/10 hover:bg-white/10"
            >
              <ChevronRight className="w-4 h-4" />
            </Button>
          </div>
        </div>

        {/* Reusable Edit Customer Modal */}
        {isModalOpen && editingCustomer && typeof document !== "undefined" && createPortal(
          <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
            <Card className="w-full max-w-4xl border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300 overflow-hidden">
              <div className="grid grid-cols-1 md:grid-cols-2 h-full">
                <div className="p-8 space-y-6 border-r border-white/5">
                  <div className="space-y-1">
                    <h2 className="text-2xl font-black uppercase tracking-tighter">
                      {editingCustomer.id
                        ? "Editar Suministro"
                        : "Nuevo Suministro"}
                    </h2>
                    <p className="text-[10px] text-muted-foreground font-medium uppercase tracking-widest">
                      Información técnica del cliente
                    </p>
                  </div>

                  <form onSubmit={handleSave} className="space-y-4">
                    <div className="grid grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                          Código Suministro
                        </Label>
                        <Input
                          required
                          value={editingCustomer.code}
                          onChange={(e) =>
                            setEditingCustomer((prev) =>
                              prev ? { ...prev, code: e.target.value } : null,
                            )
                          }
                          className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11 font-mono font-bold text-primary"
                          placeholder="SUM-000"
                        />
                      </div>
                      <div className="space-y-2">
                        <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                          {communityId ? "Sector de la Comunidad" : "Sector"}
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
                          {data.sectors
                            .filter(s => !communityId || s.communityId === communityId)
                            .map((s) => (
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

                    <div className="grid grid-cols-1 gap-4">
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
          </div>,
          document.body
        )}
      </div>
    );
  },
);

CustomerTable.displayName = "CustomerTable";
