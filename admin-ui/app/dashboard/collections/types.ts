// Shared types for the collections billing module.

export interface SectorTab {
  id: string;
  name: string;
  communityId: string;
  communityName: string;
}

export interface CollectionReading {
  id: string;
  customerId: string;
  customerName: string;
  period: string;
  totalToPay: number;
  isPaid: boolean;
}

export interface CustomerRow {
  customerId: string;
  customerName: string;
  readings: Record<string, CollectionReading | null>; // period -> reading
}
