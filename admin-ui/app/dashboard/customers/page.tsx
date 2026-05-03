"use client";

import { MoreVertical, Plus, Search, User, X } from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { type Customer, ConnectionType } from "@/app/gen/involt/v1/models_pb";
import type { Sector } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { adminClient } from "@/lib/rpc";

export default function CustomersPage() {
  const [data, setData] = useState<{
    customers: Customer[];
    sectors: Sector[];
    loading: boolean;
  }>({
    customers: [],
    sectors: [],
    loading: true,
  });
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCustomer, setEditingCustomer] =
    useState<Partial<Customer> | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchData = useCallback(async () => {
    try {
      const [customersResp, sectorsResp] = await Promise.all([
        adminClient.getCustomers({}),
        adminClient.getSectors({}),
      ]);
      setData({
        customers: customersResp.customers,
        sectors: sectorsResp.sectors,
        loading: false,
      });
    } catch (err) {
      console.error("Failed to fetch data:", err);
      setData((prev) => ({ ...prev, loading: false }));
    }
  }, []);

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchData();
    }, 0);
    return () => clearTimeout(timer);
  }, [fetchData]);

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
      },
    );
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingCustomer) return;
    setSaving(true);
    try {
      await adminClient.upsertCustomer({
        customer: editingCustomer as Customer,
      });
      await fetchData();
      setIsModalOpen(false);
    } catch (err) {
      console.error("Failed to save customer:", err);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="p-8 space-y-8">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-gradient-to-br from-white to-white/40 bg-clip-text text-transparent">
            Padron de Clientes
          </h1>
          <p className="text-muted-foreground font-medium">Gestioná los puntos de suministro</p>
        </div>
        <Button
          onClick={() => handleOpenModal()}
          className="h-11 font-black uppercase tracking-tighter rounded-xl group transition-all duration-500 hover:shadow-lg hover:shadow-primary/20"
        >
          <Plus className="w-4 h-4 mr-2 transition-transform group-hover:rotate-90" />
          Nuevo Cliente
        </Button>
      </div>

      <Card className="border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl">
        <CardHeader className="pb-4">
          <div className="relative group max-w-md">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
            <Input
              placeholder="Buscar por nombre o código..."
              className="pl-10 h-11 bg-white/5 border-white/5 focus:border-primary/30 rounded-xl transition-all"
            />
          </div>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-white/5">
                <tr className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 border-b border-white/5">
                  <th className="px-6 py-4">Cliente</th>
                  <th className="px-6 py-4">Código</th>
                  <th className="px-6 py-4">Sector</th>
                  <th className="px-6 py-4 text-right">Acciones</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {data.loading && data.customers.length === 0 ? (
                  [1, 2, 3].map((i) => (
                    <tr key={`skeleton-${i}`} className="animate-pulse">
                      <td colSpan={4} className="px-6 py-8">
                        <div className="h-4 bg-white/5 rounded w-full" />
                      </td>
                    </tr>
                  ))
                ) : data.customers.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="px-6 py-12 text-center text-muted-foreground italic">
                      No hay clientes registrados
                    </td>
                  </tr>
                ) : (
                  data.customers.map((c) => (
                    <tr key={c.id} className="group hover:bg-white/[0.02] transition-colors">
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary/20 to-secondary/20 flex items-center justify-center border border-white/5">
                            <User className="w-5 h-5 text-primary" />
                          </div>
                          <div className="flex flex-col">
                            <span className="font-bold text-sm tracking-tight">{c.name}</span>
                            <span className="text-[10px] text-muted-foreground uppercase">
                              {c.address}
                            </span>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="font-mono text-xs font-bold text-muted-foreground">
                          {c.code}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-[10px] font-black uppercase tracking-widest text-secondary bg-secondary/10 px-2 py-1 rounded border border-secondary/20">
                          {data.sectors.find((s) => s.id === c.sectorId)?.name || c.sectorId}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleOpenModal(c)}
                          className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                        >
                          <MoreVertical className="w-4 h-4" />
                        </Button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {/* Premium Customer Modal */}
      {isModalOpen && editingCustomer && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
          <Card className="w-full max-w-xl border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300">
            <CardHeader className="flex flex-row items-center justify-between border-b border-white/5 pb-4">
              <div>
                <CardHeader className="p-0">
                  <h2 className="text-2xl font-black uppercase tracking-tighter">
                    {data.customers.find((c) => c.id === editingCustomer.id)
                      ? "Editar Cliente"
                      : "Nuevo Cliente"}
                  </h2>
                  <p className="text-xs text-muted-foreground font-medium uppercase tracking-widest">
                    Información del punto de suministro
                  </p>
                </CardHeader>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setIsModalOpen(false)}
                className="rounded-full hover:bg-white/10"
              >
                <X className="w-4 h-4" />
              </Button>
            </CardHeader>
            <form onSubmit={handleSave}>
              <CardContent className="p-6 space-y-6">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                      Nombre Completo
                    </Label>
                    <Input
                      required
                      value={editingCustomer.name}
                      onChange={(e) =>
                        setEditingCustomer((prev) => (prev ? { ...prev, name: e.target.value } : null))
                      }
                      className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                      Código de Suministro
                    </Label>
                    <Input
                      required
                      value={editingCustomer.code}
                      onChange={(e) =>
                        setEditingCustomer((prev) => (prev ? { ...prev, code: e.target.value } : null))
                      }
                      className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                    Dirección
                  </Label>
                  <Input
                    required
                    value={editingCustomer.address}
                    onChange={(e) =>
                      setEditingCustomer((prev) => (prev ? { ...prev, address: e.target.value } : null))
                    }
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
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
                      className="w-full h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-sm font-bold focus:border-primary/30 outline-none transition-all"
                    >
                      {data.sectors.map((s) => (
                        <option key={s.id} value={s.id}>
                          {s.name}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="space-y-2">
                    <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                      Tipo de Conexión
                    </Label>
                    <select
                      value={editingCustomer.connectionType}
                      onChange={(e) =>
                        setEditingCustomer((prev) =>
                          prev
                            ? { ...prev, connectionType: parseInt(e.target.value, 10) as ConnectionType }
                            : null,
                        )
                      }
                      className="w-full h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-sm font-bold focus:border-primary/30 outline-none transition-all"
                    >
                      <option value={ConnectionType.MONOFASICA}>Monofásica</option>
                      <option value={ConnectionType.TRIFASICA}>Trifásica</option>
                    </select>
                  </div>
                </div>
              </CardContent>
              <div className="p-6 border-t border-white/5 flex justify-end gap-3">
                <Button
                  type="button"
                  variant="ghost"
                  onClick={() => setIsModalOpen(false)}
                  className="h-12 px-6 font-bold uppercase tracking-widest rounded-xl hover:bg-white/10"
                >
                  Cancelar
                </Button>
                <Button
                  disabled={saving}
                  className="h-12 px-8 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all shadow-xl shadow-primary/20"
                >
                  {saving ? "Guardando..." : "Guardar Cliente"}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}
    </div>
  );
}
