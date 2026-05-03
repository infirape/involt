"use client";

import { Calendar, Filter, Receipt, Search } from "lucide-react";
import { useEffect, useState } from "react";
import type { Reading } from "@/app/gen/involt/v1/models_pb";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { adminClient } from "@/lib/rpc";

export default function ReadingsPage() {
  const [readings, setReadings] = useState<Reading[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => {
    async function fetchData() {
      try {
        const resp = await adminClient.getReadings({});
        setReadings(resp.readings);
      } catch (err) {
        console.error("Failed to fetch readings:", err);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, []);

  return (
    <div className="p-8 space-y-8">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="space-y-1">
          <h1 className="text-4xl font-black tracking-tighter uppercase bg-gradient-to-br from-white to-white/40 bg-clip-text text-transparent">
            Control de Lecturas
          </h1>
          <p className="text-muted-foreground font-medium">
            Monitoreo de consumos y facturación mensual
          </p>
        </div>
        <div className="flex gap-2">
          <Button
            variant="outline"
            className="h-11 font-black uppercase tracking-tighter rounded-xl border-white/5 bg-white/5"
          >
            <Filter className="w-4 h-4 mr-2" />
            Filtrar
          </Button>
          <Button
            variant="outline"
            className="h-11 font-black uppercase tracking-tighter rounded-xl border-white/5 bg-white/5"
          >
            <Calendar className="w-4 h-4 mr-2" />
            Periodo
          </Button>
        </div>
      </div>

      <Card className="border-white/5 bg-card/20 backdrop-blur-sm shadow-2xl">
        <CardHeader className="pb-4">
          <div className="relative flex-1 group">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
            <Input
              placeholder="Buscar por cliente o código..."
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
                  <th className="px-6 py-4">Fecha</th>
                  <th className="px-6 py-4">ID Cliente</th>
                  <th className="px-6 py-4">Consumo (kWh)</th>
                  <th className="px-6 py-4">Monto (S/)</th>
                  <th className="px-6 py-4 text-right">Recibo</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {loading ? (
                  [1, 2, 3, 4, 5].map((i) => (
                    <tr key={`skeleton-${i}`} className="animate-pulse">
                      <td colSpan={5} className="px-6 py-8">
                        <div className="h-4 bg-white/5 rounded w-full" />
                      </td>
                    </tr>
                  ))
                ) : readings.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="px-6 py-12 text-center text-muted-foreground italic">
                      No hay lecturas registradas para este periodo
                    </td>
                  </tr>
                ) : (
                  readings.map((r) => (
                    <tr key={r.id} className="group hover:bg-white/[0.02] transition-colors">
                      <td className="px-6 py-4">
                        <span className="text-xs font-bold text-muted-foreground uppercase">
                          {new Date(r.timestamp).toLocaleDateString()}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="font-mono text-xs font-bold">{r.customerId}</span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="font-black text-primary">{r.consumption.toFixed(2)}</span>
                      </td>
                      <td className="px-6 py-4">
                        <span className="font-bold tracking-tight">
                          S/ {r.totalToPay.toFixed(2)}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <Button
                          variant="ghost"
                          size="icon"
                          className="w-8 h-8 rounded-lg hover:bg-primary/10 hover:text-primary transition-colors"
                        >
                          <Receipt className="w-4 h-4" />
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
    </div>
  );
}
