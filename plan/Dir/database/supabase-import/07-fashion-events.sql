-- Fashion Events Table - Main events table
CREATE TABLE fashion_events (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  subtitle TEXT,
  tagline TEXT,
  description TEXT,
  category_id INTEGER REFERENCES event_categories(id),
  venue_id INTEGER REFERENCES venues(id),
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('draft', 'published', 'cancelled', 'postponed', 'completed', 'coming_soon')),
  visibility TEXT NOT NULL DEFAULT 'public' CHECK (visibility IN ('public', 'private', 'unlisted')),
  capacity INTEGER,
  price_range_min INTEGER,
  price_range_max INTEGER,
  price_currency TEXT DEFAULT 'USD',
  is_featured BOOLEAN DEFAULT FALSE,
  image_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT check_dates CHECK (end_date > start_date)
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_fashion_events_updated_at
BEFORE UPDATE ON fashion_events
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();