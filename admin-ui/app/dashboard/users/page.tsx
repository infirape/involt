"use client";

import { MoreVertical, Plus, Search, Shield, User, X } from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { type User as AdminUser, UserRole } from "@/app/gen/involt/v1/admin_pb";
import type { Sector } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { adminClient } from "@/lib/rpc";

export default function UsersPage() {
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [sectors, setSectors] = useState<Sector[]>([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<Partial<AdminUser> | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchData = async () => {
    try {
      const [usersResp, sectorsResp] = await Promise.all([
        adminClient.getUsers({}),
        adminClient.getSectors({}),
      ]);
      setUsers(usersResp.users);
      setSectors(sectorsResp.sectors);
    } catch (err) {
      console.error("Failed to fetch data:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const [password, setPassword] = useState("");

  const handleOpenModal = (user: Partial<AdminUser> | null = null) => {
    setEditingUser(
      user || {
        id: crypto.randomUUID(),
        email: "",
        role: UserRole.READER,
        assignedSectorIds: [],
      },
    );
    setPassword("");
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingUser) return;
    setSaving(true);
    try {
      await adminClient.upsertUser({
        user: editingUser as AdminUser,
        password: password,
      });
      await fetchData();
      setIsModalOpen(false);
    } catch (err) {
      console.error("Failed to save user:", err);
    } finally {
      setSaving(false);
    }
  };

  const toggleSector = (sectorId: string) => {
    setEditingUser((prev) => {
      if (!prev) return null;
      const sectors = prev.assignedSectorIds || [];
      const newSectors = sectors.includes(sectorId)
        ? sectors.filter((id) => id !== sectorId)
        : [...sectors, sectorId];
      return { ...prev, assignedSectorIds: newSectors };
    });
  };

  return (
    <div className="p-8 space-y-8">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-gradient-to-br from-white to-white/40 bg-clip-text text-transparent">
            Usuarios del Sistema
          </h1>
          <p className="text-muted-foreground font-medium">Gestioná el equipo y sus permisos</p>
        </div>
        <Button
          onClick={() => handleOpenModal()}
          className="h-11 font-black uppercase tracking-tighter rounded-xl group transition-all duration-500 hover:shadow-lg hover:shadow-primary/20"
        >
          <Plus className="w-4 h-4 mr-2 transition-transform group-hover:rotate-90" />
          Nuevo Usuario
        </Button>
      </div>

      <Card className="border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl">
        <CardHeader className="pb-4">
          <div className="relative group max-w-md">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
            <Input
              placeholder="Buscar por email..."
              className="pl-10 h-11 bg-white/5 border-white/5 focus:border-primary/30 rounded-xl transition-all"
            />
          </div>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead className="bg-white/5">
                <tr className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60 border-b border-white/5">
                  <th className="px-6 py-4">Usuario</th>
                  <th className="px-6 py-4">Rol</th>
                  <th className="px-6 py-4">Sectores Asignados</th>
                  <th className="px-6 py-4 text-right">Acciones</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {loading && users.length === 0 ? (
                  [1, 2, 3].map((i) => (
                    <tr key={`skeleton-${i}`} className="animate-pulse">
                      <td colSpan={4} className="px-6 py-8">
                        <div className="h-4 bg-white/5 rounded w-full" />
                      </td>
                    </tr>
                  ))
                ) : users.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="px-6 py-12 text-center text-muted-foreground italic">
                      No hay usuarios registrados
                    </td>
                  </tr>
                ) : (
                  users.map((u) => (
                    <tr key={u.id} className="group hover:bg-white/[0.02] transition-colors">
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary/20 to-secondary/20 flex items-center justify-center border border-white/5">
                            <User className="w-5 h-5 text-primary" />
                          </div>
                          <span className="font-bold text-sm tracking-tight">{u.email}</span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          <Shield className="w-3.5 h-3.5 text-secondary" />
                          <span className="text-[10px] font-black uppercase tracking-widest text-secondary bg-secondary/10 px-2 py-1 rounded border border-secondary/20">
                            {UserRole[u.role].replace("USER_ROLE_", "")}
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex flex-wrap gap-1">
                          {u.assignedSectorIds.length === 0 ? (
                            <span className="text-xs text-muted-foreground/40 italic">
                              Todos los sectores
                            </span>
                          ) : (
                            u.assignedSectorIds.map((sid) => (
                              <span
                                key={sid}
                                className="text-[10px] font-bold text-muted-foreground bg-white/5 px-2 py-1 rounded border border-white/5"
                              >
                                {sectors.find((s) => s.id === sid)?.name || sid}
                              </span>
                            ))
                          )}
                        </div>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <div className="flex justify-end gap-2">
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleOpenModal(u)}
                            className="w-8 h-8 rounded-lg hover:bg-white/10 transition-colors"
                          >
                            <MoreVertical className="w-4 h-4" />
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

      {/* Premium User Modal */}
      {isModalOpen && editingUser && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-background/80 backdrop-blur-md animate-in fade-in duration-300">
          <Card className="w-full max-w-xl border-white/10 bg-card shadow-2xl shadow-primary/10 animate-in zoom-in-95 duration-300">
            <CardHeader className="flex flex-row items-center justify-between border-b border-white/5 pb-4">
              <div>
                <CardHeader className="p-0">
                  <h2 className="text-2xl font-black uppercase tracking-tighter">
                    {users.find((u) => u.id === editingUser.id)
                      ? "Editar Usuario"
                      : "Nuevo Usuario"}
                  </h2>
                  <p className="text-xs text-muted-foreground font-medium uppercase tracking-widest">
                    Configura los accesos y permisos
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
                      Correo Electrónico
                    </Label>
                    <Input
                      required
                      type="email"
                      value={editingUser.email}
                      onChange={(e) =>
                        setEditingUser((prev) => (prev ? { ...prev, email: e.target.value } : null))
                      }
                      className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                      placeholder="usuario@qarwaqiru.com"
                    />
                  </div>
                  <div className="space-y-2">
                    <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                      Contraseña {users.find((u) => u.id === editingUser.id) ? "(Opcional)" : ""}
                    </Label>
                    <Input
                      required={!users.find((u) => u.id === editingUser.id)}
                      type="password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      className="bg-white/5 border-white/5 focus:border-primary/30 rounded-xl h-11"
                      placeholder="••••••••"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                    Rol de Usuario
                  </Label>
                  <select
                    value={editingUser.role}
                    onChange={(e) =>
                      setEditingUser((prev) =>
                        prev ? { ...prev, role: parseInt(e.target.value, 10) as UserRole } : null,
                      )
                    }
                    className="w-full h-11 px-4 bg-white/5 border border-white/5 rounded-xl text-sm font-bold focus:border-primary/30 outline-none transition-all cursor-pointer"
                  >
                    <option value={UserRole.ADMIN}>Administrador (Acceso Total)</option>
                    <option value={UserRole.SUPERVISOR}>Supervisor (Lecturas y Reportes)</option>
                    <option value={UserRole.READER}>Lector (Solo captura de datos)</option>
                  </select>
                </div>

                <div className="space-y-3">
                  <Label className="text-[10px] font-black uppercase tracking-widest opacity-50">
                    Sectores Asignados
                  </Label>
                  <div className="grid grid-cols-2 gap-2">
                    {sectors.map((s) => (
                      <button
                        key={s.id}
                        type="button"
                        onClick={() => toggleSector(s.id)}
                        className={`flex items-center justify-between p-3 rounded-xl border transition-all text-xs font-bold uppercase ${
                          editingUser.assignedSectorIds?.includes(s.id)
                            ? "bg-primary/10 border-primary/30 text-primary"
                            : "bg-white/5 border-white/5 text-muted-foreground hover:bg-white/10"
                        }`}
                      >
                        {s.name}
                        {editingUser.assignedSectorIds?.includes(s.id) && (
                          <Shield className="w-3 h-3" />
                        )}
                      </button>
                    ))}
                  </div>
                  <p className="text-[10px] text-muted-foreground/60 italic">
                    * Si no se seleccionan sectores, el usuario tendrá acceso a todos.
                  </p>
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
                  {saving ? "Guardando..." : "Guardar Usuario"}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}
    </div>
  );
}
