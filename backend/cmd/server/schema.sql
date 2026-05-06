-- InVolt Database Schema

-- Users
CREATE TABLE IF NOT EXISTS users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    role text DEFAULT 'READER'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
ALTER TABLE users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE users ADD CONSTRAINT users_email_key UNIQUE (email);

-- Communities
CREATE TABLE IF NOT EXISTS communities (
    id text NOT NULL,
    name text NOT NULL
);
ALTER TABLE communities ADD CONSTRAINT communities_pkey PRIMARY KEY (id);

-- Sectors
CREATE TABLE IF NOT EXISTS sectors (
    id text NOT NULL,
    community_id text,
    name text NOT NULL
);
ALTER TABLE sectors ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);
ALTER TABLE sectors ADD CONSTRAINT sectors_community_id_fkey FOREIGN KEY (community_id) REFERENCES communities(id);

-- User Sectors
CREATE TABLE IF NOT EXISTS user_sectors (
    user_id uuid NOT NULL,
    sector_id text NOT NULL
);
ALTER TABLE user_sectors ADD CONSTRAINT user_sectors_pkey PRIMARY KEY (user_id, sector_id);
ALTER TABLE user_sectors ADD CONSTRAINT user_sectors_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS idx_user_sectors_user_id ON user_sectors(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sectors_sector_id ON user_sectors(sector_id);

-- Customers
CREATE TABLE IF NOT EXISTS customers (
    id text NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    community_id text,
    sector_id text,
    connection_type text NOT NULL,
    tariff double precision NOT NULL,
    meter_number text NOT NULL,
    latitude double precision DEFAULT 0 NOT NULL,
    longitude double precision DEFAULT 0 NOT NULL,
    initial_reading double precision DEFAULT 0,
    address text DEFAULT ''::text NOT NULL,
    contract_start date,
    created_at timestamp with time zone DEFAULT now()
);
ALTER TABLE customers ADD CONSTRAINT customers_pkey PRIMARY KEY (id);
ALTER TABLE customers ADD CONSTRAINT customers_code_key UNIQUE (code);
ALTER TABLE customers ADD CONSTRAINT customers_community_id_fkey FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE customers ADD CONSTRAINT customers_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sectors(id);

-- Periods
CREATE TABLE IF NOT EXISTS periods (
    id text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_billing_period boolean DEFAULT true
);
ALTER TABLE periods ADD CONSTRAINT periods_pkey PRIMARY KEY (id);

-- Readings
CREATE TABLE IF NOT EXISTS readings (
    id text NOT NULL,
    customer_id text,
    previous_value double precision NOT NULL,
    current_value double precision NOT NULL,
    consumption double precision NOT NULL,
    photo_url text DEFAULT ''::text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    latitude double precision DEFAULT 0 NOT NULL,
    longitude double precision DEFAULT 0 NOT NULL,
    cargo_fijo double precision NOT NULL,
    alumbrado_publico double precision NOT NULL,
    saldo_redondeo double precision NOT NULL,
    total_to_pay double precision NOT NULL,
    period_start date DEFAULT CURRENT_DATE NOT NULL,
    period_end date DEFAULT CURRENT_DATE NOT NULL,
    mantenimiento double precision DEFAULT 0 NOT NULL,
    adjustment double precision DEFAULT 0,
    subtotal double precision DEFAULT 0 NOT NULL,
    round_difference double precision DEFAULT 0,
    previous_balance double precision DEFAULT 0,
    overdue_total double precision DEFAULT 0,
    expiration_date date DEFAULT CURRENT_DATE NOT NULL,
    period character varying(10)
);
ALTER TABLE readings ADD CONSTRAINT readings_pkey PRIMARY KEY (id);
ALTER TABLE readings ADD CONSTRAINT readings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);

-- Settings
CREATE TABLE IF NOT EXISTS settings (
    id text DEFAULT 'main'::text NOT NULL,
    municipalidad text DEFAULT 'MUNICIPALIDAD DISTRITAL DE CHETILLA'::text NOT NULL,
    empresa text DEFAULT 'HIDROELECTRICA QARWAQIRU'::text NOT NULL,
    ruc text,
    direccion text,
    telefono text,
    email text,
    dias_vencimiento integer DEFAULT 15,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    tarifa_kwh double precision DEFAULT 0.25,
    cargo_fijo double precision DEFAULT 6.00,
    alumbrado double precision DEFAULT 0.00,
    mantenimiento double precision DEFAULT 0.00,
    igv boolean DEFAULT false
);
ALTER TABLE settings ADD CONSTRAINT settings_pkey PRIMARY KEY (id);

-- App Configs
CREATE TABLE IF NOT EXISTS app_configs (
    key text NOT NULL,
    value text
);
ALTER TABLE app_configs ADD CONSTRAINT app_configs_pkey PRIMARY KEY (key);