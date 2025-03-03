Phase 2A (Ticketing System Core) 
and Phase 2B (Designer and Collection Management System). 



```markdown
# Fashionistas Event Platform - Database Schema Design (Part 2: Ticketing and Designer Management)

This document is the second part of the Fashionistas Event Platform database schema design, focusing on the ticketing system and designer management components.

## Phase 2A: Ticketing System Core for Fashionistas Event Platform

### SQL Schema

```sql
-- =============================================
-- TICKET TYPES
-- =============================================
CREATE TABLE public.ticket_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price >= 0),
    sale_start_date TIMESTAMPTZ NOT NULL,
    sale_end_date TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    is_featured BOOLEAN NOT NULL DEFAULT false,
    total_capacity INTEGER NOT NULL CHECK (total_capacity >= 0),
    remaining_capacity INTEGER NOT NULL CHECK (remaining_capacity >= 0),
    max_per_order INTEGER NOT NULL DEFAULT 10 CHECK (max_per_order > 0),
    min_per_order INTEGER NOT NULL DEFAULT 1 CHECK (min_per_order > 0),
    features JSONB DEFAULT '[]'::jsonb,
    tier_level INTEGER DEFAULT 1,
    version INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT check_dates CHECK (sale_start_date < sale_end_date),
    CONSTRAINT check_capacity CHECK (remaining_capacity <= total_capacity),
    CONSTRAINT check_min_max_order CHECK (min_per_order <= max_per_order)
);

-- Indexes for ticket type lookups
CREATE INDEX idx_ticket_types_event_id ON public.ticket_types (event_id);
CREATE INDEX idx_ticket_types_active ON public.ticket_types (is_active) WHERE is_active = true;
CREATE INDEX idx_ticket_types_featured ON public.ticket_types (is_featured) WHERE is_featured = true;
CREATE INDEX idx_ticket_types_sale_dates ON public.ticket_types (sale_start_date, sale_end_date);
CREATE INDEX idx_ticket_types_capacity ON public.ticket_types (remaining_capacity) WHERE remaining_capacity > 0;

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.ticket_types
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- ORDERS
-- =============================================
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    order_number TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'completed', 'cancelled', 'refunded', 'failed')),
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    currency TEXT NOT NULL DEFAULT 'USD',
    payment_method TEXT,
    payment_intent_id TEXT,
    billing_address JSONB,
    shipping_address JSONB,
    contact_email TEXT NOT NULL,
    contact_phone TEXT,
    notes TEXT,
    ip_address TEXT,
    user_agent TEXT,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    refunded_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for order lookups
CREATE INDEX idx_orders_user_id ON public.orders (user_id);
CREATE INDEX idx_orders_status ON public.orders (status);
CREATE INDEX idx_orders_order_number ON public.orders (order_number);
CREATE INDEX idx_orders_payment_intent_id ON public.orders (payment_intent_id) WHERE payment_intent_id IS NOT NULL;
CREATE INDEX idx_orders_created_at ON public.orders (created_at);
CREATE INDEX idx_orders_completed_at ON public.orders (completed_at) WHERE completed_at IS NOT NULL;

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.orders
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- ORDER ITEMS
-- =============================================
CREATE TABLE public.order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
    ticket_type_id UUID NOT NULL REFERENCES public.ticket_types(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),
    discount_code_id UUID REFERENCES public.discount_codes(id) ON DELETE SET NULL,
    attendee_info JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for order item lookups
CREATE INDEX idx_order_items_order_id ON public.order_items (order_id);
CREATE INDEX idx_order_items_ticket_type_id ON public.order_items (ticket_type_id);
CREATE INDEX idx_order_items_discount_code_id ON public.order_items (discount_code_id) WHERE discount_code_id IS NOT NULL;

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.order_items
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- DISCOUNT CODES
-- =============================================
CREATE TABLE public.discount_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT UNIQUE NOT NULL,
    description TEXT,
    discount_type TEXT NOT NULL CHECK (discount_type IN ('percentage', 'fixed_amount')),
    discount_value DECIMAL(10, 2) NOT NULL CHECK (discount_value > 0),
    min_order_amount DECIMAL(10, 2) DEFAULT 0,
    max_discount_amount DECIMAL(10, 2),
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    is_one_time_use BOOLEAN NOT NULL DEFAULT false,
    max_uses INTEGER,
    current_uses INTEGER NOT NULL DEFAULT 0,
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT check_dates CHECK (start_date < end_date),
    CONSTRAINT check_uses CHECK (max_uses IS NULL OR current_uses <= max_uses)
);

-- Indexes for discount code lookups
CREATE INDEX idx_discount_codes_code ON public.discount_codes (code);
CREATE INDEX idx_discount_codes_active ON public.discount_codes (is_active) WHERE is_active = true;
CREATE INDEX idx_discount_codes_dates ON public.discount_codes (start_date, end_date);
CREATE INDEX idx_discount_codes_created_by ON public.discount_codes (created_by);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.discount_codes
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### ERD Relationships

1. **Ticket Types to Events**: Many-to-one relationship
   - A ticket type belongs to one event
   - An event can have many ticket types

2. **Orders to Users**: Many-to-one relationship
   - An order belongs to one user (optional - for guest checkout)
   - A user can have many orders

3. **Order Items to Orders**: Many-to-one relationship
   - An order item belongs to one order
   - An order can have many order items

