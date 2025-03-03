# Supabase Database Setup Guide

This guide outlines the steps to set up the Fashionistas Event Platform database in Supabase.

## Prerequisites

1. A Supabase account and project
2. Access to the Supabase dashboard
3. The updated `schema.sql` file from the project

## Setup Steps

### 1. Access the SQL Editor

1. Log in to your Supabase dashboard
2. Select your project
3. Navigate to the "SQL Editor" section in the left sidebar
4. Click "New Query" to create a new SQL script

### 2. Enable Required Extensions

First, run the following SQL to enable the required extensions:

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
```

### 3. Create the Timestamp Management Function

Next, create the function for automatically updating timestamps:

```sql
-- Function to automatically set updated_at timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 4. Create Tables in the Correct Order

Due to foreign key dependencies, tables must be created in a specific order. Follow these steps:

#### Step 1: User Management Tables

```sql
-- Users Table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  password_hash TEXT NOT NULL,
  full_name TEXT NOT NULL,
  phone_number TEXT,
  profile_image_url TEXT,
  email_verified BOOLEAN NOT NULL DEFAULT false,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('active', 'inactive', 'pending', 'suspended')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_login TIMESTAMPTZ
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- User Roles Table
CREATE TABLE user_roles (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_user_roles_updated_at
BEFORE UPDATE ON user_roles
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- User to Role Junction Table
CREATE TABLE user_to_role (
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role_id INTEGER NOT NULL REFERENCES user_roles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, role_id)
);
```

#### Step 2: Designers Table

```sql
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
```

#### Step 3: Event Core Tables

```sql
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

-- Fashion Events Table
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

-- Event to Designer Junction Table
CREATE TABLE event_to_designer (
  event_id INTEGER NOT NULL REFERENCES fashion_events(id) ON DELETE CASCADE,
  designer_id INTEGER NOT NULL REFERENCES designers(id) ON DELETE CASCADE,
  is_headliner BOOLEAN DEFAULT FALSE,
  presentation_order INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (event_id, designer_id)
);
```

#### Step 4: Ticketing Tables

```sql
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

-- Orders Table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_number TEXT UNIQUE NOT NULL,
  user_id INTEGER REFERENCES users(id),
  event_id INTEGER REFERENCES fashion_events(id),
  status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'completed', 'cancelled', 'refunded')),
  payment_status TEXT NOT NULL CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded', 'partially_refunded')),
  payment_method TEXT,
  subtotal INTEGER NOT NULL, -- Stored in cents/smallest currency unit
  discount_amount INTEGER DEFAULT 0,
  tax_amount INTEGER DEFAULT 0,
  total_amount INTEGER NOT NULL,
  currency TEXT DEFAULT 'USD',
  billing_name TEXT,
  billing_email TEXT,
  billing_phone TEXT,
  billing_address TEXT,
  billing_city TEXT,
  billing_state TEXT,
  billing_country TEXT,
  billing_postal_code TEXT,
  order_notes TEXT,
  order_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  payment_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Order Items Table
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  ticket_type_id INTEGER NOT NULL REFERENCES ticket_types(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price INTEGER NOT NULL,
  total_price INTEGER NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending', 'confirmed', 'cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_order_items_updated_at
BEFORE UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

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
```

### 5. Insert Sample Data

After creating all tables, you can insert sample data:

