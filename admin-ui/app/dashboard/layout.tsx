"use client";

import {
  LayoutDashboard,
  LogOut,
  Settings,
  Users,
  Zap,
  Calendar,
} from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useAuth } from "@/lib/hooks/useAuth";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const { isAdmin } = useAuth();

  const menuItems = [
    { href: "/dashboard", label: "Dashboard", icon: LayoutDashboard },
    { href: "/dashboard/customers", label: "Clientes", icon: Users },
    { href: "/dashboard/readings", label: "Lecturas", icon: Zap },
    ...(isAdmin
      ? [
          { href: "/dashboard/users", label: "Usuarios", icon: Users },
          { href: "/dashboard/periods", label: "Periodos", icon: Calendar },
          {
            href: "/dashboard/settings",
            label: "Configuración",
            icon: Settings,
          },
        ]
      : []),
  ];

  const handleLogout = () => {
    document.cookie =
      "admin_token=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT;";
    localStorage.removeItem("admin_user");
    router.push("/login");
  };

  return (
    <div className="flex min-h-screen bg-background">
      {/* Sidebar */}
      <aside className="w-72 border-r border-white/5 bg-card/20 backdrop-blur-xl flex flex-col sticky top-0 h-screen">
        <div className="p-8 flex items-center gap-3">
          <Image
            src="/assets/logo.png"
            alt="Logo"
            width={40}
            height={40}
            className="rounded-lg"
          />
          <div className="flex flex-col">
            <span className="font-black tracking-tighter text-sm uppercase">
              QARWAQIRU
            </span>
            <span className="text-[10px] text-muted-foreground uppercase tracking-widest font-bold">
              Admin Panel
            </span>
          </div>
        </div>

        <nav className="flex-1 px-4 space-y-2 py-4">
          {menuItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-300 group ${
                  isActive
                    ? "bg-primary/10 text-primary shadow-lg shadow-primary/5"
                    : "text-muted-foreground hover:bg-white/5 hover:text-foreground"
                }`}
              >
                <item.icon
                  className={`w-5 h-5 transition-transform duration-500 ${
                    isActive ? "scale-110" : "group-hover:scale-110"
                  }`}
                />
                <span className="font-bold tracking-tight text-sm uppercase">
                  {item.label}
                </span>
                {isActive && (
                  <div className="ml-auto w-1.5 h-1.5 rounded-full bg-primary shadow-[0_0_8px_rgba(255,230,0,0.8)]" />
                )}
              </Link>
            );
          })}
        </nav>

        <div className="p-4 border-t border-white/5">
          <button
            type="button"
            onClick={handleLogout}
            className="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-destructive/60 hover:text-destructive hover:bg-destructive/10 transition-all duration-300 font-bold text-sm uppercase group"
          >
            <LogOut className="w-5 h-5 transition-transform group-hover:-translate-x-1" />
            Cerrar Sesión
          </button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        <div className="relative">
          {/* Subtle background glow */}
          <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-primary/5 rounded-full blur-[120px] pointer-events-none" />
          <div className="relative z-10">{children}</div>
        </div>
      </main>
    </div>
  );
}
