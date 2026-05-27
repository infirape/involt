import {
  CheckCircle2,
  ChevronLeft,
  ChevronRight,
  DollarSign,
  FileText,
  Loader2,
  XCircle,
} from "lucide-react";
import type { ReactNode } from "react";
import { formatPeriod } from "../hooks/useCollections";
import type { CollectionReading, CustomerRow, SectorTab } from "../types";

interface CollectionsMatrixProps {
  selectedSectorId: string;
  selectedSector?: SectorTab;
  customerRows: CustomerRow[];
  periods: string[];
  loading: boolean;
  togglingId: string | null;
  onToggle: (reading: CollectionReading) => void;
  onOpenPDF: (reading: CollectionReading) => void;
  selectedYear: number;
  setSelectedYear: React.Dispatch<React.SetStateAction<number>>;
  selectedHalf: "H1" | "H2";
  setSelectedHalf: React.Dispatch<React.SetStateAction<"H1" | "H2">>;
}

export function CollectionsMatrix({
  selectedSectorId,
  selectedSector,
  customerRows,
  periods,
  loading,
  togglingId,
  onToggle,
  onOpenPDF,
  selectedYear,
  setSelectedYear,
  selectedHalf,
  setSelectedHalf,
}: CollectionsMatrixProps) {
  const currentYear = new Date().getFullYear();
  const years = Array.from({ length: 5 }, (_, i) => currentYear - 2 + i);

  return (
    <div className="flex-1 min-w-0 bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-hidden flex flex-col">
      <div className="p-4 border-b border-zinc-800 flex items-center justify-between">
        <div>
          <h2 className="text-sm font-semibold text-white">
            {selectedSector ? selectedSector.name : "Seleccioná un caserío"}
          </h2>
          <p className="text-xs text-zinc-500 mt-0.5">
            {customerRows.length} suministros · {selectedHalf === "H1" ? "Ene - Jun" : "Jul - Dic"}{" "}
            {selectedYear}
          </p>
        </div>

        <div className="flex items-center gap-3">
          {loading && <Loader2 className="w-4 h-4 text-zinc-500 animate-spin" />}

          <div className="flex items-center gap-2">
            {/* Year Dropdown */}
            <select
              value={selectedYear}
              onChange={(e) => setSelectedYear(parseInt(e.target.value, 10))}
              className="bg-zinc-950 border border-zinc-800 text-zinc-300 text-xs rounded-xl px-2.5 py-1.5 focus:outline-none focus:border-emerald-500/50 transition-colors"
            >
              {years.map((y) => (
                <option key={y} value={y}>
                  {y}
                </option>
              ))}
            </select>

            {/* Semester Navigation */}
            <div className="flex items-center bg-zinc-950 border border-zinc-800 rounded-xl p-0.5">
              <button
                type="button"
                onClick={() => {
                  if (selectedHalf === "H2") {
                    setSelectedHalf("H1");
                  } else {
                    setSelectedYear((prev) => prev - 1);
                    setSelectedHalf("H2");
                  }
                }}
                className="p-1 text-zinc-400 hover:text-white rounded-lg hover:bg-zinc-800 transition-all cursor-pointer"
                title="Semestre anterior"
              >
                <ChevronLeft className="w-3.5 h-3.5" />
              </button>
              <span className="text-[10px] font-black text-zinc-400 px-2 uppercase select-none min-w-[24px] text-center">
                {selectedHalf}
              </span>
              <button
                type="button"
                onClick={() => {
                  if (selectedHalf === "H1") {
                    setSelectedHalf("H2");
                  } else {
                    setSelectedYear((prev) => prev + 1);
                    setSelectedHalf("H1");
                  }
                }}
                className="p-1 text-zinc-400 hover:text-white rounded-lg hover:bg-zinc-800 transition-all cursor-pointer"
                title="Semestre siguiente"
              >
                <ChevronRight className="w-3.5 h-3.5" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-auto">
        <MatrixBody
          selectedSectorId={selectedSectorId}
          loading={loading}
          customerRows={customerRows}
          periods={periods}
          togglingId={togglingId}
          onToggle={onToggle}
          onOpenPDF={onOpenPDF}
        />
      </div>

      {customerRows.length > 0 && !loading && <CollectionsLegend />}
    </div>
  );
}

interface MatrixBodyProps {
  selectedSectorId: string;
  loading: boolean;
  customerRows: CustomerRow[];
  periods: string[];
  togglingId: string | null;
  onToggle: (reading: CollectionReading) => void;
  onOpenPDF: (reading: CollectionReading) => void;
}

function MatrixBody({
  selectedSectorId,
  loading,
  customerRows,
  periods,
  togglingId,
  onToggle,
  onOpenPDF,
}: MatrixBodyProps) {
  if (!selectedSectorId) {
    return (
      <EmptyState
        icon={<DollarSign className="w-12 h-12 opacity-30" />}
        message="Seleccioná un caserío para ver los pagos"
      />
    );
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-full">
        <Loader2 className="w-8 h-8 text-zinc-600 animate-spin" />
      </div>
    );
  }

  if (customerRows.length === 0) {
    return (
      <EmptyState
        icon={<XCircle className="w-10 h-10 opacity-30" />}
        message="Sin suministros registrados para este caserío"
      />
    );
  }

  return (
    <table className="w-full text-xs border-collapse">
      <thead className="sticky top-0 z-10">
        <tr className="bg-zinc-900 border-b border-zinc-800">
          <th className="text-left px-4 py-3 text-zinc-400 font-semibold w-52 min-w-[200px]">
            Suministro
          </th>
          {periods.map((period) => (
            <th
              key={period}
              className="text-center px-3 py-3 text-zinc-400 font-semibold min-w-[90px]"
            >
              {formatPeriod(period)}
            </th>
          ))}
        </tr>
      </thead>
      <tbody>
        {customerRows.map((row, idx) => (
          <CollectionRow
            key={row.customerId}
            row={row}
            periods={periods}
            rowIndex={idx}
            togglingId={togglingId}
            onToggle={onToggle}
            onOpenPDF={onOpenPDF}
          />
        ))}
      </tbody>
    </table>
  );
}

