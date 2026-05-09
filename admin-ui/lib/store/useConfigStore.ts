import { create } from "zustand";
import { persist } from "zustand/middleware";

export interface Period {
  id: string;
  status: string;
}

interface ConfigState {
  selectedPeriod: string;
  periods: Period[];
  setPeriods: (periods: Period[]) => void;
  setSelectedPeriod: (period: string) => void;
}

export const useConfigStore = create<ConfigState>()(
  persist(
    (set) => ({
      selectedPeriod: "",
      periods: [],
      setPeriods: (periods) => set({ periods }),
      setSelectedPeriod: (selectedPeriod) => set({ selectedPeriod }),
    }),
    {
      name: "involt-config-storage",
      partialize: (state) => ({ selectedPeriod: state.selectedPeriod }),
    }
  )
);
