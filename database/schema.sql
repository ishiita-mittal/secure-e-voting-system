-- ============================================
-- SECURE E-VOTING SYSTEM
-- DATABASE SCHEMA
-- Supports multiple simultaneous elections
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
-- 3. ELECTION VOTERS TABLE
-- ============================================
-- Determines which voters can participate
-- in which elections.
--
-- A voter can participate in MANY elections.
-- A voter can vote only ONCE per election.

CREATE TABLE election_voters (
    election_id BIGINT NOT NULL,
    voter_id BIGINT NOT NULL,
    has_voted BOOLEAN NOT NULL DEFAULT FALSE,

    PRIMARY KEY (election_id, voter_id),

    CONSTRAINT fk_election_voters_election
        FOREIGN KEY (election_id)
        REFERENCES elections(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_election_voters_voter
        FOREIGN KEY (voter_id)
        REFERENCES voters(id)
        ON DELETE CASCADE
);


-- ============================================
-- 4. CANDIDATES TABLE
-- ============================================

CREATE TABLE candidates (
    id BIGSERIAL PRIMARY KEY,
    election_id BIGINT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_candidates_election
        FOREIGN KEY (election_id)
        REFERENCES elections(id)
        ON DELETE CASCADE,

    CONSTRAINT candidates_status_check
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);


-- ============================================
-- 5. VOTES TABLE
-- ============================================
--
-- IMPORTANT SECURITY RULE:
-- This table DOES NOT contain voter_id.
--
-- Therefore, the actual stored vote is not directly
-- associated with the identity of the voter.
--
-- encrypted_choice contains the encrypted candidate choice.

CREATE TABLE votes (
    id BIGSERIAL PRIMARY KEY,
    election_id BIGINT NOT NULL,
    encrypted_choice TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_votes_election
        FOREIGN KEY (election_id)
        REFERENCES elections(id)
        ON DELETE CASCADE
);


-- ============================================
-- 6. AUDIT LOG TABLE
-- ============================================
--
-- Records security/system events.
-- Candidate choice must NEVER be stored here.

CREATE TABLE audit_log (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    voter_id VARCHAR(50),
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- ============================================
-- 7. INDEXES
-- ============================================

CREATE INDEX idx_voters_voter_id
ON voters(voter_id);

CREATE INDEX idx_election_voters_voter_id
ON election_voters(voter_id);

CREATE INDEX idx_candidates_election_id
ON candidates(election_id);

CREATE INDEX idx_candidates_status
ON candidates(status);

CREATE INDEX idx_votes_election_id
ON votes(election_id);

CREATE INDEX idx_votes_created_at
ON votes(created_at);

CREATE INDEX idx_audit_log_event_type
ON audit_log(event_type);

CREATE INDEX idx_audit_log_created_at
ON audit_log(created_at);