interface CollectionRowProps {
  row: CustomerRow;
  periods: string[];
  rowIndex: number;
  togglingId: string | null;
  onToggle: (reading: CollectionReading) => void;
  onOpenPDF: (reading: CollectionReading) => void;
}

function CollectionRow({
  row,
  periods,
  rowIndex,
  togglingId,
  onToggle,
  onOpenPDF,
}: CollectionRowProps) {
  return (
    <tr
      className={`border-b border-zinc-800/50 transition-colors hover:bg-zinc-800/20 ${
        rowIndex % 2 === 0 ? "" : "bg-zinc-900/30"
      }`}
    >
      <td className="px-4 py-2.5 text-zinc-300 font-medium truncate max-w-[200px]">
        {row.customerName}
      </td>
      {periods.map((period) => (
        <PaymentCell
          key={period}
          reading={row.readings[period]}
          isToggling={
            row.readings[period]
              ? togglingId === row.readings[period]?.id ||
                togglingId === `${row.customerId}-${period}`
              : false
          }
          onToggle={onToggle}
          onOpenPDF={onOpenPDF}
        />
      ))}
    </tr>
  );
}

interface PaymentCellProps {
  reading: CollectionReading | null;
  isToggling: boolean;
  onToggle: (reading: CollectionReading) => void;
  onOpenPDF: (reading: CollectionReading) => void;
}

function PaymentCell({ reading, isToggling, onToggle, onOpenPDF }: PaymentCellProps) {
  if (!reading) {
    return (
      <td className="px-2 py-2 text-center">
        <span className="text-zinc-700 text-[10px]">—</span>
      </td>
    );
  }

  return (
    <td className="px-2 py-2 text-center">
      <div className="relative group inline-flex flex-col items-center gap-1">
        <button
          type="button"
          onClick={() => !isToggling && onToggle(reading)}
          disabled={isToggling}
          title={
            reading.isPaid ? "Clic para marcar como pendiente" : "Clic para marcar como pagado"
          }
          className={`
            relative flex items-center gap-1 px-2.5 py-1 rounded-lg font-semibold text-[10px]
            transition-all duration-200 cursor-pointer select-none
            ${isToggling ? "opacity-60 cursor-wait" : "hover:scale-105 active:scale-95"}
            ${
              reading.isPaid
                ? "bg-emerald-500/15 text-emerald-400 border border-emerald-500/25 hover:bg-emerald-500/25"
                : "bg-red-500/10 text-red-400 border border-red-500/20 hover:bg-red-500/20"
            }
          `}
        >
          {isToggling ? (
            <Loader2 className="w-3 h-3 animate-spin" />
          ) : reading.isPaid ? (
            <CheckCircle2 className="w-3 h-3" />
          ) : (
            <XCircle className="w-3 h-3" />
          )}
          {reading.isPaid ? "PAGADO" : "PENDIENTE"}
        </button>

        <button
          type="button"
          onClick={() => onOpenPDF(reading)}
          title="Ver recibo PDF"
          className="absolute -top-1 -right-1 w-5 h-5 flex items-center justify-center rounded-full bg-zinc-700 hover:bg-fuchsia-600 border border-zinc-600 hover:border-fuchsia-500 text-zinc-400 hover:text-white opacity-0 group-hover:opacity-100 transition-all duration-150 scale-75 group-hover:scale-100 shadow-lg"
        >
          <FileText className="w-2.5 h-2.5" />
        </button>

        {reading.id !== "" ? (
          <span className="text-[9px] text-zinc-600">S/ {reading.totalToPay.toFixed(2)}</span>
        ) : (
          <span className="text-[9px] text-zinc-600/50">S/ --</span>
        )}
      </div>
    </td>
  );
}

function EmptyState({ icon, message }: { icon: ReactNode; message: string }) {
  return (
    <div className="flex flex-col items-center justify-center h-full gap-3 text-zinc-600">
      {icon}
      <p className="text-sm">{message}</p>
    </div>
  );
}

function CollectionsLegend() {
  return (
    <div className="p-3 border-t border-zinc-800 flex items-center gap-4 text-[10px] text-zinc-500">
      <div className="flex items-center gap-1.5">
        <div className="w-3 h-3 rounded bg-emerald-500/20 border border-emerald-500/30" />
        <span>PAGADO</span>
      </div>
      <div className="flex items-center gap-1.5">
        <div className="w-3 h-3 rounded bg-red-500/10 border border-red-500/20" />
        <span>PENDIENTE</span>
      </div>
      <div className="flex items-center gap-1.5">
        <span className="text-zinc-700 font-bold">—</span>
        <span>Sin lectura registrada</span>
      </div>
      <div className="flex items-center gap-1.5 ml-auto">
        <FileText className="w-3 h-3 text-fuchsia-500" />
        <span>Pasá el cursor por una celda para ver el PDF</span>
      </div>
    </div>
  );
}
