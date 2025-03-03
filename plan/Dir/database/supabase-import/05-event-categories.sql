-- Event Categories Table
CREATE TABLE event_categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  season TEXT CHECK (season IN ('spring', 'summer', 'fall', 'winter', 'all-season')),
  fashion_type TEXT CHECK (fashion_type IN ('ready-to-wear', 'haute-couture', 'resort', 'swimwear', 'bridal', 'menswear', 'streetwear', 'sustainable', 'other')),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_event_categories_updated_at
BEFORE UPDATE ON event_categories
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();