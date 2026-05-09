"use client";

import { Calendar } from "lucide-react";
import { useConfigStore } from "@/lib/store/useConfigStore";
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip";

interface PeriodSelectorProps {
  variant?: "minimal" | "full";
  isCollapsed?: boolean;
}

export function PeriodSelector({
  variant = "full",
  isCollapsed = false,
}: PeriodSelectorProps) {
  const { selectedPeriod, setSelectedPeriod, periods } = useConfigStore();

  if (isCollapsed) {
    const [year, month] = selectedPeriod.split("-");
    const shortYear = year.slice(2);

    return (
      <div className="w-full flex justify-center mb-6">
        <Tooltip>
          <TooltipTrigger>
            <div className="flex flex-col items-center justify-center gap-0.5 group cursor-pointer w-14 h-14 rounded-2xl hover:bg-white/5 transition-all">
              <Calendar className="w-5 h-5 text-primary group-hover:scale-110 transition-transform duration-300" />
              <div className="flex flex-col items-center -space-y-0.5">
                <span className="text-[9px] font-black text-white leading-none">
                  {month}
                </span>
                <span className="text-[8px] font-bold text-muted-foreground/40 leading-none">
                  {shortYear}
                </span>
              </div>
            </div>
          </TooltipTrigger>
          <TooltipContent
            side="right"
            sideOffset={15}
            className="bg-zinc-900 border-white/10 p-4 rounded-2xl shadow-2xl z-[999] min-w-[160px] animate-in fade-in slide-in-from-left-2 duration-300 isolate"
          >
            <div className="space-y-3">
              <p className="text-[10px] font-black uppercase tracking-widest text-primary border-b border-primary/10 pb-2">
                Seleccionar Periodo
              </p>
              <div className="grid grid-cols-1 gap-1 max-h-[200px] overflow-y-auto scrollbar-hide">
                {periods.map((p) => (
                  <button
                    key={p.id}
                    onClick={() => setSelectedPeriod(p.id)}
                    className={`px-3 py-2 rounded-xl text-[10px] font-black transition-all text-left uppercase tracking-tighter flex items-center justify-between ${
                      selectedPeriod === p.id
                        ? "bg-primary text-black"
                        : "hover:bg-white/10 text-muted-foreground"
                    }`}
                  >
                    {p.id}
                    {p.status === "OPEN" && (
                      <span
                        className={`w-1 h-1 rounded-full ${selectedPeriod === p.id ? "bg-black" : "bg-primary"}`}
                      />
                    )}
                  </button>
                ))}
              </div>
            </div>
          </TooltipContent>
        </Tooltip>
      </div>
    );
  }

  if (variant === "minimal") {
    return (
      <div className="relative group">
        <select
          value={selectedPeriod}
          onChange={(e) => setSelectedPeriod(e.target.value)}
          className="bg-white/5 border border-white/10 rounded-lg py-1.5 pl-8 pr-3 text-[10px] font-black uppercase tracking-widest outline-none appearance-none cursor-pointer hover:bg-white/10 transition-all"
        >
          {periods.map((p) => (
            <option key={p.id} value={p.id} className="bg-zinc-900 text-white">
              {p.id}
            </option>
          ))}
        </select>
        <Calendar className="w-3 h-3 text-primary absolute left-2.5 top-1/2 -translate-y-1/2 pointer-events-none" />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-2">
      <div className="flex items-center gap-2">
        <Calendar className="w-3 h-3 text-primary" />
        <span className="text-[9px] font-black uppercase tracking-widest text-muted-foreground/60">
          Periodo Activo
        </span>
      </div>
      <div className="relative group">
        <select
          value={selectedPeriod}
          onChange={(e) => setSelectedPeriod(e.target.value)}
          className="w-full bg-transparent text-[11px] font-black uppercase tracking-widest outline-none cursor-pointer hover:text-primary transition-colors appearance-none"
        >
          {periods.map((p) => (
            <option key={p.id} value={p.id} className="bg-zinc-900 text-white">
              {p.id} {p.status === "OPEN" ? "(ABIERTO)" : ""}
            </option>
          ))}
        </select>
      </div>
    </div>
  );
}
