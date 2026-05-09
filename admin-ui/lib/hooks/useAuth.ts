import { useState, useTransition } from "react";
import { UserRole } from "@/app/gen/involt/v1/admin_pb";

export interface User {
  id: string;
  email: string;
  role: UserRole;
}

export function useAuth() {
  const [isPending] = useTransition();
  const [user] = useState<User | null>(() => {
    if (typeof window === "undefined") return null;
    const storedUser = localStorage.getItem("admin_user");
    if (storedUser) {
      try {
        return JSON.parse(storedUser);
      } catch (e) {
        console.error("Failed to parse stored user", e);
      }
    }
    return null;
  });

  const [loading] = useState(() => {
    if (typeof window === "undefined") return true;
    return false;
  });

  // No more useEffect needed for initial sync

  const isAdmin = user?.role === UserRole.ADMIN;
  const isSupervisor = user?.role === UserRole.SUPERVISOR;
  const isReader = user?.role === UserRole.READER;

  return { user, loading, isAdmin, isSupervisor, isReader, isPending };
}
