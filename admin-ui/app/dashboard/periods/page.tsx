"use client";

import { Calendar, ChevronRight, Lock, Unlock, AlertCircle } from "lucide-react";
import { useAuth } from "@/lib/hooks/useAuth";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { PeriodStatus } from "@/app/gen/involt/v1/models_pb";
import { usePeriods } from "./hooks/usePeriods";

export default function PeriodsPage() {
  const { isAdmin, loading: authLoading } = useAuth();
  const {
    loading,
    closing,
    data,
    handleClosePeriod,
    handleOpenManual,
  } = usePeriods();

  if (authLoading || !isAdmin) return null;

  const { periods, currentPeriod, stats } = data;

  const handleManualPrompt = () => {
    const periodId = prompt("Ingrese el periodo (YYYY-MM):", new Date().toISOString().slice(0, 7));
    if (periodId) handleOpenManual(periodId);
  };

  return (
    <div className="p-8 space-y-8 animate-in fade-in duration-700">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-linear-to-br from-white to-white/40 bg-clip-text text-transparent">
            Gestión de Periodos
          </h1>
          <p className="text-muted-foreground font-medium">
            Control de cierres mensuales y apertura de facturación
          </p>
        </div>
        <Button 
          onClick={handleManualPrompt}
          disabled={!!currentPeriod || loading}
          variant="outline" 
          className="border-white/10 hover:bg-white/5 rounded-xl font-bold uppercase tracking-widest text-xs disabled:opacity-30"
        >
          Apertura Manual
        </Button>
      </div>

      <div className="grid gap-8 md:grid-cols-3">
        {/* Current Period Status */}
        <Card className="md:col-span-2 border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl overflow-hidden relative">
          <div className="absolute top-0 right-0 p-4 opacity-5 pointer-events-none">
            <Calendar className="w-32 h-32 rotate-12" />
          </div>
          
          <CardHeader>
            <div className="flex items-center justify-between">
              <div className="space-y-1">
                <CardTitle className="text-2xl font-black tracking-tight uppercase">
                  Periodo Actual: {currentPeriod?.id || "Ninguno"}
                </CardTitle>
                <CardDescription>Estado de la cobranza en curso</CardDescription>
              </div>
              {currentPeriod && (
                <Badge className="bg-primary/20 text-primary border-primary/30 font-black animate-pulse">
                  EN CURSO
                </Badge>
              )}
            </div>
          </CardHeader>
          
          <CardContent className="space-y-8">
            {loading ? (
              <div className="flex flex-col items-center justify-center py-20 animate-pulse">
                <Calendar className="w-12 h-12 text-primary/20 mb-4" />
                <p className="text-[10px] font-black uppercase tracking-[0.3em] opacity-20">Cargando Periodo...</p>
              </div>
            ) : currentPeriod ? (
              <>
                <div className="grid grid-cols-3 gap-6">
                  <div className="p-4 rounded-2xl bg-white/5 border border-white/5 space-y-1">
                    <p className="text-[10px] font-black uppercase text-muted-foreground/60 tracking-wider">Total Clientes</p>
                    <p className="text-3xl font-black tracking-tighter">{stats?.totalCustomers || 0}</p>
                  </div>
                  <div className="p-4 rounded-2xl bg-primary/5 border border-primary/10 space-y-1">
                    <p className="text-[10px] font-black uppercase text-primary/60 tracking-wider">Con Medida</p>
                    <p className="text-3xl font-black tracking-tighter text-primary">{stats?.readingsCaptured || 0}</p>
                  </div>
                  <div className="p-4 rounded-2xl bg-red-500/5 border border-red-500/10 space-y-1">
                    <p className="text-[10px] font-black uppercase text-red-500/60 tracking-wider">Pendientes</p>
                    <p className="text-3xl font-black tracking-tighter text-red-500">{stats?.missingReadings || 0}</p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <h3 className="text-sm font-black uppercase tracking-widest text-muted-foreground">Clientes sin medida</h3>
                    <Badge variant="outline" className="text-[10px] opacity-60">
                      {stats?.missingCustomers?.length || 0} mostrados
                    </Badge>
                  </div>
                  
                  <div className="rounded-2xl border border-white/5 overflow-hidden max-h-[300px] overflow-y-auto scrollbar-thin">
                    <table className="w-full text-left text-xs">
                      <thead className="bg-white/5 sticky top-0">
                        <tr className="text-[10px] font-black uppercase opacity-40">
                          <th className="px-4 py-3">Código</th>
                          <th className="px-4 py-3">Cliente</th>
                          <th className="px-4 py-3">Sector</th>
                          <th className="px-4 py-3">Supervisor</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-white/5">
                        {stats?.missingCustomers?.map((c) => (
                          <tr key={c.id} className="hover:bg-white/5 transition-colors">
                            <td className="px-4 py-3 font-mono text-primary/80">{c.code}</td>
                            <td className="px-4 py-3 font-bold">{c.name}</td>
                            <td className="px-4 py-3 opacity-60">{c.sectorName}</td>
                            <td className="px-4 py-3">
                              <span className="px-2 py-1 rounded-md bg-white/5 text-[10px] font-bold text-muted-foreground uppercase">
                                {c.supervisor}
                              </span>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

                <div className="pt-4 border-t border-white/5 flex items-center justify-between">
                  <div className="flex items-center gap-2 text-xs text-muted-foreground">
                    <AlertCircle className="w-4 h-4 text-amber-500" />
                    <span>No podés cerrar si faltan medidas críticas.</span>
                  </div>
                  <Button 
                    onClick={() => handleClosePeriod(currentPeriod.id)}
                    disabled={closing || (stats?.missingReadings || 0) > 0}
                    className="h-12 px-8 font-black uppercase tracking-tighter rounded-xl bg-primary text-primary-foreground hover:scale-[1.02] shadow-xl shadow-primary/20 transition-all"
                  >
                    {closing ? "Cerrando..." : "Cerrar Periodo"}
                  </Button>
                </div>
              </>
            ) : (
              <div className="flex flex-col items-center justify-center py-12 space-y-4 text-center">
                <div className="w-16 h-16 rounded-full bg-white/5 flex items-center justify-center">
                  <Unlock className="w-8 h-8 text-muted-foreground opacity-20" />
                </div>
                <div className="space-y-1">
                  <p className="font-bold text-muted-foreground">No hay periodos abiertos</p>
                  <p className="text-xs text-muted-foreground/60">Aperturá uno manualmente o esperá al próximo mes.</p>
                </div>
                <Button onClick={handleManualPrompt} className="bg-white/10 hover:bg-white/20 text-white rounded-xl font-bold uppercase tracking-widest text-xs px-6">
                  Aperturar Ahora
                </Button>
              </div>
            )}
          </CardContent>
        </Card>

        {/* History */}
        <Card className="border-white/5 bg-card/20 backdrop-blur-sm">
          <CardHeader>
            <CardTitle className="text-xl font-bold tracking-tight">Historial</CardTitle>
            <CardDescription>Últimos periodos cerrados</CardDescription>
          </CardHeader>
          <CardContent className="p-0">
            <div className="divide-y divide-white/5">
              {periods.filter(p => p.status === PeriodStatus.CLOSED).slice(0, 5).map((p) => (
                <div key={p.id} className="p-4 flex items-center justify-between group hover:bg-white/5 transition-colors">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center group-hover:scale-110 transition-transform">
                      <Lock className="w-4 h-4 text-muted-foreground/60" />
                    </div>
                    <div>
                      <p className="font-bold text-sm">{p.id}</p>
                      <p className="text-[10px] text-muted-foreground opacity-60 uppercase">Cerrado</p>
                    </div>
                  </div>
                  <ChevronRight className="w-4 h-4 text-muted-foreground/20 group-hover:text-primary transition-colors" />
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
