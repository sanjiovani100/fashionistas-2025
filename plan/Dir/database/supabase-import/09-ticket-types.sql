-- Ticket Types Table
CREATE TABLE ticket_types (
  id SERIAL PRIMARY KEY,
  event_id INTEGER NOT NULL REFERENCES fashion_events(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price INTEGER NOT NULL, -- Stored in cents/smallest currency unit
  is_vip BOOLEAN DEFAULT FALSE,
  is_early_bird BOOLEAN DEFAULT FALSE,
  includes_swag BOOLEAN DEFAULT FALSE,
  includes_afterparty BOOLEAN DEFAULT FALSE,
  features TEXT[],
  is_recommended BOOLEAN DEFAULT FALSE,
  sale_start_date TIMESTAMPTZ,
  sale_end_date TIMESTAMPTZ,
  max_per_order INTEGER DEFAULT 10,
  visibility TEXT NOT NULL DEFAULT 'public' CHECK (visibility IN ('public', 'private', 'hidden')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_ticket_types_updated_at
BEFORE UPDATE ON ticket_types
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();