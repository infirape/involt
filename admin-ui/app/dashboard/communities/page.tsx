"use client";

import { MapPin, Plus, Search, X, Edit2, Users } from "lucide-react";
import { useEffect, useState, useRef } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useAuth } from "@/lib/hooks/useAuth";
import { useRouter } from "next/navigation";
import { useCommunities } from "./hooks/useCommunities";
import { CommunitySchema } from "@/app/gen/involt/v1/models_pb";
import { create } from "@bufbuild/protobuf";
import { CustomerTable, type CustomerTableHandle } from "@/components/dashboard/CustomerTable";

export default function CommunitiesPage() {
  const { isAdmin, loading: authLoading } = useAuth();
  const router = useRouter();
  const {
    data,
    isModalOpen,
    setIsModalOpen,
    editingCommunity,
    setEditingCommunity,
    saving,
    searchQuery,
    setSearchQuery,
    handleOpenModal,
    handleSave,
  } = useCommunities();

  const [viewingCommunity, setViewingCommunity] = useState<{ id: string; name: string } | null>(null);
  const tableRef = useRef<CustomerTableHandle>(null);

  useEffect(() => {
    if (!authLoading && !isAdmin) {
      router.push("/dashboard");
    }
  }, [authLoading, isAdmin, router]);

  if (authLoading || !isAdmin) return null;

  return (
    <div className="p-8 space-y-8 animate-in fade-in duration-700">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-linear-to-br from-white to-white/40 bg-clip-text text-transparent">
            Gestión de Comunidades
          </h1>
          <p className="text-muted-foreground font-medium">
            Administrá los pueblos y caseríos del sistema
          </p>
        </div>
        <Button
          onClick={() => handleOpenModal()}
          className="h-11 font-black uppercase tracking-tighter rounded-xl group transition-all duration-500 hover:shadow-lg hover:shadow-primary/20"
        >
          <Plus className="w-4 h-4 mr-2 transition-transform group-hover:rotate-90" />
          Nueva Comunidad
        </Button>
      </div>

      <Card className="border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl">
        <CardHeader className="pb-4">
          <div className="relative group max-w-md">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
            <Input
              placeholder="Buscar comunidad..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 h-11 bg-white/5 border-white/5 focus:border-primary/30 rounded-xl transition-all"
            />
          </div>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-white/5">
                <tr className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 border-b border-white/5">
                  <th className="px-6 py-4">Comunidad</th>
                  <th className="px-6 py-4">Suministros</th>
                  <th className="px-6 py-4">ID</th>
                  <th className="px-6 py-4 text-right">Acciones</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {data.loading && data.communities.length === 0 ? (
                  [1, 2, 3].map((i) => (
                    <tr key={`skeleton-${i}`} className="animate-pulse">
                      <td colSpan={4} className="px-6 py-8">
                        <div className="h-4 bg-white/5 rounded w-full" />
                      </td>
                    </tr>
                  ))
                ) : data.communities.length === 0 ? (
                  <tr>
                    <td
                      colSpan={4}
                      className="px-6 py-12 text-center text-muted-foreground italic"
                    >
                      No se encontraron comunidades
                    </td>
                  </tr>
                ) : (
                  data.communities.map((c) => (
                    <tr
                      key={c.id}
                      className="group hover:bg-white/2 transition-colors"
                    >
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-linear-to-br from-primary/20 to-secondary/20 flex items-center justify-center border border-white/5">
                            <MapPin className="w-5 h-5 text-primary" />
                          </div>
                          <span className="font-bold text-sm tracking-tight">
                            {c.name}
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-xs font-black text-white bg-primary/10 px-2 py-1 rounded border border-primary/20 shadow-[0_0_10px_rgba(255,0,255,0.1)]">
                          {(c.customerCount ?? 0).toLocaleString()}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="text-[10px] font-mono text-muted-foreground/40">
                          {c.id}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <div className="flex justify-end gap-2">
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => setViewingCommunity({ id: c.id, name: c.name })}
                            className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                            title="Ver Suministros"
                          >
                            <Users className="w-4 h-4 text-cyan-400" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleOpenModal(c)}
                            className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                            title="Editar Comunidad"
                          >
                            <Edit2 className="w-4 h-4 text-primary" />
                          </Button>
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {/* Community Modal */}
      {isModalOpen && editingCommunity && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
          <Card className="w-full max-w-md border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300">
            <CardHeader className="flex flex-row items-center justify-between border-b border-white/5 pb-4">
              <div>
                <CardHeader className="p-0">
                  <h2 className="text-2xl font-black uppercase tracking-tighter">
                    {editingCommunity.id ? "Editar Comunidad" : "Nueva Comunidad"}
                  </h2>
                  <p className="text-xs text-muted-foreground font-medium uppercase tracking-widest">
                    Definí el nombre de la comunidad
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
                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                    Nombre de la Comunidad
                  </Label>
                  <Input
                    required
                    value={editingCommunity.name}
                    onChange={(e) =>
                      setEditingCommunity((prev) =>
                        prev ? create(CommunitySchema, { ...prev, name: e.target.value }) : null
                      )
                    }
                    className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                    placeholder="Ej: Alto Chetilla, Cadena..."
                  />
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
                  type="submit"
                  disabled={saving}
                  className="h-12 px-8 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] active:scale-[0.98] transition-all shadow-xl shadow-primary/20"
                >
                  {saving ? "Guardando..." : "Guardar Comunidad"}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}
      {/* View Customers Modal */}
      {viewingCommunity && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
          <Card className="w-full max-w-5xl border-white/10 bg-card shadow-2xl shadow-cyan-500/10 animate-in zoom-in-95 duration-300 overflow-hidden flex flex-col max-h-[90vh]">
            <div className="p-6 border-b border-white/5 flex items-center justify-between">
              <div className="space-y-1">
                <h2 className="text-2xl font-black uppercase tracking-tighter flex items-center gap-3">
                  <Users className="w-6 h-6 text-cyan-400" />
                  Suministros: {viewingCommunity.name}
                </h2>
                <p className="text-[10px] text-muted-foreground uppercase tracking-widest font-bold">
                  Gestión de clientes en esta comunidad
                </p>
              </div>
              <div className="flex items-center gap-3">
                <Button
                  onClick={() => tableRef.current?.openNewModal()}
                  className="h-10 font-black uppercase tracking-tighter rounded-xl bg-cyan-500 text-black hover:bg-cyan-400 transition-all"
                >
                  <Plus className="w-4 h-4 mr-2" />
                  Nuevo Suministro
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => setViewingCommunity(null)}
                  className="rounded-full hover:bg-white/10"
                >
                  <X className="w-5 h-5" />
                </Button>
              </div>
            </div>
            <div className="p-8 overflow-y-auto flex-1">
              <CustomerTable 
                ref={tableRef} 
                communityId={viewingCommunity.id} 
                hideHeaderButtons 
              />
            </div>
          </Card>
        </div>
      )}
    </div>
  );
}
