import { useEffect, useState } from "react";
import { UserRole } from "@/app/gen/involt/v1/admin_pb";

export interface User {
  id: string;
  email: string;
  role: UserRole;
}

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const storedUser = localStorage.getItem("admin_user");
    if (storedUser) {
      try {
        setUser(JSON.parse(storedUser));
      } catch (e) {
        console.error("Failed to parse stored user", e);
      }
    }
    setLoading(false);
  }, []);

  const isAdmin = user?.role === UserRole.ADMIN;
  const isSupervisor = user?.role === UserRole.SUPERVISOR;
  const isReader = user?.role === UserRole.READER;

  return { user, loading, isAdmin, isSupervisor, isReader };
}