```sql
-- Sample User Roles
INSERT INTO user_roles (name, description) VALUES
('admin', 'Full system access'),
('event_manager', 'Can manage events and related content'),
('designer', 'Designer account with limited access'),
('attendee', 'Regular user who can purchase tickets');

-- Sample Designers
INSERT INTO designers (name, specialty, image_url, collections, awards, description, slug, is_featured) VALUES
('Sophia Laurent', 'Avant-Garde Evening Wear', '/images/swimwear/swim-004.jpg', 12, 5, 'Known for pushing boundaries with innovative silhouettes and unexpected materials.', 'sophia-laurent', TRUE),
('Marcus Chen', 'Sustainable Streetwear', '/images/swimwear/2-swimwear-013.jpg', 8, 3, 'Pioneering eco-conscious urban fashion with upcycled materials and zero-waste patterns.', 'marcus-chen', FALSE),
('Amara Okafor', 'Luxury Swimwear', '/images/swimwear/600001147386b0 (1).jpg', 15, 7, 'Redefining resort wear with bold prints and innovative, figure-flattering cuts.', 'amara-okafor', TRUE);

-- Sample Event Categories
INSERT INTO event_categories (name, slug, description, season, fashion_type) VALUES
('Fashion Week', 'fashion-week', 'Major seasonal fashion showcase events', 'all-season', 'ready-to-wear'),
('Designer Showcase', 'designer-showcase', 'Focused events highlighting specific designers', 'all-season', 'haute-couture'),
('Sustainable Fashion', 'sustainable-fashion', 'Events promoting eco-friendly fashion', 'all-season', 'sustainable');

-- Sample Venues
INSERT INTO venues (name, slug, description, address, city, state, country, postal_code, capacity, has_catwalk, has_backstage, has_vip_area) VALUES
('Fashion Center', 'fashion-center', 'Premier fashion event venue with state-of-the-art facilities', '123 Fashion Ave', 'New York', 'NY', 'USA', '10001', 1200, TRUE, TRUE, TRUE),
('Luxury Hotel Grand Ballroom', 'luxury-hotel', 'Elegant ballroom setting for exclusive fashion events', '45 Luxury Blvd', 'Paris', NULL, 'France', '75008', 500, TRUE, TRUE, TRUE),
('Convention Center', 'convention-center', 'Spacious venue for large-scale fashion events', '789 Convention Way', 'Milan', NULL, 'Italy', '20121', 2000, TRUE, TRUE, TRUE);

-- Sample Fashion Events
INSERT INTO fashion_events (title, slug, subtitle, description, category_id, venue_id, start_date, end_date, status, capacity, price_range_min, price_range_max, is_featured, image_url) VALUES
('Summer Fashion Week 2024', 'summer-fashion-week-2024', 'Celebrating Summer Collections', 'Experience the latest summer collections from top designers around the world. Featuring runway shows, exclusive presentations, and networking opportunities.', 1, 1, '2024-06-15 09:00:00', '2024-06-20 18:00:00', 'coming_soon', 1000, 10000, 80000, TRUE, '/images/event-highlights/fashion-show.jpg'),
('Designer Showcase: Evening Elegance', 'designer-showcase-evening-elegance', 'A Night of Elegance', 'Join us for an exclusive evening showcasing elegant evening wear from emerging designers. Cocktails and canapés will be served.', 2, 2, '2024-05-05 19:00:00', '2024-05-05 23:00:00', 'published', 400, 25000, 50000, FALSE, '/images/event-highlights/party.jpg'),
('Sustainable Fashion Conference', 'sustainable-fashion-conference', 'Fashion for the Future', 'A three-day conference focused on sustainable practices in the fashion industry. Featuring keynote speakers, panel discussions, and workshops.', 3, 3, '2024-07-10 08:00:00', '2024-07-12 17:00:00', 'coming_soon', 1500, 15000, 30000, TRUE, '/images/event-highlights/vip.jpg');

-- Connect Events to Designers
INSERT INTO event_to_designer (event_id, designer_id, is_headliner, presentation_order) VALUES
(1, 1, TRUE, 1),
(1, 2, FALSE, 2),
(2, 1, TRUE, 1),
(3, 2, TRUE, 1),
(3, 3, FALSE, 2);

-- Sample Ticket Types
INSERT INTO ticket_types (event_id, name, description, price, is_vip, is_early_bird, features, is_recommended) VALUES
(1, 'General Admission', 'Essential fashion experience', 100000, FALSE, FALSE, ARRAY['Standard seating', 'Event access', 'Complimentary drinks', 'Digital program'], FALSE),
(1, 'Premium Experience', 'Enhanced fashion access', 250000, TRUE, FALSE, ARRAY['Priority seating', 'VIP lounge access', 'Welcome champagne', 'Event gift bag', 'Reserved parking'], TRUE),
(1, 'VIP Elite Package', 'Ultimate luxury access', 800000, TRUE, FALSE, ARRAY['Front row seating', 'Exclusive lounge access', 'Designer meet & greets', 'Luxury gift bag', 'Complimentary valet parking'], FALSE),
(2, 'Standard Entry', 'Basic access to the showcase', 25000, FALSE, FALSE, ARRAY['Event entry', 'Welcome drink', 'Digital lookbook'], FALSE),
(2, 'VIP Experience', 'Premium showcase experience', 50000, TRUE, FALSE, ARRAY['Front row seating', 'Open bar', 'Swag bag', 'Designer meet & greet'], TRUE),
(3, 'Conference Pass', 'Full conference access', 15000, FALSE, TRUE, ARRAY['All sessions', 'Lunch included', 'Conference materials'], TRUE),
(3, 'Workshop Bundle', 'Conference plus hands-on workshops', 30000, FALSE, FALSE, ARRAY['All sessions', 'All workshops', 'Lunch and refreshments', 'Sustainable fashion toolkit'], FALSE);
```

