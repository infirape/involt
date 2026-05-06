import { useState, useCallback, useEffect, useTransition } from "react";
import { adminClient } from "@/lib/rpc";
import type { Settings } from "@/app/gen/involt/v1/models_pb";
import { toast } from "sonner";

export function useSettings() {
  const [isPending, startTransition] = useTransition();
  const [settings, setSettings] = useState<Settings | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const fetchSettings = useCallback(async () => {
    try {
      const resp = await adminClient.getSettings({});
      startTransition(() => {
        setSettings(resp.settings ?? null);
      });
    } catch (err) {
      console.error("Failed to fetch settings:", err);
      toast.error("Error al cargar configuración");
    } finally {
      startTransition(() => {
        setLoading(false);
      });
    }
  }, []);

  useEffect(() => {
    let isMounted = true;
    const init = async () => {
      await fetchSettings();
      if (!isMounted) return;
    };
    init();
    return () => { isMounted = false; };
  }, [fetchSettings]);

  const handleSave = useCallback(async (e: React.FormEvent) => {
    e.preventDefault();
    if (!settings) return;
    setSaving(true);
    try {
      await adminClient.updateSettings({ settings });
      toast.success("Configuración guardada");
    } catch (err) {
      console.error("Failed to save settings:", err);
      toast.error("Error al guardar configuración");
    } finally {
      setSaving(false);
    }
  }, [settings]);

  return {
    settings,
    setSettings,
    loading,
    saving,
    handleSave,
    isPending,
  };
}
