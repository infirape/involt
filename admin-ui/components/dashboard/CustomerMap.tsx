"use client";

import L from "leaflet";
import { useEffect, useMemo, useState } from "react";
import { MapContainer, Marker, Popup, TileLayer } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import type { Customer } from "@/app/gen/involt/v1/models_pb";
import { adminClient } from "@/lib/rpc";

export default function CustomerMap() {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    async function fetchCustomers() {
      try {
        const resp = await adminClient.getCustomers({});
        setCustomers(resp.customers);
      } catch (err) {
        console.error("Failed to fetch customers for map:", err);
      }
    }
    fetchCustomers();
  }, []);

  // Chetilla, Cajamarca center
  const center = useMemo<[number, number]>(() => [-7.147, -78.6727], []);

  // Custom Primary Glow Icon
  const primaryIcon = useMemo(() => {
    if (typeof window === "undefined") return null;
    return L.divIcon({
      className: "custom-div-icon",
      html: `<div style="
        width: 10px; 
        height: 10px; 
        background-color: #FF00FF; 
        border-radius: 50%; 
        box-shadow: 0 0 10px #FF00FF, 0 0 5px #FF00FF inset;
        border: 2px solid white;
      "></div>`,
      iconSize: [10, 10],
      iconAnchor: [5, 5],
    });
  }, []);

  if (!mounted || typeof window === "undefined") {
    return (
      <div className="h-[400px] w-full rounded-[2rem] bg-white/5 animate-pulse flex items-center justify-center">
        <p className="text-xs font-black uppercase tracking-widest text-muted-foreground">
          Inicializando Mapa...
        </p>
      </div>
    );
  }

  return (
    <div className="h-[400px] w-full rounded-[2rem] overflow-hidden border border-white/5 shadow-2xl relative group">
      {/* Visual Filters for Dark Mode Aesthetics */}
      <div className="absolute inset-0 z-[400] pointer-events-none bg-black/10 mix-blend-overlay border-[40px] border-black/20" />
      
      <div className="absolute top-6 left-6 z-[1000] flex items-center gap-3">
        <div className="bg-black/80 backdrop-blur-xl px-4 py-2 rounded-2xl border border-white/10 shadow-2xl">
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 rounded-full bg-primary animate-pulse" />
            <p className="text-[10px] font-black uppercase tracking-[0.2em] text-white">
              Chetilla <span className="text-muted-foreground">Telemetría</span>
            </p>
          </div>
        </div>
      </div>

      <MapContainer
        center={center}
        zoom={15}
        scrollWheelZoom={false}
        dragging={false}
        zoomControl={false}
        doubleClickZoom={false}
        touchZoom={false}
        className="h-full w-full grayscale-[0.6] contrast-[1.1] invert-[0.9] brightness-[0.4]"
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        {customers.map(
          (customer) =>
            customer.latitude !== 0 &&
            primaryIcon && (
              <Marker
                key={customer.id}
                position={[customer.latitude, customer.longitude]}
                icon={primaryIcon}
              >
                <Popup className="premium-popup">
                  <div className="p-2 bg-black text-white rounded-lg">
                    <p className="font-black uppercase text-[10px] tracking-widest text-primary mb-1">
                      {customer.name}
                    </p>
                    <p className="text-[9px] font-bold text-muted-foreground">
                      CÓDIGO: {customer.code}
                    </p>
                  </div>
                </Popup>
              </Marker>
            ),
        )}
      </MapContainer>
    </div>
  );
}
