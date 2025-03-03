-- Venues Table
CREATE TABLE venues (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  address TEXT,
  city TEXT NOT NULL,
  state TEXT,
  country TEXT NOT NULL,
  postal_code TEXT,
  capacity INTEGER,
  has_catwalk BOOLEAN DEFAULT FALSE,
  has_backstage BOOLEAN DEFAULT FALSE,
  has_vip_area BOOLEAN DEFAULT FALSE,
  amenities TEXT[],
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_venues_updated_at
BEFORE UPDATE ON venues
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();