import { create } from "@bufbuild/protobuf";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { toast } from "sonner";
import {
  GetCollectionsRequestSchema,
  GetCommunitiesRequestSchema,
  GetSectorsRequestSchema,
  TogglePaymentStatusRequestSchema,
} from "@/app/gen/involt/v1/admin_pb";
import { adminClient } from "@/lib/rpc";
import { API_BASE_URL, getAdminToken } from "@/lib/utils";
import type { CollectionReading, CustomerRow, SectorTab } from "../types";

// ── Helpers ────────────────────────────────────────────────────────────────

export function getLastNPeriods(n: number): string[] {
  const periods: string[] = [];
  const now = new Date();
  for (let i = 0; i < n; i++) {
    const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
    periods.push(`${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}`);
  }
  return periods;
}

export function formatPeriod(period: string): string {
  const [year, month] = period.split("-");
  const months = [
    "Ene",
    "Feb",
    "Mar",
    "Abr",
    "May",
    "Jun",
    "Jul",
    "Ago",
    "Sep",
    "Oct",
    "Nov",
    "Dic",
  ];
  return `${months[parseInt(month, 10) - 1]} ${year}`;
}

// ── Hook ───────────────────────────────────────────────────────────────────

export function useCollections() {
  const [sectors, setSectors] = useState<SectorTab[]>([]);
  const [selectedSectorId, setSelectedSectorId] = useState<string>("");

  const [selectedYear, setSelectedYear] = useState<number>(() => {
    if (typeof window !== "undefined") {
      const saved = localStorage.getItem("involt_collections_year");
      if (saved) return parseInt(saved, 10);
    }
    return new Date().getFullYear();
  });

  const [selectedHalf, setSelectedHalf] = useState<"H1" | "H2">(() => {
    if (typeof window !== "undefined") {
      const saved = localStorage.getItem("involt_collections_half");
      if (saved === "H1" || saved === "H2") return saved;
    }
    return new Date().getMonth() + 1 <= 6 ? "H1" : "H2";
  });

  // Memoize periods based on selectedYear and selectedHalf (H1: Jun to Jan, H2: Dec to Jul)
  const periods = useMemo<string[]>(() => {
    const months = selectedHalf === "H1" ? [1, 2, 3, 4, 5, 6] : [7, 8, 9, 10, 11, 12];
    return months.map((m) => `${selectedYear}-${String(m).padStart(2, "0")}`);
  }, [selectedYear, selectedHalf]);

  const [customerRows, setCustomerRows] = useState<CustomerRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [togglingId, setTogglingId] = useState<string | null>(null);
  const [expandedCommunities, setExpandedCommunities] = useState<Set<string>>(new Set());
  const [modalOpen, setModalOpen] = useState(false);
  const [activeReading, setActiveReading] = useState<CollectionReading | null>(null);
  const [modalLoading, setModalLoading] = useState(false);
  const hasFetched = useRef(false);

  // Sync state to localStorage
  useEffect(() => {
    if (typeof window !== "undefined") {
      localStorage.setItem("involt_collections_year", String(selectedYear));
    }
  }, [selectedYear]);

  useEffect(() => {
    if (typeof window !== "undefined") {
      localStorage.setItem("involt_collections_half", selectedHalf);
    }
  }, [selectedHalf]);

  // Load customer-first collection rows for a sector. The selected caserío maps to sector_id.
  const loadCollections = useCallback(
    async (sectorId: string) => {
      if (!sectorId) return;
      setLoading(true);
      try {
        const resp = await adminClient.getCollections(
          create(GetCollectionsRequestSchema, { sectorId, periods }),
        );

        const rowMap: Record<string, CustomerRow> = {};
        for (const collectionCustomer of resp.customers) {
          const customer = collectionCustomer.customer;
          if (!customer) {
            continue;
          }

          rowMap[customer.id] = {
            customerId: customer.id,
            customerName: customer.name,
            readings: Object.fromEntries(
              periods.map((period) => [
                period,
                {
                  id: "",
                  customerId: customer.id,
                  customerName: customer.name,
                  period: period,
                  totalToPay: 0,
                  isPaid: false,
                },
              ]),
            ),
          };

          for (const r of collectionCustomer.readings) {
            rowMap[customer.id].readings[r.period] = {
              id: r.id,
              customerId: r.customerId,
              customerName: r.customerName || customer.name,
              period: r.period,
              totalToPay: r.totalToPay,
              isPaid: r.isPaid,
            };
          }
        }

        setCustomerRows(
          Object.values(rowMap).sort((a, b) => a.customerName.localeCompare(b.customerName)),
        );
      } catch {
        toast.error("Error al cargar datos de cobranza");
      } finally {
        setLoading(false);
      }
    },
    [periods],
  );

  const selectSector = useCallback(
    (sectorId: string) => {
      setSelectedSectorId(sectorId);
      void loadCollections(sectorId);
    },
    [loadCollections],
  );

  // Load communities & sectors once from the external RPC system.
  useEffect(() => {
    if (hasFetched.current) return;
    hasFetched.current = true;

    async function loadSectors() {
      try {
        const [communitiesResp, sectorsResp] = await Promise.all([
          adminClient.getCommunities(create(GetCommunitiesRequestSchema, {})),
          adminClient.getSectors(create(GetSectorsRequestSchema, {})),
        ]);
        const communityNames = new Map(
          communitiesResp.communities.map((community) => [community.id, community.name]),
        );
        const tabs: SectorTab[] = sectorsResp.sectors.map((sector) => ({
          id: sector.id,
          name: sector.name,
          communityId: sector.communityId,
          communityName: communityNames.get(sector.communityId) ?? "Sin comunidad",
        }));
        setSectors(tabs);
        if (tabs.length > 0) {
          setSelectedSectorId(tabs[0].id);
          setExpandedCommunities(new Set([tabs[0].communityId]));
        }
      } catch {
        toast.error("Error al cargar los caseríos");
      }
    }
    void loadSectors();
  }, []);

  // Reactively reload collections whenever selected sector or periods change
  useEffect(() => {
    if (selectedSectorId) {
      void loadCollections(selectedSectorId);
    }
  }, [selectedSectorId, loadCollections]);

  // Toggle payment status with optimistic update + revert on error
  const handleToggle = useCallback(async (reading: CollectionReading) => {
    if (reading.id === "" && !reading.isPaid) {
      setActiveReading(reading);
      setModalOpen(true);
      return;
    }

    const activeTogglingId = reading.id || `${reading.customerId}-${reading.period}`;
    setTogglingId(activeTogglingId);
    const newStatus = !reading.isPaid;

    const applyStatus = (isPaid: boolean, returnedId?: string) =>
      setCustomerRows((prev) =>
        prev.map((row) =>
          row.customerId !== reading.customerId
            ? row
            : {
                ...row,
                readings: {
                  ...row.readings,
                  [reading.period]: {
                    ...reading,
                    isPaid,
                    id: returnedId !== undefined ? returnedId : reading.id,
                  },
                },
              },
        ),
      );

    applyStatus(newStatus); // optimistic
    try {
      const resp = await adminClient.togglePaymentStatus(
        create(TogglePaymentStatusRequestSchema, {
          readingId: reading.id,
          isPaid: newStatus,
          customerId: reading.customerId,
          period: reading.period,
        }),
      );
      toast.success(newStatus ? "Marcado como PAGADO ✓" : "Marcado como PENDIENTE");
      if (resp.readingId) {
        applyStatus(newStatus, resp.readingId);
      }
    } catch {
      applyStatus(reading.isPaid); // revert
      toast.error("Error al actualizar el estado de pago");
    } finally {
      setTogglingId(null);
    }
  }, []);

  const submitPayment = useCallback(
    async (amount: number, observation: string) => {
      if (!activeReading) return;
      setModalLoading(true);
      const reading = activeReading;
      const activeTogglingId = `${reading.customerId}-${reading.period}`;
      setTogglingId(activeTogglingId);
      const newStatus = true;

      const applyStatus = (isPaid: boolean, returnedId?: string) =>
        setCustomerRows((prev) =>
          prev.map((row) =>
            row.customerId !== reading.customerId
              ? row
              : {
                  ...row,
                  readings: {
                    ...row.readings,
                    [reading.period]: {
                      ...reading,
                      isPaid,
                      totalToPay: amount,
                      id: returnedId !== undefined ? returnedId : reading.id,
                    },
                  },
                },
          ),
        );

      applyStatus(newStatus);
      try {
        const resp = await adminClient.togglePaymentStatus(
          create(TogglePaymentStatusRequestSchema, {
            readingId: reading.id,
            isPaid: newStatus,
            customerId: reading.customerId,
            period: reading.period,
            totalToPay: amount,
            observation: observation,
          }),
        );
        toast.success("Pago registrado como PAGADO ✓");
        setModalOpen(false);
        if (resp.readingId) {
          applyStatus(newStatus, resp.readingId);
        }
      } catch {
        applyStatus(reading.isPaid);
        toast.error("Error al registrar el pago");
      } finally {
        setTogglingId(null);
        setModalLoading(false);
        setActiveReading(null);
      }
    },
    [activeReading],
  );

  const openPDF = useCallback(async (reading: CollectionReading) => {
    let readingId = reading.id;
    if (!readingId) {
      const activeTogglingId = `${reading.customerId}-${reading.period}`;
      setTogglingId(activeTogglingId);
      try {
        const resp = await adminClient.togglePaymentStatus(
          create(TogglePaymentStatusRequestSchema, {
            readingId: "",
            isPaid: false,
            customerId: reading.customerId,
            period: reading.period,
          }),
        );
        if (resp.readingId) {
          readingId = resp.readingId;
          setCustomerRows((prev) =>
            prev.map((row) =>
              row.customerId !== reading.customerId
                ? row
                : {
                    ...row,
                    readings: {
                      ...row.readings,
                      [reading.period]: {
                        ...reading,
                        id: resp.readingId,
                      },
                    },
                  },
            ),
          );
        }
      } catch {
        toast.error("Error al generar el recibo PDF");
        return;
      } finally {
        setTogglingId(null);
      }
    }

    if (readingId) {
      const token = getAdminToken();
      window.open(`${API_BASE_URL}/admin/readings/pdf/${readingId}?token=${token}`, "_blank");
    }
  }, []);

  const toggleCommunity = useCallback((commId: string) => {
    setExpandedCommunities((prev) => {
      const next = new Set(prev);
      if (next.has(commId)) {
        next.delete(commId);
      } else {
        next.add(commId);
      }
      return next;
    });
  }, []);

  // Group sectors by community for sidebar rendering
  const communitiesWithSectors = sectors.reduce<
    Record<string, { name: string; sectors: SectorTab[] }>
  >((acc, s) => {
    if (!acc[s.communityId]) acc[s.communityId] = { name: s.communityName, sectors: [] };
    acc[s.communityId].sectors.push(s);
    return acc;
  }, {});

  const selectedSector = sectors.find((s) => s.id === selectedSectorId);

  return {
    periods,
    sectors,
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
  };
}
