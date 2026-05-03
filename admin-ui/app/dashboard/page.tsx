"use client";

import { FileText, MapIcon, Users, Zap, CheckCircle2, Clock, ArrowUpRight, Activity } from "lucide-react";
import dynamic from "next/dynamic";
import { useEffect, useState, useCallback } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { adminClient } from "@/lib/rpc";
import type { GetDashboardStatsResponse } from "@/app/gen/involt/v1/admin_pb";

const CustomerMap = dynamic(() => import("@/components/dashboard/CustomerMap"), {
  ssr: false,
  loading: () => (
    <div className="h-[400px] w-full rounded-3xl bg-white/5 animate-pulse flex items-center justify-center border border-white/5">
      <div className="flex flex-col items-center gap-3">
        <div className="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin" />
        <p className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground/60">
          Cargando Telemetría...
        </p>
      </div>
    </div>
  ),
});

export default function DashboardPage() {
  const [data, setData] = useState<{
    stats: GetDashboardStatsResponse | null;
    loading: boolean;
  }>({
    stats: null,
    loading: true,
  });

  const fetchStats = useCallback(async () => {
    try {
      const resp = await adminClient.getDashboardStats({});
      setData({
        stats: resp,
        loading: false,
      });
    } catch (err) {
      console.error("Failed to fetch dashboard stats:", err);
      setData((prev) => ({ ...prev, loading: false }));
    }
  }, []);

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchStats();
    }, 0);
    return () => clearTimeout(timer);
  }, [fetchStats]);

  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setMousePos({ x: e.clientX, y: e.clientY });
    };
    window.addEventListener("mousemove", handleMouseMove);
    return () => window.removeEventListener("mousemove", handleMouseMove);
  }, []);

  const cards = [
    { 
      title: "Clientes", 
      value: data.stats?.totalCustomers.toLocaleString() || "0", 
      icon: Users, 
      color: "from-blue-500/20 to-blue-600/5",
      accent: "bg-blue-500",
      description: "Padron general"
    },
    { 
      title: "Staff", 
      value: data.stats?.totalUsers.toLocaleString() || "0", 
      icon: MapIcon, 
      color: "from-emerald-500/20 to-emerald-600/5",
      accent: "bg-emerald-500",
      description: "Acceso administrativo"
    },
    { 
      title: "Lecturas", 
      value: data.stats?.totalReadingsPeriod.toLocaleString() || "0", 
      icon: Zap, 
      color: "from-primary/20 to-primary/5",
      accent: "bg-primary",
      description: "Periodo actual"
    },
    { 
      title: "Pendientes", 
      value: data.stats?.pendingReadingsPeriod.toLocaleString() || "0", 
      icon: Clock, 
      color: "from-orange-500/20 to-orange-600/5",
      accent: "bg-orange-500",
      description: "Sin registro"
    },
  ];

  return (
    <div className="p-8 space-y-10 animate-in fade-in zoom-in-95 duration-1000 relative">
      <div 
        className="fixed inset-0 pointer-events-none z-50 transition-opacity duration-500"
        style={{
          background: `radial-gradient(800px circle at ${mousePos.x}px ${mousePos.y}px, rgba(255,0,255,0.04), transparent 80%)`
        }}
      />
      <div 
        className="fixed inset-0 pointer-events-none z-50 transition-opacity duration-300"
        style={{
          background: `radial-gradient(400px circle at ${mousePos.x}px ${mousePos.y}px, rgba(255,191,0,0.05), transparent 70%)`
        }}
      />
      <div 
        className="fixed inset-0 pointer-events-none z-50 transition-opacity duration-200"
        style={{
          background: `radial-gradient(200px circle at ${mousePos.x}px ${mousePos.y}px, rgba(0,255,255,0.02), transparent 60%)`
        }}
      />

      <div className="fixed inset-0 pointer-events-none overflow-hidden -z-10">
        <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary/10 blur-[120px] rounded-full" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[30%] h-[30%] bg-cyan-500/10 blur-[100px] rounded-full" />
      </div>

      <div className="flex flex-col gap-2 md:flex-row md:items-end md:justify-between border-b border-white/5 pb-8">
        <div className="space-y-1">
          <div className="flex items-center gap-2 mb-2">
            <span className="px-2 py-0.5 rounded-full bg-primary/10 border border-primary/20 text-[9px] font-black uppercase tracking-widest text-primary">
              Sistema v1.2.0
            </span>
            <span className="flex items-center gap-1.5 px-2 py-0.5 rounded-full bg-amber-500/10 border border-amber-500/20 text-[9px] font-black uppercase tracking-widest text-amber-500 shadow-[0_0_10px_rgba(245,158,11,0.1)]">
              <div className="w-1 h-1 rounded-full bg-amber-500 animate-pulse shadow-[0_0_8px_rgba(245,158,11,0.5)]" />
              Live
            </span>
          </div>
          <h1 className="text-5xl font-black tracking-tighter leading-none">
            Panel <span className="text-primary italic">QARWAQIRU</span>
          </h1>
          <p className="text-muted-foreground/60 font-bold uppercase text-xs tracking-widest">
            Telemetría y Gestión Energética • Chetilla
          </p>
        </div>
        
        <div className="flex items-center gap-4 mt-6 md:mt-0">
          <button className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-all group">
            <Clock className="w-4 h-4 text-muted-foreground group-hover:text-primary" />
            <span className="text-xs font-black uppercase tracking-widest">Periodo: 2026-05</span>
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {cards.map((card, idx) => (
          <Card key={card.title} className="relative overflow-hidden border-white/5 bg-card/20 backdrop-blur-xl group hover:border-primary/20 transition-all duration-500 hover:shadow-2xl hover:shadow-primary/5">
            <div className={`absolute top-0 left-0 w-1 h-full ${card.accent} opacity-40`} />
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <span className="text-[10px] font-black uppercase tracking-[0.2em] text-muted-foreground group-hover:text-primary transition-colors">
                {card.title}
              </span>
              <card.icon className="w-4 h-4 text-muted-foreground group-hover:text-primary transition-all group-hover:scale-110" />
            </CardHeader>
            <CardContent>
              {data.loading ? (
                <div className="h-9 w-24 bg-white/5 animate-pulse rounded-lg" />
              ) : (
                <div className="flex flex-col">
                  <span className="text-3xl font-black tracking-tighter text-white group-hover:scale-105 transition-transform origin-left duration-500">
                    {card.value}
                  </span>
                  <span className="text-[9px] font-bold text-muted-foreground/40 uppercase mt-1 tracking-widest">
                    {card.description}
                  </span>
                </div>
              )}
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-6">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-black uppercase tracking-[0.3em] text-muted-foreground flex items-center gap-2">
              <MapIcon className="w-4 h-4 text-primary" />
              Mapa de Operaciones
            </h3>
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-emerald-500" />
                <span className="text-[9px] font-bold text-muted-foreground uppercase">Online</span>
              </div>
            </div>
          </div>
          <CustomerMap />
        </div>

        <div className="space-y-6">
          <h3 className="text-xs font-black uppercase tracking-[0.3em] text-muted-foreground flex items-center gap-2">
            <Activity className="w-4 h-4 text-secondary" />
            Avance por Sectores
          </h3>
          <Card className="border-white/5 bg-card/20 backdrop-blur-xl h-full flex flex-col">
            <CardContent className="p-0 flex-1 overflow-auto max-h-[400px] scrollbar-hide">
              <div className="divide-y divide-white/5">
                {data.loading ? (
                  [1, 2, 3, 4].map((i) => (
                    <div key={i} className="p-5 space-y-3 animate-pulse">
                      <div className="h-3 w-24 bg-white/5 rounded" />
                      <div className="h-1.5 w-full bg-white/5 rounded" />
                    </div>
                  ))
                ) : data.stats?.sectorStats.length === 0 ? (
                  <div className="p-12 text-center text-muted-foreground text-[10px] font-bold uppercase tracking-widest italic">
                    Sin actividad registrada
                  </div>
                ) : (
                  data.stats?.sectorStats.map((s) => (
                    <div key={s.sectorId} className="p-5 hover:bg-white/[0.03] transition-colors group">
                      <div className="flex items-center justify-between mb-2.5">
                        <div className="space-y-0.5">
                          <h4 className="text-[11px] font-black uppercase tracking-tight group-hover:text-primary transition-colors truncate max-w-[150px]">
                            {s.sectorName}
                          </h4>
                          <p className="text-[9px] font-bold text-muted-foreground/40 uppercase">
                            {s.registeredCount} / {s.totalCount} Registros
                          </p>
                        </div>
                        <div className="text-right">
                          <span className="text-sm font-black tracking-tighter text-primary">
                            {s.progressPercentage}%
                          </span>
                        </div>
                      </div>
                      <div className="h-1 w-full bg-white/5 rounded-full overflow-hidden">
                        <div 
                          className="h-full bg-primary transition-all duration-1000 ease-out shadow-[0_0_8px_rgba(255,0,255,0.4)]"
                          style={{ width: `${s.progressPercentage}%` }}
                        />
                      </div>
                      <div className="mt-2 flex justify-between items-center text-[8px] font-black uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-opacity">
                        <span className="text-muted-foreground">Consumo Total</span>
                        <span className="text-cyan-500">{s.totalConsumption.toLocaleString()} kWh</span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </CardContent>
            <div className="p-4 bg-white/[0.01] border-t border-white/5 mt-auto shrink-0">
              <button className="w-full py-2 rounded-xl bg-white/5 border border-white/10 text-[9px] font-black uppercase tracking-[0.2em] hover:bg-white/10 transition-all">
                Ver Detalles por Sector
              </button>
            </div>
          </Card>
        </div>
      </div>
    </div>
  );
}
