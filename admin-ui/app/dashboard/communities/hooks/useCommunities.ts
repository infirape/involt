import { useState, useEffect, useCallback, useTransition } from "react";
import { adminClient } from "@/lib/rpc";
import { Community, CommunitySchema } from "@/app/gen/involt/v1/models_pb";
import { create } from "@bufbuild/protobuf";
import { toast } from "sonner";

export function useCommunities() {
  const [, startTransition] = useTransition();
  const [data, setData] = useState<{
    communities: Community[];
    loading: boolean;
  }>({
    communities: [],
    loading: true,
  });

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCommunity, setEditingCommunity] = useState<Community | null>(
    null,
  );
  const [saving, setSaving] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");

  const loadData = useCallback(async () => {
    try {
      const resp = await adminClient.getCommunities({});
      startTransition(() => {
        setData({
          communities: resp.communities,
          loading: false,
        });
      });
    } catch (error) {
      console.error("Error loading communities:", error);
      toast.error("Error al cargar comunidades");
      startTransition(() => {
        setData((prev) => ({ ...prev, loading: false }));
      });
    }
  }, []);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleOpenModal = (community?: Community) => {
    if (community) {
      setEditingCommunity(create(CommunitySchema, community));
    } else {
      setEditingCommunity(
        create(CommunitySchema, {
          name: "",
        }),
      );
    }
    setIsModalOpen(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingCommunity) return;

    if (!editingCommunity.name) {
      toast.error("El nombre es requerido");
      return;
    }

    setSaving(true);
    try {
      await adminClient.upsertCommunity({ community: editingCommunity });
      toast.success(
        editingCommunity.id ? "Comunidad actualizada" : "Comunidad creada",
      );
      setIsModalOpen(false);
      loadData();
    } catch (error) {
      console.error("Error saving community:", error);
      toast.error("Error al guardar la comunidad");
    } finally {
      setSaving(false);
    }
  };

  const filteredCommunities = data.communities.filter((c) =>
    c.name.toLowerCase().includes(searchQuery.toLowerCase()),
  );

  return {
    data: { ...data, communities: filteredCommunities },
    isModalOpen,
    setIsModalOpen,
    editingCommunity,
    setEditingCommunity,
    saving,
    searchQuery,
    setSearchQuery,
    handleOpenModal,
    handleSave,
    refresh: loadData,
  };
}
