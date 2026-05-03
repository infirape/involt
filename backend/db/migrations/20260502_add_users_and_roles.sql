-- Migration: Add Users and Roles for Admin RBAC
-- Date: 2026-05-02

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'READER', -- 'ADMIN', 'SUPERVISOR', 'READER'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create user_sectors join table for sector-level permissions
CREATE TABLE IF NOT EXISTS user_sectors (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    sector_id TEXT NOT NULL, -- references sectors(id) but stored as text to avoid strict coupling if sectors are moved
    PRIMARY KEY (user_id, sector_id)
);

-- Index for performance
CREATE INDEX IF NOT EXISTS idx_user_sectors_user_id ON user_sectors(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sectors_sector_id ON user_sectors(sector_id);

-- Seed initial admin user (password: admin)
INSERT INTO users (email, password_hash, role)
VALUES ('admin@infira.pe', '$2a$10$dwB7XvBZNbRY5GMwd61IRum0y5FSzn4hq3Dl3FuxdHwyi.i1exx0a', 'ADMIN')
ON CONFLICT (email) DO NOTHING;