## 6. Supabase Integration with Next.js

### Install Required Packages

```bash
npm install @supabase/supabase-js
```

### Create Environment Variables

Create a `.env.local` file in your project root with the following variables:

```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Create a Supabase Client

Create a file at `src/lib/supabase.js`:

```javascript
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

### Example Query

Here's an example of how to query the database from your Next.js application:

```javascript
import { supabase } from '@/lib/supabase';

// Fetch all events
async function fetchEvents() {
  const { data, error } = await supabase
    .from('fashion_events')
    .select('*, venue:venues(*), category:event_categories(*)')
    .order('start_date', { ascending: true });
    
  if (error) {
    console.error('Error fetching events:', error);
    return [];
  }
  
  return data;
}

// Fetch a specific event with designers
async function fetchEventWithDesigners(slug) {
  const { data, error } = await supabase
    .from('fashion_events')
    .select(`
      *,
      venue:venues(*),
      category:event_categories(*),
      designers:event_to_designer(
        designer:designers(*)
      )
    `)
    .eq('slug', slug)
    .single();
    
  if (error) {
    console.error('Error fetching event:', error);
    return null;
  }
  
  return data;
}
```

## 7. Row-Level Security (RLS) Policies

For better security, implement Row-Level Security policies in Supabase:

```sql
-- Enable RLS on tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE fashion_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Example policies
-- Allow users to read public events
CREATE POLICY "Public events are viewable by everyone" 
ON fashion_events FOR SELECT 
USING (visibility = 'public');

-- Allow users to view their own orders
CREATE POLICY "Users can view their own orders" 
ON orders FOR SELECT 
USING (auth.uid() = user_id);

-- Allow users to view their own tickets
CREATE POLICY "Users can view their own tickets" 
ON tickets FOR SELECT 
USING (auth.uid() = user_id);
```

## 8. Troubleshooting

### Common Issues

1. **Foreign Key Constraints**: Ensure you create tables in the correct order to avoid foreign key constraint errors.
2. **Duplicate Keys**: When inserting sample data, ensure there are no duplicate primary keys or unique constraints.
3. **Data Type Mismatches**: Ensure data types match when inserting values, especially for dates and timestamps.

### Verifying Setup

To verify your setup, run these queries in the SQL Editor:

```sql
-- Check if tables were created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Count records in key tables
SELECT 'designers' as table_name, COUNT(*) as record_count FROM designers
UNION ALL
SELECT 'fashion_events', COUNT(*) FROM fashion_events
UNION ALL
SELECT 'venues', COUNT(*) FROM venues
UNION ALL
SELECT 'ticket_types', COUNT(*) FROM ticket_types;
```

## Next Steps

After setting up the database:

1. Configure authentication in Supabase
2. Set up storage for images and files
3. Create API endpoints in Next.js
4. Implement frontend components to interact with the database

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Next.js Documentation](https://nextjs.org/docs) 