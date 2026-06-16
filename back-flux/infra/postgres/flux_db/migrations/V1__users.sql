CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(64),
    phone TEXT UNIQUE,
    email TEXT UNIQUE,
    img TEXT,
    status TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX ix_users_phone ON users(phone);