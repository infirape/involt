"use client";

import { DollarSign } from "lucide-react";
import { CollectionsMatrix } from "./components/CollectionsMatrix";
import { PaymentModal } from "./components/PaymentModal";
import { SectorSidebar } from "./components/SectorSidebar";
import { formatPeriod, useCollections } from "./hooks/useCollections";

export default function CollectionsPage() {
  const {
    periods,
    selectedSectorId,
    selectSector,
    customerRows,
    loading,
    togglingId,
    expandedCommunities,
    communitiesWithSectors,
    selectedSector,
    handleToggle,
    openPDF,
    toggleCommunity,
    modalOpen,
    setModalOpen,
    activeReading,
    modalLoading,
    submitPayment,
    selectedYear,
    setSelectedYear,
    selectedHalf,
    setSelectedHalf,
  } = useCollections();

  return (
    <div className="h-full flex flex-col gap-6 p-6">
      <div className="flex items-center gap-3">
        <div className="p-2 rounded-xl bg-emerald-500/10 border border-emerald-500/20">
          <DollarSign className="w-6 h-6 text-emerald-400" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-white">Cobranzas</h1>
          <p className="text-sm text-zinc-400">Control manual de pagos por caserío</p>
        </div>
      </div>

      <div className="flex gap-4 flex-1 min-h-0">
        <SectorSidebar
          communitiesWithSectors={communitiesWithSectors}
          selectedSectorId={selectedSectorId}
          expandedCommunities={expandedCommunities}
          onSelectSector={selectSector}
          onToggleCommunity={toggleCommunity}
        />
        <CollectionsMatrix
          selectedSectorId={selectedSectorId}
          selectedSector={selectedSector}
          customerRows={customerRows}
          periods={periods}
          loading={loading}
          togglingId={togglingId}
          onToggle={handleToggle}
          onOpenPDF={openPDF}
          selectedYear={selectedYear}
          setSelectedYear={setSelectedYear}
          selectedHalf={selectedHalf}
          setSelectedHalf={setSelectedHalf}
        />
      </div>

      {activeReading && (
        <PaymentModal
          isOpen={modalOpen}
          onClose={() => setModalOpen(false)}
          customerName={activeReading.customerName}
          periodName={formatPeriod(activeReading.period)}
          onSubmit={submitPayment}
          loading={modalLoading}
        />
      )}
    </div>
  );
}
