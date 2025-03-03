-- ===============================
-- 2. DESIGNERS
-- ===============================

-- Designers Table
CREATE TABLE designers (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  specialty TEXT NOT NULL,
  image_url TEXT,
  collections INTEGER DEFAULT 0,
  awards INTEGER DEFAULT 0,
  description TEXT,
  slug TEXT UNIQUE NOT NULL,
  website_url TEXT,
  social_media JSONB,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_designers_updated_at
BEFORE UPDATE ON designers
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();