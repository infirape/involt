import { ChevronDown, ChevronRight } from "lucide-react";
import type { SectorTab } from "../types";

interface Props {
  communitiesWithSectors: Record<string, { name: string; sectors: SectorTab[] }>;
  selectedSectorId: string;
  expandedCommunities: Set<string>;
  onSelectSector: (id: string) => void;
  onToggleCommunity: (id: string) => void;
}

export function SectorSidebar({
  communitiesWithSectors,
  selectedSectorId,
  expandedCommunities,
  onSelectSector,
  onToggleCommunity,
}: Props) {
  return (
    <aside className="w-56 shrink-0 bg-zinc-900/60 border border-zinc-800 rounded-2xl overflow-hidden flex flex-col">
      <div className="p-3 border-b border-zinc-800">
        <p className="text-xs font-semibold text-zinc-500 uppercase tracking-wider">
          Seleccionar Caserío
        </p>
      </div>

      <nav className="flex-1 overflow-y-auto p-2 space-y-1">
        {Object.entries(communitiesWithSectors).map(([commId, comm]) => (
          <div key={commId}>
            <button
              type="button"
              onClick={() => onToggleCommunity(commId)}
              className="w-full flex items-center gap-2 px-2 py-1.5 rounded-lg text-left text-xs font-semibold text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800/50 transition-colors"
            >
              {expandedCommunities.has(commId) ? (
                <ChevronDown className="w-3 h-3 shrink-0" />
              ) : (
                <ChevronRight className="w-3 h-3 shrink-0" />
              )}
              <span className="truncate">{comm.name}</span>
            </button>

            {expandedCommunities.has(commId) && (
              <div className="ml-3 mt-0.5 space-y-0.5">
                {comm.sectors.map((sector) => (
                  <button
                    type="button"
                    key={sector.id}
                    onClick={() => onSelectSector(sector.id)}
                    className={`w-full text-left px-3 py-1.5 rounded-lg text-xs transition-all duration-150 ${
                      selectedSectorId === sector.id
                        ? "bg-emerald-500/15 text-emerald-400 font-semibold border border-emerald-500/25"
                        : "text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800/50"
                    }`}
                  >
                    {sector.name}
                  </button>
                ))}
              </div>
            )}
          </div>
        ))}
      </nav>
    </aside>
  );
}
