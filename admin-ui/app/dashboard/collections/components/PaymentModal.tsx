import { Loader2, X } from "lucide-react";
import { useState } from "react";

interface PaymentModalProps {
  isOpen: boolean;
  onClose: () => void;
  customerName: string;
  periodName: string;
  onSubmit: (amount: number, observation: string) => void;
  loading: boolean;
}

export function PaymentModal({
  isOpen,
  onClose,
  customerName,
  periodName,
  onSubmit,
  loading,
}: PaymentModalProps) {
  const [amount, setAmount] = useState<string>("0.00");
  const [observation, setObservation] = useState<string>("");

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const parsedAmount = parseFloat(amount);
    if (Number.isNaN(parsedAmount) || parsedAmount < 0) return;
    onSubmit(parsedAmount, observation);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="w-full max-w-md bg-zinc-900 border border-zinc-800 rounded-2xl overflow-hidden shadow-2xl flex flex-col animate-in fade-in zoom-in-95 duration-200">
        {/* Header */}
        <div className="p-4 border-b border-zinc-800 flex items-center justify-between">
          <div>
            <h3 className="text-sm font-semibold text-white">Registrar Pago Manual</h3>
            <p className="text-[11px] text-zinc-400 mt-0.5">
              Para {customerName} · Período {periodName}
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="p-1 rounded-lg text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800 transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Body */}
        <form onSubmit={handleSubmit} className="p-4 space-y-4">
          <div className="space-y-1.5">
            <label
              htmlFor="amount"
              className="text-[11px] font-semibold text-zinc-400 uppercase tracking-wider block"
            >
              Monto a Pagar (S/)
            </label>
            <input
              id="amount"
              type="number"
              step="0.01"
              min="0"
              required
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-sm text-white focus:outline-none focus:border-emerald-500/50 transition-colors"
              placeholder="0.00"
            />
          </div>

          <div className="space-y-1.5">
            <label
              htmlFor="observation"
              className="text-[11px] font-semibold text-zinc-400 uppercase tracking-wider block"
            >
              Observación / Detalle (Opcional)
            </label>
            <textarea
              id="observation"
              value={observation}
              onChange={(e) => setObservation(e.target.value)}
              className="w-full bg-zinc-950 border border-zinc-800 rounded-xl px-3 py-2 text-sm text-white focus:outline-none focus:border-emerald-500/50 transition-colors resize-none h-20"
              placeholder="Ej. Pago base sin lectura del mes"
            />
          </div>

          {/* Footer */}
          <div className="flex justify-end gap-2 pt-2">
            <button
              type="button"
              onClick={onClose}
              disabled={loading}
              className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-zinc-800 text-zinc-300 hover:bg-zinc-700 hover:text-white transition-colors"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-3 py-1.5 rounded-xl text-xs font-semibold bg-emerald-500 hover:bg-emerald-400 text-black flex items-center gap-1.5 disabled:opacity-60 transition-colors"
            >
              {loading && <Loader2 className="w-3 h-3 animate-spin" />}
              Registrar Pago
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
