-- Migration: Add Periods management
-- Date: 2026-05-03

CREATE TABLE IF NOT EXISTS periods (
    id TEXT PRIMARY KEY, -- Format: YYYY-MM
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'OPEN', -- 'OPEN', 'CLOSED'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed initial period if not exists (current month)
INSERT INTO periods (id, start_date, end_date, status)
VALUES (
    TO_CHAR(CURRENT_DATE, 'YYYY-MM'),
    DATE_TRUNC('month', CURRENT_DATE)::DATE,
    (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::DATE,
    'OPEN'
) ON CONFLICT DO NOTHING;
