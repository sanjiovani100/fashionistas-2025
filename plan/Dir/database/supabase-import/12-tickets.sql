-- Tickets Table
CREATE TABLE tickets (
  id SERIAL PRIMARY KEY,
  ticket_number TEXT UNIQUE NOT NULL,
  order_item_id INTEGER NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
  event_id INTEGER NOT NULL REFERENCES fashion_events(id),
  ticket_type_id INTEGER NOT NULL REFERENCES ticket_types(id),
  user_id INTEGER REFERENCES users(id),
  attendee_name TEXT,
  attendee_email TEXT,
  status TEXT NOT NULL CHECK (status IN ('issued', 'validated', 'used', 'cancelled', 'refunded')),
  is_checked_in BOOLEAN DEFAULT FALSE,
  check_in_time TIMESTAMPTZ,
  barcode TEXT UNIQUE,
  qr_code TEXT UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_tickets_updated_at
BEFORE UPDATE ON tickets
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();