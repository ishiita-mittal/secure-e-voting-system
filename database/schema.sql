-- ============================================
-- SECURE E-VOTING SYSTEM
-- DATABASE SCHEMA
-- ============================================


-- ============================================
-- 1. ELECTIONS TABLE
-- ============================================

CREATE TABLE elections (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'UPCOMING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT elections_status_check
        CHECK (status IN ('UPCOMING', 'OPEN', 'CLOSED')),

    CONSTRAINT elections_time_check
        CHECK (end_time > start_time)
);


-- ============================================
-- 2. VOTERS TABLE
-- ============================================

CREATE TABLE voters (
    id BIGSERIAL PRIMARY KEY,
    voter_id VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,

    has_voted BOOLEAN NOT NULL DEFAULT FALSE,

    otp_hash TEXT,
    otp_expires_at TIMESTAMPTZ,
    otp_attempts INTEGER NOT NULL DEFAULT 0,
    otp_verified BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT voters_otp_attempts_check
        CHECK (otp_attempts >= 0)
);


-- ============================================
-- 3. CANDIDATES TABLE
-- ============================================

CREATE TABLE candidates (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT candidates_status_check
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);


-- ============================================
-- 4. VOTES TABLE
-- ============================================
-- IMPORTANT:
-- This table intentionally DOES NOT contain voter_id.

CREATE TABLE votes (
    id BIGSERIAL PRIMARY KEY,
    encrypted_choice TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ============================================
-- 5. AUDIT LOG TABLE
-- ============================================

CREATE TABLE audit_log (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    voter_id VARCHAR(50),
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_voters_voter_id
ON voters(voter_id);

CREATE INDEX idx_candidates_status
ON candidates(status);

CREATE INDEX idx_audit_log_event_type
ON audit_log(event_type);

CREATE INDEX idx_audit_log_created_at
ON audit_log(created_at);

CREATE INDEX idx_votes_created_at
ON votes(created_at);