4. **Order Items to Ticket Types**: Many-to-one relationship
   - An order item references one ticket type
   - A ticket type can be referenced by many order items

5. **Order Items to Discount Codes**: Many-to-one relationship (optional)
   - An order item can have one discount code applied
   - A discount code can be applied to many order items

### Indexing Strategy

1. **Primary Indexes**:
   - UUID primary keys on all tables for distributed scalability

2. **Foreign Key Indexes**:
   - All foreign key columns are indexed for join performance

3. **Composite Indexes**:
   - Ticket types: `(sale_start_date, sale_end_date)` for date range queries
   - Discount codes: `(start_date, end_date)` for date range queries

4. **Filtered Indexes**:
   - Active ticket types: `WHERE is_active = true`
   - Featured ticket types: `WHERE is_featured = true`
   - Available capacity: `WHERE remaining_capacity > 0`
   - Orders with payment intents: `WHERE payment_intent_id IS NOT NULL`
   - Completed orders: `WHERE completed_at IS NOT NULL`

## Phase 2B: Designer and Collection Management System

### SQL Schema

```sql
-- =============================================
-- DESIGNERS
-- =============================================
CREATE TABLE public.designers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    brand_name TEXT,
    specialty TEXT,
    bio TEXT,
    website_url TEXT,
    social_media JSONB DEFAULT '{}'::jsonb,
    contact_email TEXT,
    contact_phone TEXT,
    profile_image_url TEXT,
    cover_image_url TEXT,
    is_featured BOOLEAN DEFAULT false,
    is_verified BOOLEAN DEFAULT false,
    status TEXT NOT NULL CHECK (status IN ('active', 'inactive', 'pending', 'rejected')),
    years_active INTEGER,
    awards JSONB DEFAULT '[]'::jsonb,
    press_mentions JSONB DEFAULT '[]'::jsonb,
    location JSONB,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for designer lookups
CREATE INDEX idx_designers_user_id ON public.designers (user_id);
CREATE INDEX idx_designers_status ON public.designers (status);
CREATE INDEX idx_designers_featured ON public.designers (is_featured) WHERE is_featured = true;
CREATE INDEX idx_designers_verified ON public.designers (is_verified) WHERE is_verified = true;
CREATE INDEX idx_designers_specialty ON public.designers (specialty);

-- Full-text search index for designer search
CREATE INDEX idx_designers_fts ON public.designers USING GIN (
    to_tsvector('english', coalesce(name, '') || ' ' || 
    coalesce(brand_name, '') || ' ' || 
    coalesce(specialty, '') || ' ' || 
    coalesce(bio, ''))
);

-- =============================================
-- COLLECTIONS
-- =============================================
CREATE TABLE public.collections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    designer_id UUID NOT NULL REFERENCES public.designers(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    season TEXT CHECK (season IN ('spring', 'summer', 'fall', 'winter', 'resort', 'pre-fall', 'bridal', 'couture', 'other')),
    year INTEGER,
    inspiration TEXT,
    show_notes TEXT,
    is_featured BOOLEAN DEFAULT false,
    status TEXT NOT NULL CHECK (status IN ('draft', 'published', 'archived')),
    event_id UUID REFERENCES public.events(id) ON DELETE SET NULL,
    cover_image_url TEXT,
    gallery_images JSONB DEFAULT '[]'::jsonb,
    video_url TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for collection lookups
CREATE INDEX idx_collections_designer_id ON public.collections (designer_id);
CREATE INDEX idx_collections_status ON public.collections (status);
CREATE INDEX idx_collections_featured ON public.collections (is_featured) WHERE is_featured = true;
CREATE INDEX idx_collections_season_year ON public.collections (season, year);
CREATE INDEX idx_collections_event_id ON public.collections (event_id) WHERE event_id IS NOT NULL;

-- Full-text search index for collection search
CREATE INDEX idx_collections_fts ON public.collections USING GIN (
    to_tsvector('english', coalesce(name, '') || ' ' || 
    coalesce(description, '') || ' ' || 
    coalesce(inspiration, '') || ' ' || 
    coalesce(show_notes, ''))
);
```

### ERD Relationships

1. **Designers to Users**: One-to-one relationship (optional)
   - A designer can be linked to one user account
   - A user can have one designer profile

2. **Collections to Designers**: Many-to-one relationship
   - A collection belongs to one designer
   - A designer can have many collections

3. **Collections to Events**: Many-to-one relationship (optional)
   - A collection can be associated with one event
   - An event can have many collections

### Indexing Strategy

1. **Primary Indexes**:
   - UUID primary keys on all tables for distributed scalability

2. **Foreign Key Indexes**:
   - All foreign key columns are indexed for join performance

3. **Full-Text Search Indexes**:
   - Designer search: Name, brand name, specialty, bio
   - Collection search: Name, description, inspiration, show notes

4. **Filtered Indexes**:
   - Featured designers: `WHERE is_featured = true`
   - Verified designers: `WHERE is_verified = true`
   - Featured collections: `WHERE is_featured = true`
   - Collections with events: `WHERE event_id IS NOT NULL`

## Next Steps

For the continuation of this database schema, please see:
- [Part 1: Core Foundation](db-plan-1.md)
- [Part 3: Sponsorship and Marketing](db-plan-3.md)
- [Part 4: Security and API Integration](db-plan-4.md)
```

This covers the ticketing system and designer management components of the database schema. The document is structured to be about half the size of the original, focusing on the most essential tables, relationships, and indexing strategies.
