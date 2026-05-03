"use client";

import { Zap, DollarSign, CheckCircle2 } from "lucide-react";
import { Card } from "@/components/ui/card";

interface ReadingsStatsProps {
  totalConsumptionKwh: number;
  totalRevenue: number;
  syncPercentage: number;
}

export function ReadingsStats({
  totalConsumptionKwh,
  totalRevenue,
  syncPercentage,
}: ReadingsStatsProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
      <Card className="bg-primary/5 border-primary/10 rounded-2xl p-4 group hover:bg-primary/10 transition-all duration-500">
        <div className="flex items-center gap-2 mb-1 opacity-60">
          <Zap className="w-3.5 h-3.5 text-primary" />
          <p className="text-[9px] font-black uppercase tracking-widest text-primary">
            Consumo Total
          </p>
        </div>
        <p className="text-xl font-black tracking-tighter text-white">
          {totalConsumptionKwh.toLocaleString()} <span className="text-xs opacity-40">kWh</span>
        </p>
      </Card>
      <Card className="bg-cyan-500/5 border-cyan-500/10 rounded-2xl p-4 group hover:bg-cyan-500/10 transition-all duration-500">
        <div className="flex items-center gap-2 mb-1 opacity-60">
          <DollarSign className="w-3.5 h-3.5 text-cyan-500" />
          <p className="text-[9px] font-black uppercase tracking-widest text-cyan-500">
            Recaudación Periodo
          </p>
        </div>
        <p className="text-xl font-black tracking-tighter text-white">
          S/ {totalRevenue.toLocaleString(undefined, { minimumFractionDigits: 2 })}
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
          {syncPercentage.toFixed(1)}% <span className="text-xs opacity-40">OK</span>
        </p>
      </Card>
    </div>
  );
}
