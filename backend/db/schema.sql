-- Schema for InVolt Backend

CREATE TABLE IF NOT EXISTS communities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sectors (
    id TEXT PRIMARY KEY,
    community_id TEXT REFERENCES communities(id),
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS customers (
    id TEXT PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    community_id TEXT REFERENCES communities(id),
    sector_id TEXT REFERENCES sectors(id),
    connection_type TEXT NOT NULL, -- MONOFASICA / TRIFASICA
    tariff DOUBLE PRECISION NOT NULL,
    meter_number TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS readings (
    id TEXT PRIMARY KEY,
    customer_id TEXT REFERENCES customers(id),
    previous_value DOUBLE PRECISION NOT NULL,
    current_value DOUBLE PRECISION NOT NULL,
    consumption DOUBLE PRECISION NOT NULL,
    photo_url TEXT,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    cargo_fijo DOUBLE PRECISION NOT NULL,
    alumbrado_publico DOUBLE PRECISION NOT NULL,
    saldo_redondeo DOUBLE PRECISION NOT NULL,
    total_to_pay DOUBLE PRECISION NOT NULL
);

-- Initial Mock Data for Testing
INSERT INTO communities (id, name) VALUES ('COM-001', 'Chetilla') ON CONFLICT DO NOTHING;
INSERT INTO sectors (id, community_id, name) VALUES ('SEC-001', 'COM-001', 'Chetilla Centro') ON CONFLICT DO NOTHING;
INSERT INTO sectors (id, community_id, name) VALUES ('SEC-002', 'COM-001', 'La Libertad') ON CONFLICT DO NOTHING;
