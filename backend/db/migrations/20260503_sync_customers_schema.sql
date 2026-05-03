-- Migration: Sync customers table with schema
-- Date: 2026-05-03

ALTER TABLE customers ADD COLUMN IF NOT EXISTS contract_start DATE;
ALTER TABLE customers ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();
