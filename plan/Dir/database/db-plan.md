# Fashionistas Event Platform - Database Schema Design

## Introduction

This document outlines a high-performance relational database schema for the Fashionistas Event Platform, optimized for speed, efficiency, and scalability. The schema is designed to handle high read and write traffic while maintaining data integrity and security.

Based on a review of the existing documentation (`core-database-setup.md`, `core-database.md`, and `pages-db.md`), this schema incorporates best practices for PostgreSQL and Supabase implementation, with a focus on the core components of the platform.

## Core Optimizations

- **Strategic Indexing**: Primary, foreign, composite, and full-text indexes for optimal query performance
- **Table Partitioning**: For large tables (events, tickets, transactions) to improve query performance
- **Normalization**: 3NF with strategic denormalization for performance-critical operations
- **UUID Primary Keys**: For distributed scalability and security
- **Timestamp Management**: Optimized date/time fields with appropriate indexing for range queries
- **JSONB for Flexible Data**: Used for extensible attributes while maintaining query performance
- **Constraint Management**: Check constraints and validation rules to ensure data integrity
- **Concurrency Control**: Row-level locking strategies for high-traffic operations

## 1. User Management System

### Users Table

```sql
CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    password_hash TEXT NOT NULL,
    full_name TEXT NOT NULL,
    phone_number TEXT,
    user_type TEXT NOT NULL CHECK (user_type IN ('admin', 'organizer', 'designer', 'model', 'sponsor', 'attendee', 'staff')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('active', 'inactive', 'pending', 'suspended')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    last_login TIMESTAMPTZ,
    profile_image_url TEXT,
    email_verified BOOLEAN NOT NULL DEFAULT false,
    phone_verified BOOLEAN NOT NULL DEFAULT false,
    two_factor_enabled BOOLEAN NOT NULL DEFAULT false,
    login_attempts INTEGER NOT NULL DEFAULT 0,
    reset_token TEXT,
    reset_token_expires_at TIMESTAMPTZ
);

-- Indexes for user lookups and authentication
CREATE INDEX idx_users_email ON public.users (email);
CREATE INDEX idx_users_user_type ON public.users (user_type);
CREATE INDEX idx_users_status ON public.users (status);
CREATE INDEX idx_users_created_at ON public.users (created_at);
CREATE INDEX idx_users_last_login ON public.users (last_login);

-- Full text search index for user search
CREATE INDEX idx_users_full_name_trgm ON public.users USING GIN (full_name gin_trgm_ops);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.users
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### User Profiles Table

```sql
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    bio TEXT,
    social_links JSONB DEFAULT '{}'::jsonb,
    company TEXT,
    position TEXT,
    location TEXT,
    website TEXT,
    interests TEXT[],
    preferences JSONB DEFAULT '{}'::jsonb,
    notification_settings JSONB DEFAULT '{"email": true, "sms": false, "push": true}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(user_id)
);

-- Indexes for profile lookups
CREATE INDEX idx_user_profiles_user_id ON public.user_profiles (user_id);
CREATE INDEX idx_user_profiles_location ON public.user_profiles (location);
CREATE INDEX idx_user_profiles_interests ON public.user_profiles USING GIN (interests);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.user_profiles
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### User Roles and Permissions

```sql
CREATE TABLE public.roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    resource TEXT NOT NULL,
    action TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(resource, action)
);

CREATE TABLE public.role_permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_id UUID NOT NULL REFERENCES public.roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES public.permissions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(role_id, permission_id)
);

CREATE TABLE public.user_roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES public.roles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(user_id, role_id)
);

-- Indexes for role and permission lookups
CREATE INDEX idx_role_permissions_role_id ON public.role_permissions (role_id);
CREATE INDEX idx_role_permissions_permission_id ON public.role_permissions (permission_id);
CREATE INDEX idx_user_roles_user_id ON public.user_roles (user_id);
CREATE INDEX idx_user_roles_role_id ON public.user_roles (role_id);
```

## 2. Event Management System

### Events Table

```sql
CREATE TABLE public.events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organizer_id UUID NOT NULL REFERENCES public.users(id) ON DELETE RESTRICT,
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    short_description TEXT,
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    venue_id UUID REFERENCES public.venues(id) ON DELETE RESTRICT,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'cancelled', 'completed', 'postponed')),
    capacity INTEGER,
    current_attendance INTEGER DEFAULT 0,
    type TEXT NOT NULL CHECK (type IN ('fashion_show', 'exhibition', 'workshop', 'conference', 'party', 'networking')),
    category TEXT,
    tags TEXT[],
    featured BOOLEAN DEFAULT false,
    featured_image_url TEXT,
    gallery_images JSONB DEFAULT '[]'::jsonb,
    ticket_url TEXT,
    external_url TEXT,
    seo_title TEXT,
    seo_description TEXT,
    seo_keywords TEXT[],
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    published_at TIMESTAMPTZ,
    meta_data JSONB DEFAULT '{}'::jsonb,
    CONSTRAINT check_dates CHECK (end_date > start_date),
    CONSTRAINT check_attendance CHECK (current_attendance <= capacity OR capacity IS NULL)
);

-- Partitioning by date range for large event tables
CREATE TABLE public.events_current PARTITION OF public.events
    FOR VALUES FROM (NOW() - INTERVAL '1 month') TO (NOW() + INTERVAL '1 year');
    
CREATE TABLE public.events_past PARTITION OF public.events
    FOR VALUES FROM (MINVALUE) TO (NOW() - INTERVAL '1 month');
    
CREATE TABLE public.events_future PARTITION OF public.events
    FOR VALUES FROM (NOW() + INTERVAL '1 year') TO (MAXVALUE);

-- Indexes for event lookups
CREATE INDEX idx_events_organizer_id ON public.events (organizer_id);
CREATE INDEX idx_events_venue_id ON public.events (venue_id);
CREATE INDEX idx_events_status ON public.events (status);
CREATE INDEX idx_events_type ON public.events (type);
CREATE INDEX idx_events_featured ON public.events (featured) WHERE featured = true;
CREATE INDEX idx_events_date_range ON public.events (start_date, end_date);
CREATE INDEX idx_events_tags ON public.events USING GIN (tags);
CREATE INDEX idx_events_slug ON public.events (slug);

-- Full text search index for event search
CREATE INDEX idx_events_fts ON public.events USING GIN (
    to_tsvector('english', coalesce(title, '') || ' ' || 
    coalesce(description, '') || ' ' || 
    coalesce(short_description, ''))
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.events
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### Event Schedules Table

```sql
CREATE TABLE public.event_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    speaker_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    location TEXT,
    type TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    is_break BOOLEAN DEFAULT false,
    meta_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT check_schedule_times CHECK (end_time > start_time)
);

-- Indexes for schedule lookups
CREATE INDEX idx_event_schedules_event_id ON public.event_schedules (event_id);
CREATE INDEX idx_event_schedules_speaker_id ON public.event_schedules (speaker_id);
CREATE INDEX idx_event_schedules_start_time ON public.event_schedules (start_time);
CREATE INDEX idx_event_schedules_order_index ON public.event_schedules (order_index);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.event_schedules
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### Event Categories Table

```sql
CREATE TABLE public.event_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES public.event_categories(id) ON DELETE SET NULL,
    icon TEXT,
    color TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for category lookups
CREATE INDEX idx_event_categories_parent_id ON public.event_categories (parent_id);
CREATE INDEX idx_event_categories_slug ON public.event_categories (slug);
CREATE INDEX idx_event_categories_order_index ON public.event_categories (order_index);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.event_categories
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### Event-Category Junction Table

```sql
CREATE TABLE public.event_category_mappings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES public.event_categories(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(event_id, category_id)
);

-- Indexes for junction table lookups
CREATE INDEX idx_event_category_mappings_event_id ON public.event_category_mappings (event_id);
CREATE INDEX idx_event_category_mappings_category_id ON public.event_category_mappings (category_id);
```

## 3. Venue Management

### Venues Table

```sql
CREATE TABLE public.venues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT,
    country TEXT NOT NULL,
    postal_code TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    capacity INTEGER,
    floor_plan_url TEXT,
    images JSONB DEFAULT '[]'::jsonb,
    facilities JSONB DEFAULT '{}'::jsonb,
    accessibility_features TEXT[],
    contact_name TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    website TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'under_maintenance')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    meta_data JSONB DEFAULT '{}'::jsonb
);

-- Indexes for venue lookups
CREATE INDEX idx_venues_slug ON public.venues (slug);
CREATE INDEX idx_venues_city_country ON public.venues (city, country);
CREATE INDEX idx_venues_status ON public.venues (status);
CREATE INDEX idx_venues_capacity ON public.venues (capacity);

-- Spatial index for location-based queries
CREATE INDEX idx_venues_location ON public.venues USING GIST (
    ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- Full text search index for venue search
CREATE INDEX idx_venues_fts ON public.venues USING GIN (
    to_tsvector('english', coalesce(name, '') || ' ' || 
    coalesce(description, '') || ' ' || 
    coalesce(address, '') || ' ' || 
    coalesce(city, '') || ' ' || 
    coalesce(country, ''))
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.venues
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### Seating Sections Table

```sql
CREATE TABLE public.venue_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID NOT NULL REFERENCES public.venues(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    capacity INTEGER NOT NULL,
    section_type TEXT NOT NULL CHECK (section_type IN ('general', 'vip', 'premium', 'backstage', 'press')),
    price_multiplier DECIMAL(5, 2) DEFAULT 1.0,
    coordinates JSONB, -- For visual representation on floor plan
    accessibility BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(venue_id, name)
);

-- Indexes for section lookups
CREATE INDEX idx_venue_sections_venue_id ON public.venue_sections (venue_id);
CREATE INDEX idx_venue_sections_section_type ON public.venue_sections (section_type);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.venue_sections
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### Seats Table

```sql
CREATE TABLE public.venue_seats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_id UUID NOT NULL REFERENCES public.venue_sections(id) ON DELETE CASCADE,
    row_name TEXT,
    seat_number TEXT,
    status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'reserved', 'sold', 'blocked', 'maintenance')),
    coordinates JSONB, -- For visual representation on floor plan
    accessibility_features TEXT[],
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(section_id, row_name, seat_number)
);

-- Indexes for seat lookups
CREATE INDEX idx_venue_seats_section_id ON public.venue_seats (section_id);
CREATE INDEX idx_venue_seats_status ON public.venue_seats (status);
CREATE INDEX idx_venue_seats_row_seat ON public.venue_seats (row_name, seat_number);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.venue_seats
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

## 4. Content Management System

### Pages Table

```sql
CREATE TABLE public.pages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    meta_description TEXT,
    meta_keywords TEXT[],
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    layout TEXT NOT NULL DEFAULT 'default',
    author_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INTEGER NOT NULL DEFAULT 1,
    is_homepage BOOLEAN DEFAULT false,
    requires_auth BOOLEAN DEFAULT false,
    cache_ttl INTEGER DEFAULT 3600, -- Cache time-to-live in seconds
    seo_image_url TEXT,
    structured_data JSONB DEFAULT '{}'::jsonb
);

-- Indexes for page lookups
CREATE INDEX idx_pages_slug ON public.pages (slug);
CREATE INDEX idx_pages_status ON public.pages (status);
CREATE INDEX idx_pages_author_id ON public.pages (author_id);
CREATE INDEX idx_pages_published_at ON public.pages (published_at);
CREATE INDEX idx_pages_is_homepage ON public.pages (is_homepage) WHERE is_homepage = true;

-- Full text search index for page search
CREATE INDEX idx_pages_fts ON public.pages USING GIN (
    to_tsvector('english', coalesce(title, '') || ' ' || 
    coalesce(meta_description, ''))
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.pages
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### Content Blocks Table

```sql
CREATE TABLE public.content_blocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    page_id UUID NOT NULL REFERENCES public.pages(id) ON DELETE CASCADE,
    block_type TEXT NOT NULL CHECK (block_type IN ('hero', 'text', 'image', 'gallery', 'video', 'cta', 'testimonial', 'feature', 'event_list', 'designer_list', 'sponsor_list', 'custom')),
    title TEXT,
    content TEXT,
    content_json JSONB DEFAULT '{}'::jsonb,
    order_index INTEGER NOT NULL DEFAULT 0,
    settings JSONB DEFAULT '{}'::jsonb,
    styles JSONB DEFAULT '{}'::jsonb,
    visibility_rules JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INTEGER NOT NULL DEFAULT 1
);

-- Indexes for content block lookups
CREATE INDEX idx_content_blocks_page_id ON public.content_blocks (page_id);
CREATE INDEX idx_content_blocks_block_type ON public.content_blocks (block_type);
CREATE INDEX idx_content_blocks_order_index ON public.content_blocks (order_index);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.content_blocks
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

### Page Versions Table

```sql
CREATE TABLE public.page_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    page_id UUID NOT NULL REFERENCES public.pages(id) ON DELETE CASCADE,
    version INTEGER NOT NULL,
    title TEXT NOT NULL,
    meta_description TEXT,
    meta_keywords TEXT[],
    layout TEXT NOT NULL,
    content_snapshot JSONB NOT NULL, -- Snapshot of all content blocks
    author_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    change_summary TEXT,
    UNIQUE(page_id, version)
);

-- Indexes for page version lookups
CREATE INDEX idx_page_versions_page_id ON public.page_versions (page_id);
CREATE INDEX idx_page_versions_version ON public.page_versions (version);
CREATE INDEX idx_page_versions_author_id ON public.page_versions (author_id);
```

### Media Library Table

```sql
CREATE TABLE public.media_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    file_name TEXT NOT NULL,
    file_type TEXT NOT NULL,
    mime_type TEXT NOT NULL,
    file_size INTEGER NOT NULL,
    url TEXT NOT NULL,
    thumbnail_url TEXT,
    alt_text TEXT,
    caption TEXT,
    width INTEGER,
    height INTEGER,
    duration INTEGER, -- For video/audio in seconds
    uploaded_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    folder_path TEXT DEFAULT '/',
    tags TEXT[],
    meta_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for media lookups
CREATE INDEX idx_media_items_file_type ON public.media_items (file_type);
CREATE INDEX idx_media_items_uploaded_by ON public.media_items (uploaded_by);
CREATE INDEX idx_media_items_folder_path ON public.media_items (folder_path);
CREATE INDEX idx_media_items_tags ON public.media_items USING GIN (tags);

-- Full text search index for media search
CREATE INDEX idx_media_items_fts ON public.media_items USING GIN (
    to_tsvector('english', coalesce(file_name, '') || ' ' || 
    coalesce(alt_text, '') || ' ' || 
    coalesce(caption, ''))
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.media_items
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

## Utility Functions

```sql
-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to generate slugs
CREATE OR REPLACE FUNCTION public.generate_slug(input_text TEXT)
RETURNS TEXT AS $$
DECLARE
    slug TEXT;
BEGIN
    -- Convert to lowercase, replace spaces with hyphens, remove special characters
    slug := lower(input_text);
    slug := regexp_replace(slug, '[^a-z0-9\s]', '', 'g');
    slug := regexp_replace(slug, '\s+', '-', 'g');
    RETURN slug;
END;
$$ LANGUAGE plpgsql;
```

## Performance Optimization Strategies

### Indexing Strategy

1. **Primary Keys**: All tables use UUID primary keys for scalability and security
2. **Foreign Keys**: All foreign key relationships are indexed
3. **Composite Indexes**: Used for frequently combined query conditions
4. **Full-Text Search**: GIN indexes for text search capabilities
5. **Partial Indexes**: Used for filtered queries (e.g., featured events)
6. **Expression Indexes**: For complex query conditions

### Partitioning Strategy

1. **Events Table**: Partitioned by date range for efficient historical vs. current event queries
2. **Large Tables**: Consider partitioning for tickets, orders, and user activity logs

### Caching Recommendations

1. **Page Content**: Cache page content with configurable TTL
2. **Event Listings**: Cache popular event listings
3. **User Profiles**: Cache frequently accessed user profiles
4. **Venue Information**: Cache venue details and seating arrangements

### Query Optimization

1. **Denormalization**: Strategic denormalization for frequently joined data
2. **JSONB for Flexibility**: Use JSONB for extensible attributes while maintaining query performance
3. **Materialized Views**: For complex reporting queries
4. **Efficient Pagination**: Using keyset pagination instead of offset-based pagination

## Next Steps

This schema provides the foundation for the core components of the Fashionistas Event Platform. The next phases should include:

1. **Ticketing and Payment System**: Tables for ticket types, orders, payments, and invoices
2. **Designer and Collection Management**: Tables for designers, collections, and fashion items
3. **Sponsorship System**: Tables for sponsors, sponsorship packages, and sponsor assets
4. **Marketing and Analytics**: Tables for campaigns, analytics, and engagement tracking
5. **Row Level Security (RLS) Policies**: For secure data access
6. **Database Functions and Triggers**: For automated business logic
7. **API Endpoints**: REST and GraphQL endpoints for frontend integration 

# Phase 2A: Ticketing System Core for Fashionistas Event Platform

Below is the SQL schema for the core ticketing system, designed with high performance, concurrency, and scalability in mind:

```sql
-- =============================================
-- TICKET TYPES TABLE
-- =============================================
CREATE TABLE public.ticket_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    base_price DECIMAL(12, 2) NOT NULL CHECK (base_price >= 0),
    features JSONB DEFAULT '[]'::jsonb,
    max_quantity_per_order INTEGER,
    total_capacity INTEGER,
    remaining_capacity INTEGER,
    sale_start_date TIMESTAMPTZ NOT NULL,
    sale_end_date TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    tier TEXT NOT NULL CHECK (tier IN ('general', 'premium', 'vip', 'exclusive')),
    seating_section_id UUID REFERENCES public.venue_sections(id) ON DELETE SET NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    version INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT check_ticket_dates CHECK (sale_end_date > sale_start_date),
    CONSTRAINT check_ticket_capacity CHECK (remaining_capacity <= total_capacity)
);

-- Indexes for ticket type lookups
CREATE INDEX idx_ticket_types_event_id ON public.ticket_types (event_id);
CREATE INDEX idx_ticket_types_tier ON public.ticket_types (tier);
CREATE INDEX idx_ticket_types_active_featured ON public.ticket_types (is_active, is_featured) WHERE is_active = true AND is_featured = true;
CREATE INDEX idx_ticket_types_sale_dates ON public.ticket_types (sale_start_date, sale_end_date);
CREATE INDEX idx_ticket_types_seating_section_id ON public.ticket_types (seating_section_id);

-- Trigger for optimistic locking and updated_at timestamp
CREATE TRIGGER ticket_types_update_trigger
BEFORE UPDATE ON public.ticket_types
FOR EACH ROW
EXECUTE FUNCTION public.update_ticket_type_version();

-- Function for optimistic locking
CREATE OR REPLACE FUNCTION public.update_ticket_type_version()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.version <> NEW.version THEN
        RAISE EXCEPTION 'Concurrent update detected for ticket type %', OLD.id;
    END IF;
    NEW.version := OLD.version + 1;
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- ORDERS TABLE
-- =============================================
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE RESTRICT,
    status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'completed', 'cancelled', 'refunded', 'failed')),
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(12, 2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    currency TEXT NOT NULL DEFAULT 'USD',
    payment_intent_id TEXT,
    payment_method TEXT,
    billing_email TEXT NOT NULL,
    billing_name TEXT NOT NULL,
    billing_phone TEXT,
    billing_address JSONB,
    notes TEXT,
    ip_address TEXT,
    user_agent TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    refunded_at TIMESTAMPTZ,
    expiration_time TIMESTAMPTZ
);

-- Partitioning for orders table by creation date
CREATE TABLE public.orders_current_month PARTITION OF public.orders
    FOR VALUES FROM (date_trunc('month', CURRENT_DATE)) TO (date_trunc('month', CURRENT_DATE) + INTERVAL '1 month');
    
CREATE TABLE public.orders_previous_month PARTITION OF public.orders
    FOR VALUES FROM (date_trunc('month', CURRENT_DATE) - INTERVAL '1 month') TO (date_trunc('month', CURRENT_DATE));
    
CREATE TABLE public.orders_archive PARTITION OF public.orders
    FOR VALUES FROM (MINVALUE) TO (date_trunc('month', CURRENT_DATE) - INTERVAL '1 month');

-- Indexes for order lookups
CREATE INDEX idx_orders_user_id ON public.orders (user_id);
CREATE INDEX idx_orders_status ON public.orders (status);
CREATE INDEX idx_orders_created_at ON public.orders (created_at);
CREATE INDEX idx_orders_payment_intent_id ON public.orders (payment_intent_id) WHERE payment_intent_id IS NOT NULL;
CREATE INDEX idx_orders_completed_at ON public.orders (completed_at) WHERE completed_at IS NOT NULL;
CREATE INDEX idx_orders_expiration_time ON public.orders (expiration_time) WHERE expiration_time IS NOT NULL;

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.orders
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- ORDER ITEMS TABLE
-- =============================================
CREATE TABLE public.order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
    ticket_type_id UUID NOT NULL REFERENCES public.ticket_types(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12, 2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(12, 2) NOT NULL CHECK (subtotal >= 0),
    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
    final_price DECIMAL(12, 2) NOT NULL CHECK (final_price >= 0),
    discount_code_id UUID REFERENCES public.discount_codes(id) ON DELETE SET NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT check_price_calculation CHECK (final_price = subtotal - discount_amount)
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
-- DISCOUNT CODES TABLE
-- =============================================
CREATE TABLE public.discount_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT UNIQUE NOT NULL,
    description TEXT,
    discount_type TEXT NOT NULL CHECK (discount_type IN ('percentage', 'fixed_amount')),
    discount_value DECIMAL(12, 2) NOT NULL CHECK (discount_value >= 0),
    minimum_order_amount DECIMAL(12, 2) DEFAULT 0,
    maximum_discount_amount DECIMAL(12, 2),
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    usage_limit INTEGER,
    current_usage INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    is_one_time_use BOOLEAN DEFAULT false,
    applies_to_all_events BOOLEAN DEFAULT false,
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT check_discount_dates CHECK (end_date > start_date),
    CONSTRAINT check_discount_usage CHECK (current_usage <= usage_limit OR usage_limit IS NULL),
    CONSTRAINT check_percentage_discount CHECK (
        (discount_type = 'percentage' AND discount_value <= 100) OR
        (discount_type != 'percentage')
    )
);

-- Indexes for discount code lookups
CREATE INDEX idx_discount_codes_code ON public.discount_codes (code);
CREATE INDEX idx_discount_codes_active ON public.discount_codes (is_active) WHERE is_active = true;
CREATE INDEX idx_discount_codes_dates ON public.discount_codes (start_date, end_date);
CREATE INDEX idx_discount_codes_usage ON public.discount_codes (current_usage, usage_limit) WHERE usage_limit IS NOT NULL;

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.discount_codes
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- DISCOUNT CODE EVENT MAPPINGS (Junction table for event-specific discount codes)
-- =============================================
CREATE TABLE public.discount_code_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    discount_code_id UUID NOT NULL REFERENCES public.discount_codes(id) ON DELETE CASCADE,
    event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(discount_code_id, event_id)
);

-- Indexes for discount code event mappings
CREATE INDEX idx_discount_code_events_discount_code_id ON public.discount_code_events (discount_code_id);
CREATE INDEX idx_discount_code_events_event_id ON public.discount_code_events (event_id);

-- =============================================
-- DISCOUNT CODE TICKET TYPE MAPPINGS (Junction table for ticket-type-specific discount codes)
-- =============================================
CREATE TABLE public.discount_code_ticket_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    discount_code_id UUID NOT NULL REFERENCES public.discount_codes(id) ON DELETE CASCADE,
    ticket_type_id UUID NOT NULL REFERENCES public.ticket_types(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(discount_code_id, ticket_type_id)
);

-- Indexes for discount code ticket type mappings
CREATE INDEX idx_discount_code_ticket_types_discount_code_id ON public.discount_code_ticket_types (discount_code_id);
CREATE INDEX idx_discount_code_ticket_types_ticket_type_id ON public.discount_code_ticket_types (ticket_type_id);

-- =============================================
-- TICKET INVENTORY LOCKS (For handling concurrent ticket purchases)
-- =============================================
CREATE TABLE public.ticket_inventory_locks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_type_id UUID NOT NULL REFERENCES public.ticket_types(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    session_id TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(ticket_type_id, order_id) WHERE order_id IS NOT NULL
);

-- Indexes for ticket inventory locks
CREATE INDEX idx_ticket_inventory_locks_ticket_type_id ON public.ticket_inventory_locks (ticket_type_id);
CREATE INDEX idx_ticket_inventory_locks_order_id ON public.ticket_inventory_locks (order_id) WHERE order_id IS NOT NULL;
CREATE INDEX idx_ticket_inventory_locks_session_id ON public.ticket_inventory_locks (session_id);
CREATE INDEX idx_ticket_inventory_locks_expires_at ON public.ticket_inventory_locks (expires_at);
```

## ERD Relationships

```
ticket_types
  ↑ belongs_to events
  ↑ belongs_to venue_sections (optional)
  ↓ has_many order_items
  ↓ has_many discount_code_ticket_types
  ↓ has_many ticket_inventory_locks

orders
  ↑ belongs_to users
  ↓ has_many order_items
  ↓ has_many ticket_inventory_locks

order_items
  ↑ belongs_to orders
  ↑ belongs_to ticket_types
  ↑ belongs_to discount_codes (optional)

discount_codes
  ↓ has_many order_items
  ↓ has_many discount_code_events
  ↓ has_many discount_code_ticket_types
  ↑ belongs_to users (created_by)

discount_code_events (junction)
  ↑ belongs_to discount_codes
  ↑ belongs_to events

discount_code_ticket_types (junction)
  ↑ belongs_to discount_codes
  ↑ belongs_to ticket_types

ticket_inventory_locks
  ↑ belongs_to ticket_types
  ↑ belongs_to orders (optional)
```

## Indexing Strategy for High-Traffic Scenarios

1. **Composite Indexes for Common Query Patterns**:
   - `(is_active, is_featured)` on ticket_types for featured ticket display
   - `(sale_start_date, sale_end_date)` for date range queries
   - `(start_date, end_date)` on discount_codes for active promotions

2. **Partial Indexes for Filtered Queries**:
   - Active and featured tickets: `WHERE is_active = true AND is_featured = true`
   - Orders with payment intents: `WHERE payment_intent_id IS NOT NULL`
   - Completed orders: `WHERE completed_at IS NOT NULL`

3. **Table Partitioning for Orders**:
   - Current month partition for active orders
   - Previous month partition for recent history
   - Archive partition for older orders
   - Improves query performance by limiting scan range

4. **Optimistic Locking for Ticket Types**:
   - Version column to prevent concurrent updates
   - Custom trigger function to enforce version checking

5. **Inventory Lock Table**:
   - Dedicated table for managing concurrent ticket purchases
   - Short-lived locks with expiration times
   - Indexed by session_id for quick lookup

## Common Ticketing Operations (Sample Queries)

### 1. Find Available Tickets for an Event

```sql
SELECT 
    tt.*,
    (tt.total_capacity - tt.remaining_capacity) AS sold_count,
    COALESCE(
        (SELECT SUM(til.quantity) 
         FROM ticket_inventory_locks til 
         WHERE til.ticket_type_id = tt.id AND til.expires_at > NOW()),
        0
    ) AS reserved_count
FROM 
    ticket_types tt
WHERE 
    tt.event_id = '00000000-0000-0000-0000-000000000000'
    AND tt.is_active = true
    AND tt.sale_start_date <= NOW()
    AND tt.sale_end_date > NOW()
    AND tt.remaining_capacity > 0;
```

### 2. Create a Temporary Inventory Lock During Checkout

```sql
INSERT INTO ticket_inventory_locks (
    ticket_type_id, quantity, session_id, expires_at
)
VALUES (
    '00000000-0000-0000-0000-000000000000', -- ticket_type_id
    2, -- quantity
    'session_12345', -- session_id
    NOW() + INTERVAL '15 minutes' -- expires_at
)
RETURNING id;
```

### 3. Apply a Discount Code to an Order

```sql
WITH discount_info AS (
    SELECT 
        dc.id,
        dc.discount_type,
        dc.discount_value,
        dc.maximum_discount_amount
    FROM 
        discount_codes dc
    WHERE 
        dc.code = 'SUMMER2024'
        AND dc.is_active = true
        AND dc.start_date <= NOW()
        AND dc.end_date > NOW()
        AND (dc.usage_limit IS NULL OR dc.current_usage < dc.usage_limit)
)
UPDATE order_items oi
SET 
    discount_code_id = discount_info.id,
    discount_amount = CASE 
        WHEN discount_info.discount_type = 'percentage' THEN 
            LEAST(
                oi.subtotal * (discount_info.discount_value / 100),
                COALESCE(discount_info.maximum_discount_amount, oi.subtotal)
            )
        ELSE 
            LEAST(
                discount_info.discount_value,
                oi.subtotal
            )
    END,
    final_price = oi.subtotal - CASE 
        WHEN discount_info.discount_type = 'percentage' THEN 
            LEAST(
                oi.subtotal * (discount_info.discount_value / 100),
                COALESCE(discount_info.maximum_discount_amount, oi.subtotal)
            )
        ELSE 
            LEAST(
                discount_info.discount_value,
                oi.subtotal
            )
    END
FROM 
    discount_info
WHERE 
    oi.order_id = '00000000-0000-0000-0000-000000000000'
RETURNING oi.*;
```

### 4. Complete an Order and Update Ticket Inventory

```sql
BEGIN;

-- Update order status
UPDATE orders
SET 
    status = 'completed',
    completed_at = NOW(),
    updated_at = NOW()
WHERE 
    id = '00000000-0000-0000-0000-000000000000'
    AND status = 'processing';

-- Update ticket type inventory
UPDATE ticket_types tt
SET 
    remaining_capacity = tt.remaining_capacity - oi.quantity,
    updated_at = NOW()
FROM 
    order_items oi
WHERE 
    oi.order_id = '00000000-0000-0000-0000-000000000000'
    AND tt.id = oi.ticket_type_id;

-- Update discount code usage if applicable
UPDATE discount_codes dc
SET 
    current_usage = dc.current_usage + 1,
    updated_at = NOW()
FROM 
    order_items oi
WHERE 
    oi.order_id = '00000000-0000-0000-0000-000000000000'
    AND oi.discount_code_id IS NOT NULL
    AND dc.id = oi.discount_code_id;

-- Remove inventory locks
DELETE FROM ticket_inventory_locks
WHERE order_id = '00000000-0000-0000-0000-000000000000';

COMMIT;
```

## Performance Optimization Notes

1. **Concurrency Control**:
   - Optimistic locking for ticket inventory updates
   - Short-lived inventory locks (15 minutes) to prevent overselling
   - Transaction isolation level READ COMMITTED for order processing

2. **Inventory Management**:
   - Pre-calculated remaining_capacity field for fast availability checks
   - Separate inventory locks table to handle concurrent checkout processes
   - Periodic cleanup of expired locks via scheduled function

3. **Order Processing**:
   - Table partitioning by date for efficient order history queries
   - Composite indexes for common order lookup patterns
   - Denormalized order totals for fast financial reporting

4. **Discount Code Optimization**:
   - Junction tables for flexible discount code application (event or ticket type specific)
   - Indexed code lookups for fast validation during checkout
   - Pre-calculated usage counts to avoid expensive aggregation queries

5. **Query Optimization**:
   - Use of CTEs (Common Table Expressions) for complex discount calculations
   - Partial indexes for filtered queries (active discounts, featured tickets)
   - Careful transaction management to minimize lock contention

6. **Scaling Considerations**:
   - Horizontal scaling through UUID primary keys
   - Partitioning strategy for orders table to support archiving
   - Efficient date range queries through composite indexes

This ticketing system design provides a solid foundation for high-volume ticket sales while maintaining data integrity and performance. The schema includes mechanisms for handling concurrent purchases, flexible discount application, and efficient inventory management.

# Phase 2B: Designer and Collection Management System

Below is the SQL schema for the Designer and Collection Management System, designed to showcase fashion designers and their collections with high performance and flexibility:

```sql
-- =============================================
-- DESIGNERS TABLE
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

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.designers
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- Trigger for slug generation
CREATE TRIGGER set_designer_slug
BEFORE INSERT ON public.designers
FOR EACH ROW
EXECUTE FUNCTION public.set_designer_slug();

-- Function for slug generation
CREATE OR REPLACE FUNCTION public.set_designer_slug()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.slug IS NULL OR NEW.slug = '' THEN
        NEW.slug := public.generate_slug(NEW.name);
        
        -- Check for duplicates and append a number if needed
        DECLARE
            base_slug TEXT := NEW.slug;
            counter INTEGER := 1;
        BEGIN
            WHILE EXISTS (SELECT 1 FROM public.designers WHERE slug = NEW.slug) LOOP
                NEW.slug := base_slug || '-' || counter;
                counter := counter + 1;
            END LOOP;
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- COLLECTIONS TABLE
-- =============================================
CREATE TABLE public.collections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    designer_id UUID NOT NULL REFERENCES public.designers(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    season TEXT CHECK (season IN ('spring', 'summer', 'fall', 'winter', 'resort', 'pre-fall', 'bridal', 'couture', 'other')),
    year INTEGER,
    release_date TIMESTAMPTZ,
    is_featured BOOLEAN DEFAULT false,
    status TEXT NOT NULL CHECK (status IN ('draft', 'published', 'archived')),
    cover_image_url TEXT,
    inspiration TEXT,
    color_palette JSONB DEFAULT '[]'::jsonb,
    materials JSONB DEFAULT '[]'::jsonb,
    show_notes TEXT,
    event_id UUID REFERENCES public.events(id) ON DELETE SET NULL,
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

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.collections
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- Trigger for slug generation
CREATE TRIGGER set_collection_slug
BEFORE INSERT ON public.collections
FOR EACH ROW
EXECUTE FUNCTION public.set_collection_slug();

-- Function for collection slug generation
CREATE OR REPLACE FUNCTION public.set_collection_slug()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.slug IS NULL OR NEW.slug = '' THEN
        -- Get designer name for more descriptive slug
        DECLARE
            designer_name TEXT;
        BEGIN
            SELECT name INTO designer_name FROM public.designers WHERE id = NEW.designer_id;
            NEW.slug := public.generate_slug(designer_name || '-' || NEW.name || '-' || COALESCE(NEW.season, '') || '-' || COALESCE(NEW.year::TEXT, ''));
            
            -- Check for duplicates and append a number if needed
            DECLARE
                base_slug TEXT := NEW.slug;
                counter INTEGER := 1;
            BEGIN
                WHILE EXISTS (SELECT 1 FROM public.collections WHERE slug = NEW.slug) LOOP
                    NEW.slug := base_slug || '-' || counter;
                    counter := counter + 1;
                END LOOP;
            END;
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FASHION ITEMS TABLE
-- =============================================
CREATE TABLE public.fashion_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collection_id UUID NOT NULL REFERENCES public.collections(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    item_type TEXT NOT NULL CHECK (item_type IN ('dress', 'top', 'bottom', 'outerwear', 'footwear', 'accessory', 'swimwear', 'activewear', 'other')),
    materials JSONB DEFAULT '[]'::jsonb,
    colors JSONB DEFAULT '[]'::jsonb,
    sizes JSONB DEFAULT '[]'::jsonb,
    price_range JSONB DEFAULT '{"min": null, "max": null}'::jsonb,
    is_featured BOOLEAN DEFAULT false,
    display_order INTEGER,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for fashion item lookups
CREATE INDEX idx_fashion_items_collection_id ON public.fashion_items (collection_id);
CREATE INDEX idx_fashion_items_item_type ON public.fashion_items (item_type);
CREATE INDEX idx_fashion_items_featured ON public.fashion_items (is_featured) WHERE is_featured = true;
CREATE INDEX idx_fashion_items_display_order ON public.fashion_items (collection_id, display_order);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.fashion_items
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- FASHION ITEM IMAGES TABLE
-- =============================================
CREATE TABLE public.fashion_item_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fashion_item_id UUID NOT NULL REFERENCES public.fashion_items(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text TEXT,
    display_order INTEGER NOT NULL DEFAULT 0,
    is_primary BOOLEAN DEFAULT false,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for fashion item image lookups
CREATE INDEX idx_fashion_item_images_fashion_item_id ON public.fashion_item_images (fashion_item_id);
CREATE INDEX idx_fashion_item_images_primary ON public.fashion_item_images (fashion_item_id, is_primary) WHERE is_primary = true;
CREATE INDEX idx_fashion_item_images_display_order ON public.fashion_item_images (fashion_item_id, display_order);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.fashion_item_images
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- Trigger to ensure only one primary image per fashion item
CREATE TRIGGER ensure_single_primary_image
BEFORE INSERT OR UPDATE ON public.fashion_item_images
FOR EACH ROW
WHEN (NEW.is_primary = true)
EXECUTE FUNCTION public.ensure_single_primary_image();

-- Function to ensure only one primary image per fashion item
CREATE OR REPLACE FUNCTION public.ensure_single_primary_image()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.fashion_item_images
    SET is_primary = false
    WHERE fashion_item_id = NEW.fashion_item_id
    AND id != NEW.id
    AND is_primary = true;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- RUNWAY SHOWS TABLE
-- =============================================
CREATE TABLE public.runway_shows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collection_id UUID NOT NULL REFERENCES public.collections(id) ON DELETE CASCADE,
    event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE RESTRICT,
    venue_id UUID NOT NULL REFERENCES public.venues(id) ON DELETE RESTRICT,
    show_date TIMESTAMPTZ NOT NULL,
    duration_minutes INTEGER,
    status TEXT NOT NULL CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    capacity INTEGER,
    attendance INTEGER,
    video_url TEXT,
    livestream_url TEXT,
    notes TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for runway show lookups
CREATE INDEX idx_runway_shows_collection_id ON public.runway_shows (collection_id);
CREATE INDEX idx_runway_shows_event_id ON public.runway_shows (event_id);
CREATE INDEX idx_runway_shows_venue_id ON public.runway_shows (venue_id);
CREATE INDEX idx_runway_shows_show_date ON public.runway_shows (show_date);
CREATE INDEX idx_runway_shows_status ON public.runway_shows (status);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.runway_shows
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- RUNWAY SEGMENTS TABLE
-- =============================================
CREATE TABLE public.runway_segments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    runway_show_id UUID NOT NULL REFERENCES public.runway_shows(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    start_time TIMESTAMPTZ,
    duration_minutes INTEGER,
    segment_order INTEGER NOT NULL,
    theme TEXT,
    music TEXT,
    lighting_notes TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for runway segment lookups
CREATE INDEX idx_runway_segments_runway_show_id ON public.runway_segments (runway_show_id);
CREATE INDEX idx_runway_segments_segment_order ON public.runway_segments (runway_show_id, segment_order);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.runway_segments
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- MODELS TABLE
-- =============================================
CREATE TABLE public.models (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    agency TEXT,
    height TEXT,
    measurements JSONB,
    bio TEXT,
    profile_image_url TEXT,
    portfolio_url TEXT,
    social_media JSONB DEFAULT '{}'::jsonb,
    is_featured BOOLEAN DEFAULT false,
    status TEXT NOT NULL CHECK (status IN ('active', 'inactive')),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for model lookups
CREATE INDEX idx_models_user_id ON public.models (user_id);
CREATE INDEX idx_models_status ON public.models (status);
CREATE INDEX idx_models_featured ON public.models (is_featured) WHERE is_featured = true;
CREATE INDEX idx_models_agency ON public.models (agency);

-- Full-text search index for model search
CREATE INDEX idx_models_fts ON public.models USING GIN (
    to_tsvector('english', coalesce(name, '') || ' ' || 
    coalesce(agency, '') || ' ' || 
    coalesce(bio, ''))
);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.models
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- Trigger for slug generation
CREATE TRIGGER set_model_slug
BEFORE INSERT ON public.models
FOR EACH ROW
EXECUTE FUNCTION public.set_model_slug();

-- Function for model slug generation
CREATE OR REPLACE FUNCTION public.set_model_slug()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.slug IS NULL OR NEW.slug = '' THEN
        NEW.slug := public.generate_slug(NEW.name);
        
        -- Check for duplicates and append a number if needed
        DECLARE
            base_slug TEXT := NEW.slug;
            counter INTEGER := 1;
        BEGIN
            WHILE EXISTS (SELECT 1 FROM public.models WHERE slug = NEW.slug) LOOP
                NEW.slug := base_slug || '-' || counter;
                counter := counter + 1;
            END LOOP;
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- RUNWAY APPEARANCES TABLE (Junction between models and runway segments)
-- =============================================
CREATE TABLE public.runway_appearances (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    runway_segment_id UUID NOT NULL REFERENCES public.runway_segments(id) ON DELETE CASCADE,
    model_id UUID NOT NULL REFERENCES public.models(id) ON DELETE RESTRICT,
    fashion_item_id UUID REFERENCES public.fashion_items(id) ON DELETE SET NULL,
    appearance_order INTEGER NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(runway_segment_id, appearance_order)
);

-- Indexes for runway appearance lookups
CREATE INDEX idx_runway_appearances_runway_segment_id ON public.runway_appearances (runway_segment_id);
CREATE INDEX idx_runway_appearances_model_id ON public.runway_appearances (model_id);
CREATE INDEX idx_runway_appearances_fashion_item_id ON public.runway_appearances (fashion_item_id);
CREATE INDEX idx_runway_appearances_appearance_order ON public.runway_appearances (runway_segment_id, appearance_order);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.runway_appearances
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- DESIGNER COLLABORATIONS TABLE
-- =============================================
CREATE TABLE public.designer_collaborations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    start_date TIMESTAMPTZ,
    end_date TIMESTAMPTZ,
    status TEXT NOT NULL CHECK (status IN ('planned', 'active', 'completed', 'cancelled')),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for designer collaboration lookups
CREATE INDEX idx_designer_collaborations_status ON public.designer_collaborations (status);
CREATE INDEX idx_designer_collaborations_dates ON public.designer_collaborations (start_date, end_date);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.designer_collaborations
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =============================================
-- DESIGNER COLLABORATION PARTICIPANTS (Junction table)
-- =============================================
CREATE TABLE public.designer_collaboration_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    collaboration_id UUID NOT NULL REFERENCES public.designer_collaborations(id) ON DELETE CASCADE,
    designer_id UUID NOT NULL REFERENCES public.designers(id) ON DELETE CASCADE,
    role TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(collaboration_id, designer_id)
);

-- Indexes for designer collaboration participant lookups
CREATE INDEX idx_designer_collaboration_participants_collaboration_id ON public.designer_collaboration_participants (collaboration_id);
CREATE INDEX idx_designer_collaboration_participants_designer_id ON public.designer_collaboration_participants (designer_id);

-- =============================================
-- DESIGNER ANALYTICS TABLE
-- =============================================
CREATE TABLE public.designer_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    designer_id UUID NOT NULL REFERENCES public.designers(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    profile_views INTEGER DEFAULT 0,
    collection_views JSONB DEFAULT '{}'::jsonb,
    item_views JSONB DEFAULT '{}'::jsonb,
    favorites INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    click_throughs INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(designer_id, date)
);

-- Indexes for designer analytics lookups
CREATE INDEX idx_designer_analytics_designer_id ON public.designer_analytics (designer_id);
CREATE INDEX idx_designer_analytics_date ON public.designer_analytics (date);
CREATE INDEX idx_designer_analytics_designer_date ON public.designer_analytics (designer_id, date);

-- Trigger for updated_at timestamp
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON public.designer_analytics
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();
```

## ERD Relationships

```
designers
  ↑ belongs_to users (optional)
  ↓ has_many collections
  ↓ has_many designer_collaboration_participants
  ↓ has_many designer_analytics

collections
  ↑ belongs_to designers
  ↑ belongs_to events (optional)
  ↓ has_many fashion_items
  ↓ has_many runway_shows

fashion_items
  ↑ belongs_to collections
  ↓ has_many fashion_item_images
  ↓ has_many runway_appearances

fashion_item_images
  ↑ belongs_to fashion_items

runway_shows
  ↑ belongs_to collections
  ↑ belongs_to events
  ↑ belongs_to venues
  ↓ has_many runway_segments

runway_segments
  ↑ belongs_to runway_shows
  ↓ has_many runway_appearances

models
  ↑ belongs_to users (optional)
  ↓ has_many runway_appearances

runway_appearances
  ↑ belongs_to runway_segments
  ↑ belongs_to models
  ↑ belongs_to fashion_items (optional)

designer_collaborations
  ↓ has_many designer_collaboration_participants

designer_collaboration_participants
  ↑ belongs_to designer_collaborations
  ↑ belongs_to designers

designer_analytics
  ↑ belongs_to designers
```

## Indexing Strategy for Designer and Collection Management

1. **Full-Text Search Indexes**:
   - GIN indexes on designers, collections, and models for powerful text search
   - Enables searching by name, description, specialty, and other text fields

2. **Composite Indexes for Common Query Patterns**:
   - `(collection_id, display_order)` for ordered fashion items
   - `(runway_segment_id, appearance_order)` for ordered runway appearances
   - `(season, year)` for seasonal collection filtering

3. **Partial Indexes for Filtered Queries**:
   - Featured designers: `WHERE is_featured = true`
   - Featured collections: `WHERE is_featured = true`
   - Primary images: `WHERE is_primary = true`

4. **Foreign Key Indexes**:
   - All foreign key relationships are indexed for efficient joins
   - Critical for performance in complex queries across the designer ecosystem

5. **Slug Indexes**:
   - Unique indexes on slugs for fast URL-friendly lookups
   - Automatic slug generation with collision detection

## Common Designer and Collection Operations (Sample Queries)

### 1. Find Featured Designers with Their Latest Collections

```sql
SELECT 
    d.*,
    (
        SELECT json_agg(c.*)
        FROM (
            SELECT c.*
            FROM collections c
            WHERE c.designer_id = d.id
            AND c.status = 'published'
            ORDER BY c.release_date DESC NULLS LAST
            LIMIT 3
        ) c
    ) AS latest_collections
FROM 
    designers d
WHERE 
    d.is_featured = true
    AND d.status = 'active'
ORDER BY 
    d.name;
```

### 2. Get Complete Collection Details with Items and Images

```sql
WITH collection_data AS (
    SELECT 
        c.*,
        d.name AS designer_name,
        d.brand_name AS designer_brand
    FROM 
        collections c
        JOIN designers d ON c.designer_id = d.id
    WHERE 
        c.slug = 'designer-name-collection-name-season-year'
),
fashion_items_with_images AS (
    SELECT 
        fi.*,
        (
            SELECT json_agg(fii.*)
            FROM fashion_item_images fii
            WHERE fii.fashion_item_id = fi.id
            ORDER BY fii.is_primary DESC, fii.display_order
        ) AS images
    FROM 
        fashion_items fi
    WHERE 
        fi.collection_id = (SELECT id FROM collection_data)
    ORDER BY 
        fi.display_order
)
SELECT 
    cd.*,
    (
        SELECT json_agg(fi.*)
        FROM fashion_items_with_images fi
    ) AS items,
    (
        SELECT json_agg(rs.*)
        FROM runway_shows rs
        WHERE rs.collection_id = cd.id
    ) AS runway_shows
FROM 
    collection_data cd;
```

### 3. Search for Designers and Collections

```sql
SELECT 
    'designer' AS type,
    id,
    name,
    slug,
    brand_name AS subtitle,
    profile_image_url AS image_url,
    ts_rank(
        to_tsvector('english', 
            coalesce(name, '') || ' ' || 
            coalesce(brand_name, '') || ' ' || 
            coalesce(specialty, '') || ' ' || 
            coalesce(bio, '')
        ), 
        plainto_tsquery('english', 'sustainable fashion')
    ) AS rank
FROM 
    designers
WHERE 
    status = 'active'
    AND to_tsvector('english', 
        coalesce(name, '') || ' ' || 
        coalesce(brand_name, '') || ' ' || 
        coalesce(specialty, '') || ' ' || 
        coalesce(bio, '')
    ) @@ plainto_tsquery('english', 'sustainable fashion')

UNION ALL

SELECT 
    'collection' AS type,
    c.id,
    c.name,
    c.slug,
    d.name AS subtitle,
    c.cover_image_url AS image_url,
    ts_rank(
        to_tsvector('english', 
            coalesce(c.name, '') || ' ' || 
            coalesce(c.description, '') || ' ' || 
            coalesce(c.inspiration, '') || ' ' || 
            coalesce(c.show_notes, '')
        ), 
        plainto_tsquery('english', 'sustainable fashion')
    ) AS rank
FROM 
    collections c
    JOIN designers d ON c.designer_id = d.id
WHERE 
    c.status = 'published'
    AND to_tsvector('english', 
        coalesce(c.name, '') || ' ' || 
        coalesce(c.description, '') || ' ' || 
        coalesce(c.inspiration, '') || ' ' || 
        coalesce(c.show_notes, '')
    ) @@ plainto_tsquery('english', 'sustainable fashion')

ORDER BY rank DESC
LIMIT 20;
```

### 4. Get Upcoming Runway Shows with Designer and Venue Information

```sql
SELECT 
    rs.id,
    rs.show_date,
    rs.status,
    c.name AS collection_name,
    c.season,
    c.year,
    d.name AS designer_name,
    d.brand_name,
    v.name AS venue_name,
    v.address,
    e.title AS event_title
FROM 
    runway_shows rs
    JOIN collections c ON rs.collection_id = c.id
    JOIN designers d ON c.designer_id = d.id
    JOIN venues v ON rs.venue_id = v.id
    JOIN events e ON rs.event_id = e.id
WHERE 
    rs.show_date > NOW()
    AND rs.status IN ('scheduled', 'in_progress')
ORDER BY 
    rs.show_date
LIMIT 10;
```

## Performance Optimization Notes

1. **Designer Profile Optimization**:
   - Full-text search for efficient designer discovery
   - Denormalized social media and awards data in JSONB for flexibility
   - Automatic slug generation for SEO-friendly URLs

2. **Collection Management**:
   - Hierarchical structure (designer → collection → items → images)
   - Efficient ordering system for fashion items and runway appearances
   - Season and year indexing for temporal queries

3. **Runway Show Performance**:
   - Structured segments for detailed show planning
   - Ordered appearances for precise runway sequencing
   - Efficient joins between models, items, and segments

4. **Analytics Integration**:
   - Daily analytics table for designer performance tracking
   - JSONB fields for flexible metrics storage
   - Date-based partitioning for efficient time-series queries

5. **Collaboration Support**:
   - Flexible collaboration system for multi-designer projects
   - Junction tables for many-to-many relationships
   - Role-based participation tracking

6. **Query Optimization**:
   - CTEs for complex hierarchical data retrieval
   - JSON aggregation for nested result sets
   - Efficient text search using GIN indexes and ts_rank

This Designer and Collection Management System provides a comprehensive foundation for showcasing fashion designers, their collections, and runway shows. The schema supports the complex relationships between designers, collections, fashion items, models, and runway events while maintaining high performance and flexibility.

## Phase 3: Sponsorship Management System

### SQL Schema

```sql
-- ===============================
-- SPONSORSHIP MANAGEMENT SYSTEM
-- ===============================

-- Sponsors Table
CREATE TABLE sponsors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  logo_url TEXT,
  website_url TEXT,
  description TEXT,
  contact_email VARCHAR(255),
  contact_phone VARCHAR(50),
  contact_name VARCHAR(255),
  status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'pending', 'inactive', 'archived')),
  industry VARCHAR(100),
  company_size VARCHAR(50),
  founded_year INTEGER,
  headquarters VARCHAR(255),
  social_media JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_sponsors_updated_at
BEFORE UPDATE ON sponsors
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Create trigger for slug generation
CREATE OR REPLACE FUNCTION generate_sponsor_slug()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.slug IS NULL OR NEW.slug = '' THEN
    NEW.slug := slugify(NEW.name);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_sponsor_slug_trigger
BEFORE INSERT ON sponsors
FOR EACH ROW
EXECUTE FUNCTION generate_sponsor_slug();

-- Sponsorship Tiers Table
CREATE TABLE sponsorship_tiers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price_range VARCHAR(100),
  is_custom BOOLEAN DEFAULT FALSE,
  display_order INTEGER NOT NULL,
  benefits JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_sponsorship_tiers_updated_at
BEFORE UPDATE ON sponsorship_tiers
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Sponsorships Table (Junction between sponsors and events)
CREATE TABLE sponsorships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sponsor_id UUID NOT NULL REFERENCES sponsors(id) ON DELETE CASCADE,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  tier_id UUID REFERENCES sponsorship_tiers(id),
  custom_tier_name VARCHAR(100),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  amount DECIMAL(12,2),
  payment_status VARCHAR(50) CHECK (payment_status IN ('pending', 'partial', 'paid', 'refunded')),
  contract_url TEXT,
  notes TEXT,
  benefits JSONB,
  is_featured BOOLEAN DEFAULT FALSE,
  display_order INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(sponsor_id, event_id)
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_sponsorships_updated_at
BEFORE UPDATE ON sponsorships
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Sponsor Benefits Table
CREATE TABLE sponsor_benefits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100) NOT NULL,
  icon_url TEXT,
  is_digital BOOLEAN DEFAULT FALSE,
  is_physical BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_sponsor_benefits_updated_at
BEFORE UPDATE ON sponsor_benefits
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Tier Benefits Junction Table
CREATE TABLE tier_benefits (
  tier_id UUID NOT NULL REFERENCES sponsorship_tiers(id) ON DELETE CASCADE,
  benefit_id UUID NOT NULL REFERENCES sponsor_benefits(id) ON DELETE CASCADE,
  quantity INTEGER DEFAULT 1,
  details TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (tier_id, benefit_id)
);

-- Sponsorship Assets Table
CREATE TABLE sponsorship_assets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sponsorship_id UUID NOT NULL REFERENCES sponsorships(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  file_url TEXT NOT NULL,
  file_type VARCHAR(50) NOT NULL,
  size_bytes INTEGER,
  dimensions VARCHAR(50),
  status VARCHAR(50) CHECK (status IN ('pending', 'approved', 'rejected')),
  notes TEXT,
  uploaded_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_sponsorship_assets_updated_at
BEFORE UPDATE ON sponsorship_assets
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Sponsor Analytics Table
CREATE TABLE sponsor_analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sponsor_id UUID NOT NULL REFERENCES sponsors(id) ON DELETE CASCADE,
  event_id UUID REFERENCES events(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  impressions INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  leads_generated INTEGER DEFAULT 0,
  conversions INTEGER DEFAULT 0,
  engagement_metrics JSONB,
  roi_metrics JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(sponsor_id, event_id, date)
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_sponsor_analytics_updated_at
BEFORE UPDATE ON sponsor_analytics
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Create partitioning for sponsor analytics by date
CREATE TABLE sponsor_analytics_partitioned (
  LIKE sponsor_analytics INCLUDING ALL
) PARTITION BY RANGE (date);

-- Create partitions for sponsor analytics (example for 2024)
CREATE TABLE sponsor_analytics_y2024q1 PARTITION OF sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');
  
CREATE TABLE sponsor_analytics_y2024q2 PARTITION OF sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');
  
CREATE TABLE sponsor_analytics_y2024q3 PARTITION OF sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');
  
CREATE TABLE sponsor_analytics_y2024q4 PARTITION OF sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Indexes for Sponsorship Management System
CREATE INDEX idx_sponsors_name ON sponsors USING btree (name);
CREATE INDEX idx_sponsors_status ON sponsors USING btree (status);
CREATE INDEX idx_sponsors_industry ON sponsors USING btree (industry);
CREATE INDEX idx_sponsors_slug ON sponsors USING btree (slug);

CREATE INDEX idx_sponsorships_sponsor_id ON sponsorships USING btree (sponsor_id);
CREATE INDEX idx_sponsorships_event_id ON sponsorships USING btree (event_id);
CREATE INDEX idx_sponsorships_tier_id ON sponsorships USING btree (tier_id);
CREATE INDEX idx_sponsorships_date_range ON sponsorships USING btree (start_date, end_date);
CREATE INDEX idx_sponsorships_featured ON sponsorships USING btree (is_featured);

CREATE INDEX idx_sponsor_analytics_sponsor_id ON sponsor_analytics USING btree (sponsor_id);
CREATE INDEX idx_sponsor_analytics_event_id ON sponsor_analytics USING btree (event_id);
CREATE INDEX idx_sponsor_analytics_date ON sponsor_analytics USING btree (date);

-- Full-text search for sponsors
CREATE INDEX idx_sponsors_fts ON sponsors USING gin (
  to_tsvector('english', coalesce(name, '') || ' ' || 
  coalesce(description, '') || ' ' || 
  coalesce(industry, ''))
);
```

### ERD Relationships

1. **Sponsors**
   - A sponsor can have many sponsorships (one-to-many)
   - A sponsor has many analytics records (one-to-many)

2. **Sponsorship Tiers**
   - A tier can be used in many sponsorships (one-to-many)
   - A tier has many benefits through tier_benefits (many-to-many)

3. **Sponsorships**
   - A sponsorship belongs to one sponsor (many-to-one)
   - A sponsorship belongs to one event (many-to-one)
   - A sponsorship belongs to one tier (many-to-one)
   - A sponsorship has many assets (one-to-many)

4. **Sponsor Benefits**
   - A benefit can be part of many tiers through tier_benefits (many-to-many)

5. **Sponsorship Assets**
   - An asset belongs to one sponsorship (many-to-one)

6. **Sponsor Analytics**
   - Analytics records belong to one sponsor (many-to-one)
   - Analytics records may belong to one event (many-to-one)

### Indexing Strategy

1. **Primary Indexes**
   - UUID primary keys on all tables for security and distribution

2. **Foreign Key Indexes**
   - Indexes on all foreign key columns for efficient joins

3. **Full-Text Search**
   - GIN index on sponsors table for efficient text search across name, description, and industry

4. **Range Queries**
   - Composite index on sponsorship date ranges for efficient date filtering
   - Index on analytics date field for time-series queries

5. **Sorting and Filtering**
   - Indexes on status fields, display order, and featured flags for UI sorting and filtering

6. **Partitioning**
   - Date-based partitioning for analytics data to improve query performance on large datasets

### Sample Queries

```sql
-- Get all sponsors with their active sponsorships
SELECT s.id, s.name, s.logo_url, s.industry, 
       COUNT(sp.id) AS active_sponsorships
FROM sponsors s
LEFT JOIN sponsorships sp ON s.id = sp.sponsor_id
WHERE s.status = 'active'
AND CURRENT_DATE BETWEEN sp.start_date AND sp.end_date
GROUP BY s.id, s.name, s.logo_url, s.industry
ORDER BY active_sponsorships DESC;

-- Get all sponsors for a specific event with their tier information
SELECT s.id, s.name, s.logo_url, s.description,
       sp.is_featured, sp.display_order,
       COALESCE(sp.custom_tier_name, st.name) AS tier_name,
       st.benefits AS tier_benefits
FROM sponsorships sp
JOIN sponsors s ON sp.sponsor_id = s.id
LEFT JOIN sponsorship_tiers st ON sp.tier_id = st.id
WHERE sp.event_id = '00000000-0000-0000-0000-000000000001'
AND s.status = 'active'
ORDER BY sp.is_featured DESC, sp.display_order ASC, s.name ASC;

-- Get all benefits for a specific sponsorship tier
SELECT sb.id, sb.name, sb.description, sb.category, sb.icon_url,
       tb.quantity, tb.details
FROM tier_benefits tb
JOIN sponsor_benefits sb ON tb.benefit_id = sb.id
WHERE tb.tier_id = '00000000-0000-0000-0000-000000000002'
ORDER BY sb.category, sb.name;

-- Get ROI metrics for sponsors across all events
SELECT s.name AS sponsor_name, e.title AS event_name,
       SUM(sa.impressions) AS total_impressions,
       SUM(sa.clicks) AS total_clicks,
       SUM(sa.conversions) AS total_conversions,
       AVG(sa.roi_metrics->>'percent_return')::NUMERIC AS avg_roi_percent
FROM sponsor_analytics sa
JOIN sponsors s ON sa.sponsor_id = s.id
JOIN events e ON sa.event_id = e.id
WHERE sa.date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY s.name, e.title
ORDER BY avg_roi_percent DESC;

-- Search sponsors by text query
SELECT id, name, logo_url, description, industry
FROM sponsors
WHERE to_tsvector('english', coalesce(name, '') || ' ' || 
                 coalesce(description, '') || ' ' || 
                 coalesce(industry, '')) @@ to_tsquery('english', 'fashion & luxury');

-- Get all sponsorship assets for an event
SELECT sa.id, sa.name, sa.file_url, sa.file_type, sa.status,
       s.name AS sponsor_name
FROM sponsorship_assets sa
JOIN sponsorships sp ON sa.sponsorship_id = sp.id
JOIN sponsors s ON sp.sponsor_id = s.id
WHERE sp.event_id = '00000000-0000-0000-0000-000000000001'
AND sa.status = 'approved'
ORDER BY s.name, sa.name;
```

### Performance Optimization Notes

1. **Sponsor Profile Optimization**:
   - Efficient text search using GIN indexes
   - Slug-based URLs for SEO and performance
   - Automatic slug generation to ensure uniqueness

2. **Tier Management**:
   - Ordered display for consistent UI presentation
   - JSONB for flexible benefit storage
   - Junction table for many-to-many relationships with benefits

3. **Sponsorship Management**:
   - Composite indexes for date range queries
   - Featured flag and display order for efficient sorting
   - Unique constraint on sponsor/event pairs to prevent duplicates

4. **Asset Management**:
   - Metadata storage for efficient filtering
   - Status tracking for approval workflows
   - File type validation for security

5. **Analytics Performance**:
   - Table partitioning by date for efficient time-series queries
   - JSONB for flexible metric storage
   - Aggregation functions for reporting queries

6. **Query Optimization**:
   - Efficient joins between sponsors, sponsorships, and events
   - Text search optimization with GIN indexes
   - Partitioning for analytics data to improve query performance

This Sponsorship Management System provides a comprehensive foundation for managing sponsor relationships, tracking sponsorship agreements, and measuring ROI. The schema supports the complex relationships between sponsors, events, tiers, and benefits while maintaining high performance and flexibility for reporting and analytics.

## Phase 4: Marketing and Analytics System

### SQL Schema

```sql
-- ===============================
-- MARKETING AND ANALYTICS SYSTEM
-- ===============================

-- Marketing Campaigns Table
CREATE TABLE marketing_campaigns (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN ('draft', 'scheduled', 'active', 'paused', 'completed', 'cancelled')),
  budget DECIMAL(12,2),
  target_audience JSONB,
  goals JSONB,
  channels JSONB,
  event_id UUID REFERENCES events(id) ON DELETE SET NULL,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_marketing_campaigns_updated_at
BEFORE UPDATE ON marketing_campaigns
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Campaign Assets Table
CREATE TABLE campaign_assets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES marketing_campaigns(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  asset_type VARCHAR(50) NOT NULL CHECK (asset_type IN ('image', 'video', 'document', 'audio', 'other')),
  file_url TEXT NOT NULL,
  thumbnail_url TEXT,
  size_bytes INTEGER,
  dimensions VARCHAR(50),
  duration VARCHAR(50),
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_campaign_assets_updated_at
BEFORE UPDATE ON campaign_assets
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Email Campaigns Table
CREATE TABLE email_campaigns (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES marketing_campaigns(id) ON DELETE CASCADE,
  subject VARCHAR(255) NOT NULL,
  preview_text VARCHAR(255),
  sender_name VARCHAR(100) NOT NULL,
  sender_email VARCHAR(255) NOT NULL,
  template_id VARCHAR(100),
  content TEXT,
  scheduled_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  recipient_segment JSONB,
  tracking_settings JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_email_campaigns_updated_at
BEFORE UPDATE ON email_campaigns
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Social Media Posts Table
CREATE TABLE social_media_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES marketing_campaigns(id) ON DELETE CASCADE,
  platform VARCHAR(50) NOT NULL CHECK (platform IN ('instagram', 'facebook', 'twitter', 'linkedin', 'tiktok', 'pinterest', 'other')),
  content TEXT,
  media_urls TEXT[],
  scheduled_at TIMESTAMPTZ,
  published_at TIMESTAMPTZ,
  post_url TEXT,
  post_id VARCHAR(255),
  status VARCHAR(50) NOT NULL CHECK (status IN ('draft', 'scheduled', 'published', 'failed')),
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_social_media_posts_updated_at
BEFORE UPDATE ON social_media_posts
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Promotional Codes Table
CREATE TABLE promotional_codes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID REFERENCES marketing_campaigns(id) ON DELETE SET NULL,
  code VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage', 'fixed_amount', 'free_item')),
  discount_value DECIMAL(10,2) NOT NULL,
  min_purchase_amount DECIMAL(10,2),
  max_discount_amount DECIMAL(10,2),
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  usage_limit INTEGER,
  usage_count INTEGER DEFAULT 0,
  is_single_use BOOLEAN DEFAULT FALSE,
  is_first_purchase_only BOOLEAN DEFAULT FALSE,
  applicable_ticket_types UUID[],
  applicable_events UUID[],
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_promotional_codes_updated_at
BEFORE UPDATE ON promotional_codes
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Marketing Segments Table
CREATE TABLE marketing_segments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  segment_type VARCHAR(50) NOT NULL CHECK (segment_type IN ('static', 'dynamic', 'imported')),
  filter_criteria JSONB,
  estimated_size INTEGER,
  last_calculated_at TIMESTAMPTZ,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_marketing_segments_updated_at
BEFORE UPDATE ON marketing_segments
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Segment Members Table (for static segments)
CREATE TABLE segment_members (
  segment_id UUID NOT NULL REFERENCES marketing_segments(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (segment_id, user_id)
);

-- Campaign Analytics Table
CREATE TABLE campaign_analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES marketing_campaigns(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  channel VARCHAR(50) NOT NULL,
  impressions INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  conversions INTEGER DEFAULT 0,
  revenue DECIMAL(12,2) DEFAULT 0,
  cost DECIMAL(12,2) DEFAULT 0,
  metrics JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(campaign_id, date, channel)
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_campaign_analytics_updated_at
BEFORE UPDATE ON campaign_analytics
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Create partitioning for campaign analytics by date
CREATE TABLE campaign_analytics_partitioned (
  LIKE campaign_analytics INCLUDING ALL
) PARTITION BY RANGE (date);

-- Create partitions for campaign analytics (example for 2024)
CREATE TABLE campaign_analytics_y2024q1 PARTITION OF campaign_analytics_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');
  
CREATE TABLE campaign_analytics_y2024q2 PARTITION OF campaign_analytics_partitioned
  FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');
  
CREATE TABLE campaign_analytics_y2024q3 PARTITION OF campaign_analytics_partitioned
  FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');
  
CREATE TABLE campaign_analytics_y2024q4 PARTITION OF campaign_analytics_partitioned
  FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Email Analytics Table
CREATE TABLE email_analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email_campaign_id UUID NOT NULL REFERENCES email_campaigns(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  sends INTEGER DEFAULT 0,
  opens INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  bounces INTEGER DEFAULT 0,
  unsubscribes INTEGER DEFAULT 0,
  complaints INTEGER DEFAULT 0,
  metrics JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(email_campaign_id, date)
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_email_analytics_updated_at
BEFORE UPDATE ON email_analytics
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Social Media Analytics Table
CREATE TABLE social_media_analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES social_media_posts(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  impressions INTEGER DEFAULT 0,
  reach INTEGER DEFAULT 0,
  engagement INTEGER DEFAULT 0,
  likes INTEGER DEFAULT 0,
  comments INTEGER DEFAULT 0,
  shares INTEGER DEFAULT 0,
  saves INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  metrics JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(post_id, date)
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_social_media_analytics_updated_at
BEFORE UPDATE ON social_media_analytics
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Promotional Code Usage Table
CREATE TABLE promotional_code_usage (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code_id UUID NOT NULL REFERENCES promotional_codes(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
  used_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  discount_amount DECIMAL(10,2) NOT NULL,
  order_total DECIMAL(10,2) NOT NULL
);

-- User Engagement Table
CREATE TABLE user_engagement (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_id UUID REFERENCES events(id) ON DELETE SET NULL,
  engagement_type VARCHAR(50) NOT NULL,
  engagement_source VARCHAR(50) NOT NULL,
  engagement_data JSONB,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ip_address VARCHAR(50),
  user_agent TEXT,
  session_id VARCHAR(100),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index for user engagement partitioning
CREATE INDEX idx_user_engagement_occurred_at ON user_engagement USING btree (occurred_at);

-- Create partitioning for user engagement by date
CREATE TABLE user_engagement_partitioned (
  LIKE user_engagement INCLUDING ALL
) PARTITION BY RANGE (occurred_at);

-- Create partitions for user engagement (example for 2024)
CREATE TABLE user_engagement_y2024m01 PARTITION OF user_engagement_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
  
CREATE TABLE user_engagement_y2024m02 PARTITION OF user_engagement_partitioned
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
  
-- Additional partitions would be created for each month

-- Indexes for Marketing and Analytics System
CREATE INDEX idx_marketing_campaigns_status ON marketing_campaigns USING btree (status);
CREATE INDEX idx_marketing_campaigns_date_range ON marketing_campaigns USING btree (start_date, end_date);
CREATE INDEX idx_marketing_campaigns_event_id ON marketing_campaigns USING btree (event_id);

CREATE INDEX idx_campaign_assets_campaign_id ON campaign_assets USING btree (campaign_id);
CREATE INDEX idx_campaign_assets_asset_type ON campaign_assets USING btree (asset_type);

CREATE INDEX idx_email_campaigns_campaign_id ON email_campaigns USING btree (campaign_id);
CREATE INDEX idx_email_campaigns_scheduled_at ON email_campaigns USING btree (scheduled_at);
CREATE INDEX idx_email_campaigns_sent_at ON email_campaigns USING btree (sent_at);

CREATE INDEX idx_social_media_posts_campaign_id ON social_media_posts USING btree (campaign_id);
CREATE INDEX idx_social_media_posts_platform ON social_media_posts USING btree (platform);
CREATE INDEX idx_social_media_posts_status ON social_media_posts USING btree (status);
CREATE INDEX idx_social_media_posts_scheduled_at ON social_media_posts USING btree (scheduled_at);

CREATE INDEX idx_promotional_codes_code ON promotional_codes USING btree (code);
CREATE INDEX idx_promotional_codes_campaign_id ON promotional_codes USING btree (campaign_id);
CREATE INDEX idx_promotional_codes_date_range ON promotional_codes USING btree (start_date, end_date);

CREATE INDEX idx_marketing_segments_segment_type ON marketing_segments USING btree (segment_type);

CREATE INDEX idx_segment_members_segment_id ON segment_members USING btree (segment_id);
CREATE INDEX idx_segment_members_user_id ON segment_members USING btree (user_id);

CREATE INDEX idx_campaign_analytics_campaign_id ON campaign_analytics USING btree (campaign_id);
CREATE INDEX idx_campaign_analytics_date ON campaign_analytics USING btree (date);
CREATE INDEX idx_campaign_analytics_channel ON campaign_analytics USING btree (channel);

CREATE INDEX idx_email_analytics_email_campaign_id ON email_analytics USING btree (email_campaign_id);
CREATE INDEX idx_email_analytics_date ON email_analytics USING btree (date);

CREATE INDEX idx_social_media_analytics_post_id ON social_media_analytics USING btree (post_id);
CREATE INDEX idx_social_media_analytics_date ON social_media_analytics USING btree (date);

CREATE INDEX idx_promotional_code_usage_code_id ON promotional_code_usage USING btree (code_id);
CREATE INDEX idx_promotional_code_usage_user_id ON promotional_code_usage USING btree (user_id);
CREATE INDEX idx_promotional_code_usage_order_id ON promotional_code_usage USING btree (order_id);
CREATE INDEX idx_promotional_code_usage_used_at ON promotional_code_usage USING btree (used_at);

CREATE INDEX idx_user_engagement_user_id ON user_engagement USING btree (user_id);
CREATE INDEX idx_user_engagement_event_id ON user_engagement USING btree (event_id);
CREATE INDEX idx_user_engagement_type ON user_engagement USING btree (engagement_type);
CREATE INDEX idx_user_engagement_source ON user_engagement USING btree (engagement_source);

-- Full-text search for marketing campaigns
CREATE INDEX idx_marketing_campaigns_fts ON marketing_campaigns USING gin (
  to_tsvector('english', coalesce(name, '') || ' ' || 
  coalesce(description, ''))
);
```

### ERD Relationships

1. **Marketing Campaigns**
   - A campaign can have many assets (one-to-many)
   - A campaign can have many email campaigns (one-to-many)
   - A campaign can have many social media posts (one-to-many)
   - A campaign can have many promotional codes (one-to-many)
   - A campaign can have many analytics records (one-to-many)
   - A campaign may belong to one event (many-to-one)

2. **Email Campaigns**
   - An email campaign belongs to one marketing campaign (many-to-one)
   - An email campaign has many analytics records (one-to-many)

3. **Social Media Posts**
   - A social media post belongs to one marketing campaign (many-to-one)
   - A social media post has many analytics records (one-to-many)

4. **Promotional Codes**
   - A promotional code may belong to one marketing campaign (many-to-one)
   - A promotional code has many usage records (one-to-many)

5. **Marketing Segments**
   - A segment has many members through segment_members (many-to-many)

6. **User Engagement**
   - An engagement record belongs to one user (many-to-one)
   - An engagement record may belong to one event (many-to-one)

### Indexing Strategy

1. **Primary Indexes**
   - UUID primary keys on all tables for security and distribution

2. **Foreign Key Indexes**
   - Indexes on all foreign key columns for efficient joins

3. **Date Range Indexes**
   - Composite indexes on date ranges for campaigns and promotional codes
   - Indexes on scheduled and published dates for content

4. **Status and Type Indexes**
   - Indexes on status fields for filtering active/inactive items
   - Indexes on type fields for categorization

5. **Code Lookup Index**
   - Index on promotional code for fast validation during checkout

6. **Full-Text Search**
   - GIN index on marketing campaigns for efficient text search

7. **Partitioning**
   - Date-based partitioning for analytics and engagement data
   - Monthly partitions for high-volume user engagement data

### Sample Queries

```sql
-- Get all active marketing campaigns with their metrics
SELECT mc.id, mc.name, mc.start_date, mc.end_date, 
       e.title AS event_name,
       SUM(ca.impressions) AS total_impressions,
       SUM(ca.clicks) AS total_clicks,
       SUM(ca.conversions) AS total_conversions,
       SUM(ca.revenue) AS total_revenue,
       SUM(ca.cost) AS total_cost,
       SUM(ca.revenue - ca.cost) AS total_profit,
       CASE WHEN SUM(ca.cost) > 0 
            THEN ROUND((SUM(ca.revenue) / SUM(ca.cost))::numeric, 2)
            ELSE 0 
       END AS roi
FROM marketing_campaigns mc
LEFT JOIN events e ON mc.event_id = e.id
LEFT JOIN campaign_analytics ca ON mc.id = ca.campaign_id
WHERE mc.status = 'active'
AND CURRENT_DATE BETWEEN mc.start_date AND mc.end_date
GROUP BY mc.id, mc.name, mc.start_date, mc.end_date, e.title
ORDER BY total_profit DESC;

-- Get email campaign performance metrics
SELECT ec.id, ec.subject, ec.sent_at,
       mc.name AS campaign_name,
       SUM(ea.sends) AS total_sends,
       SUM(ea.opens) AS total_opens,
       SUM(ea.clicks) AS total_clicks,
       SUM(ea.bounces) AS total_bounces,
       SUM(ea.unsubscribes) AS total_unsubscribes,
       CASE WHEN SUM(ea.sends) > 0 
            THEN ROUND((SUM(ea.opens)::numeric / SUM(ea.sends)::numeric) * 100, 2)
            ELSE 0 
       END AS open_rate,
       CASE WHEN SUM(ea.opens) > 0 
            THEN ROUND((SUM(ea.clicks)::numeric / SUM(ea.opens)::numeric) * 100, 2)
            ELSE 0 
       END AS click_to_open_rate
FROM email_campaigns ec
JOIN marketing_campaigns mc ON ec.campaign_id = mc.id
LEFT JOIN email_analytics ea ON ec.id = ea.email_campaign_id
WHERE ec.sent_at IS NOT NULL
GROUP BY ec.id, ec.subject, ec.sent_at, mc.name
ORDER BY ec.sent_at DESC;

-- Get social media post performance by platform
SELECT smp.platform,
       COUNT(smp.id) AS total_posts,
       SUM(sma.impressions) AS total_impressions,
       SUM(sma.engagement) AS total_engagement,
       SUM(sma.likes) AS total_likes,
       SUM(sma.comments) AS total_comments,
       SUM(sma.shares) AS total_shares,
       CASE WHEN SUM(sma.impressions) > 0 
            THEN ROUND((SUM(sma.engagement)::numeric / SUM(sma.impressions)::numeric) * 100, 2)
            ELSE 0 
       END AS engagement_rate
FROM social_media_posts smp
LEFT JOIN social_media_analytics sma ON smp.id = sma.post_id
WHERE smp.published_at IS NOT NULL
GROUP BY smp.platform
ORDER BY total_engagement DESC;

-- Get promotional code usage and effectiveness
SELECT pc.code, pc.discount_type, pc.discount_value,
       mc.name AS campaign_name,
       COUNT(pcu.id) AS usage_count,
       SUM(pcu.discount_amount) AS total_discount_amount,
       SUM(pcu.order_total) AS total_order_value,
       ROUND(AVG(pcu.discount_amount), 2) AS avg_discount_per_order,
       COUNT(DISTINCT pcu.user_id) AS unique_users
FROM promotional_codes pc
LEFT JOIN marketing_campaigns mc ON pc.campaign_id = mc.id
LEFT JOIN promotional_code_usage pcu ON pc.id = pcu.code_id
GROUP BY pc.code, pc.discount_type, pc.discount_value, mc.name
ORDER BY usage_count DESC;

-- Get user engagement by type and source
SELECT ue.engagement_type, ue.engagement_source,
       COUNT(ue.id) AS total_engagements,
       COUNT(DISTINCT ue.user_id) AS unique_users,
       DATE_TRUNC('day', ue.occurred_at) AS engagement_date
FROM user_engagement ue
WHERE ue.occurred_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY ue.engagement_type, ue.engagement_source, DATE_TRUNC('day', ue.occurred_at)
ORDER BY engagement_date DESC, total_engagements DESC;

-- Get marketing segment size and composition
SELECT ms.id, ms.name, ms.segment_type,
       COUNT(sm.user_id) AS member_count,
       ms.estimated_size,
       ms.last_calculated_at
FROM marketing_segments ms
LEFT JOIN segment_members sm ON ms.id = sm.segment_id
GROUP BY ms.id, ms.name, ms.segment_type, ms.estimated_size, ms.last_calculated_at
ORDER BY member_count DESC;

-- Get campaign performance by channel
SELECT mc.name AS campaign_name,
       ca.channel,
       SUM(ca.impressions) AS total_impressions,
       SUM(ca.clicks) AS total_clicks,
       SUM(ca.conversions) AS total_conversions,
       SUM(ca.revenue) AS total_revenue,
       SUM(ca.cost) AS total_cost,
       CASE WHEN SUM(ca.impressions) > 0 
            THEN ROUND((SUM(ca.clicks)::numeric / SUM(ca.impressions)::numeric) * 100, 2)
            ELSE 0 
       END AS ctr,
       CASE WHEN SUM(ca.clicks) > 0 
            THEN ROUND((SUM(ca.conversions)::numeric / SUM(ca.clicks)::numeric) * 100, 2)
            ELSE 0 
       END AS conversion_rate,
       CASE WHEN SUM(ca.cost) > 0 
            THEN ROUND((SUM(ca.revenue)::numeric / SUM(ca.cost)::numeric), 2)
            ELSE 0 
       END AS roi
FROM campaign_analytics ca
JOIN marketing_campaigns mc ON ca.campaign_id = mc.id
WHERE ca.date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY mc.name, ca.channel
ORDER BY total_revenue DESC;
```

### Performance Optimization Notes

1. **Campaign Management Optimization**:
   - Date range indexing for efficient filtering of active campaigns
   - Full-text search for campaign discovery
   - JSONB for flexible target audience and goal storage
   - Event relationship for contextual campaign organization

2. **Email Marketing Optimization**:
   - Scheduled date indexing for efficient email queue processing
   - Segmentation support through JSONB recipient criteria
   - Performance metrics tracking with aggregation functions
   - Template-based content for consistency and reusability

3. **Social Media Management**:
   - Platform-specific indexing for filtered views
   - Status tracking for workflow management
   - Array storage for multiple media attachments
   - Comprehensive engagement metrics for performance analysis

4. **Promotional Code Optimization**:
   - Unique code constraint with index for fast validation
   - Flexible discount types with validation constraints
   - Usage tracking and limits enforcement
   - Array storage for applicable ticket types and events

5. **Segmentation Optimization**:
   - Support for both static and dynamic segments
   - Junction table for efficient member management
   - JSONB for flexible filter criteria
   - Size estimation for performance planning

6. **Analytics Performance**:
   - Table partitioning by date for efficient time-series queries
   - Channel-based indexing for comparative analysis
   - JSONB for flexible metric storage
   - Aggregation functions for reporting queries

7. **User Engagement Tracking**:
   - Monthly partitioning for high-volume data
   - Type and source indexing for filtered analysis
   - JSONB for flexible engagement data
   - Session tracking for user journey analysis

This Marketing and Analytics System provides a comprehensive foundation for campaign management, content distribution, audience segmentation, and performance measurement. The schema supports multi-channel marketing efforts while maintaining high performance for both operational and analytical queries.

## Phase 5: Advanced Security Implementation and API Integration Layer

### SQL Schema

```sql
-- ===============================
-- ADVANCED SECURITY IMPLEMENTATION
-- ===============================

-- Row Level Security (RLS) Policies

-- Enable Row Level Security on users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create policy for users to view only their own data
CREATE POLICY user_self_access ON users
  FOR SELECT USING (auth.uid() = id);
  
-- Create policy for users to update only their own data
CREATE POLICY user_self_update ON users
  FOR UPDATE USING (auth.uid() = id);

-- Enable RLS on user_profiles
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create policy for users to view only their own profile
CREATE POLICY profile_self_access ON user_profiles
  FOR SELECT USING (auth.uid() = user_id);
  
-- Create policy for users to update only their own profile
CREATE POLICY profile_self_update ON user_profiles
  FOR UPDATE USING (auth.uid() = user_id);

-- Enable RLS on orders
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policy for users to view only their own orders
CREATE POLICY order_self_access ON orders
  FOR SELECT USING (auth.uid() = user_id);

-- Create policy for users to create their own orders
CREATE POLICY order_self_insert ON orders
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Enable RLS on order_items
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Create policy for users to view only their own order items (via orders)
CREATE POLICY order_items_self_access ON order_items
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Enable RLS on events
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Create policy for public access to published events
CREATE POLICY events_public_access ON events
  FOR SELECT USING (status = 'published');

-- Create policy for organizers to manage their events
CREATE POLICY events_organizer_access ON events
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = auth.uid()
      AND (r.name = 'organizer' OR r.name = 'admin')
    )
  );

-- Enable RLS on designers
ALTER TABLE designers ENABLE ROW LEVEL SECURITY;

-- Create policy for public access to active designers
CREATE POLICY designers_public_access ON designers
  FOR SELECT USING (status = 'active');

-- Create policy for designers to manage their own profile
CREATE POLICY designers_self_access ON designers
  FOR ALL USING (user_id = auth.uid());

-- Create policy for admins to manage all designers
CREATE POLICY designers_admin_access ON designers
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = auth.uid()
      AND r.name = 'admin'
    )
  );

-- Enable RLS on collections
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;

-- Create policy for public access to published collections
CREATE POLICY collections_public_access ON collections
  FOR SELECT USING (status = 'published');

-- Create policy for designers to manage their own collections
CREATE POLICY collections_designer_access ON collections
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM designers
      WHERE designers.id = collections.designer_id
      AND designers.user_id = auth.uid()
    )
  );

-- Enable RLS on sponsors
ALTER TABLE sponsors ENABLE ROW LEVEL SECURITY;

-- Create policy for public access to active sponsors
CREATE POLICY sponsors_public_access ON sponsors
  FOR SELECT USING (status = 'active');

-- Create policy for sponsors to manage their own profile
CREATE POLICY sponsors_self_access ON sponsors
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.email = sponsors.contact_email
    )
  );

-- Enable RLS on marketing_campaigns
ALTER TABLE marketing_campaigns ENABLE ROW LEVEL SECURITY;

-- Create policy for marketing team to access campaigns
CREATE POLICY marketing_team_access ON marketing_campaigns
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = auth.uid()
      AND (r.name = 'marketing' OR r.name = 'admin')
    )
  );

-- ===============================
-- DATA ENCRYPTION
-- ===============================

-- Create extension for encryption functions if not exists
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to encrypt sensitive data
CREATE OR REPLACE FUNCTION encrypt_sensitive_data(data TEXT, key TEXT)
RETURNS TEXT AS $$
BEGIN
  RETURN encode(encrypt(data::bytea, key::bytea, 'aes'::text), 'base64');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrypt sensitive data
CREATE OR REPLACE FUNCTION decrypt_sensitive_data(encrypted_data TEXT, key TEXT)
RETURNS TEXT AS $$
BEGIN
  RETURN convert_from(decrypt(decode(encrypted_data, 'base64'), key::bytea, 'aes'::text), 'UTF8');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add encrypted columns to user_profiles
ALTER TABLE user_profiles 
  ADD COLUMN encrypted_payment_info TEXT,
  ADD COLUMN payment_info_key_id UUID;

-- Add encrypted columns to orders
ALTER TABLE orders
  ADD COLUMN encrypted_payment_details TEXT,
  ADD COLUMN payment_details_key_id UUID;

-- Create table for encryption key management
CREATE TABLE encryption_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  key_name VARCHAR(100) NOT NULL,
  key_version INTEGER NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  rotated_at TIMESTAMPTZ
);

-- Enable RLS on encryption_keys
ALTER TABLE encryption_keys ENABLE ROW LEVEL SECURITY;

-- Create policy for only admins to access encryption keys
CREATE POLICY admin_encryption_keys_access ON encryption_keys
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = auth.uid()
      AND r.name = 'admin'
    )
  );

-- ===============================
-- GDPR COMPLIANCE
-- ===============================

-- Data retention policy function
CREATE OR REPLACE FUNCTION apply_data_retention_policy()
RETURNS void AS $$
BEGIN
  -- Anonymize user data older than retention period
  UPDATE user_profiles
  SET 
    first_name = 'Anonymized',
    last_name = 'User',
    phone_number = NULL,
    address = NULL,
    date_of_birth = NULL,
    encrypted_payment_info = NULL,
    payment_info_key_id = NULL,
    bio = NULL,
    profile_image_url = NULL,
    updated_at = NOW()
  WHERE user_id IN (
    SELECT id FROM users
    WHERE last_login < NOW() - INTERVAL '3 years'
    AND status = 'inactive'
  );
  
  -- Anonymize order data beyond retention period
  UPDATE orders
  SET
    user_id = NULL,
    billing_address = NULL,
    shipping_address = NULL,
    contact_email = 'anonymized@example.com',
    contact_phone = NULL,
    encrypted_payment_details = NULL,
    payment_details_key_id = NULL,
    updated_at = NOW()
  WHERE created_at < NOW() - INTERVAL '7 years';
  
  -- Delete user engagement data beyond retention period
  DELETE FROM user_engagement
  WHERE occurred_at < NOW() - INTERVAL '2 years';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a data subject request table for GDPR
CREATE TABLE data_subject_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  request_type VARCHAR(50) NOT NULL CHECK (request_type IN ('access', 'delete', 'rectify', 'restrict', 'portability')),
  status VARCHAR(50) NOT NULL CHECK (status IN ('pending', 'processing', 'completed', 'rejected')),
  request_details JSONB,
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  notes TEXT,
  handled_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Enable RLS on data subject requests
ALTER TABLE data_subject_requests ENABLE ROW LEVEL SECURITY;

-- Create policy for users to view only their own requests
CREATE POLICY dsr_self_access ON data_subject_requests
  FOR SELECT USING (user_id = auth.uid());

-- Create policy for users to create their own requests
CREATE POLICY dsr_self_insert ON data_subject_requests
  FOR INSERT WITH CHECK (user_id = auth.uid());

-- Create policy for admins to manage all requests
CREATE POLICY dsr_admin_access ON data_subject_requests
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur
      JOIN roles r ON ur.role_id = r.id
      WHERE ur.user_id = auth.uid()
      AND r.name = 'admin'
    )
  );

-- ===============================
-- AUDIT LOGGING
-- ===============================

-- Create audit log table
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  action VARCHAR(50) NOT NULL,
  table_name VARCHAR(100) NOT NULL,
  record_id UUID,
  old_data JSONB,
  new_data JSONB,
  ip_address VARCHAR(50),
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index for audit logs
CREATE INDEX idx_audit_logs_user_id ON audit_logs USING btree (user_id);
CREATE INDEX idx_audit_logs_table_name ON audit_logs USING btree (table_name);
CREATE INDEX idx_audit_logs_action ON audit_logs USING btree (action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs USING btree (created_at);

-- Create partitioning for audit logs by date
CREATE TABLE audit_logs_partitioned (
  LIKE audit_logs INCLUDING ALL
) PARTITION BY RANGE (created_at);

-- Create partitions for audit logs (example for 2024)
CREATE TABLE audit_logs_y2024m01 PARTITION OF audit_logs_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
  
CREATE TABLE audit_logs_y2024m02 PARTITION OF audit_logs_partitioned
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- Function to create audit log
CREATE OR REPLACE FUNCTION create_audit_log()
RETURNS TRIGGER AS $$
DECLARE
  old_data JSONB := NULL;
  new_data JSONB := NULL;
BEGIN
  IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
    old_data = row_to_json(OLD)::JSONB;
  END IF;
  
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    new_data = row_to_json(NEW)::JSONB;
  END IF;

  INSERT INTO audit_logs (
    user_id,
    action,
    table_name,
    record_id,
    old_data,
    new_data,
    ip_address,
    user_agent
  ) VALUES (
    auth.uid(),
    TG_OP,
    TG_TABLE_NAME,
    CASE
      WHEN TG_OP = 'DELETE' THEN (old_data->>'id')::UUID
      ELSE (new_data->>'id')::UUID
    END,
    old_data,
    new_data,
    current_setting('request.headers')::JSONB->>'x-forwarded-for',
    current_setting('request.headers')::JSONB->>'user-agent'
  );
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Example of applying audit log trigger to a table
CREATE TRIGGER users_audit_log
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION create_audit_log();

CREATE TRIGGER orders_audit_log
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION create_audit_log();

-- ===============================
-- API INTEGRATION LAYER
-- ===============================

-- API Keys Table
CREATE TABLE api_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  key_prefix VARCHAR(8) NOT NULL,
  key_hash TEXT NOT NULL,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  permissions JSONB NOT NULL,
  rate_limit INTEGER DEFAULT 100,
  is_active BOOLEAN DEFAULT TRUE,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_api_keys_updated_at
BEFORE UPDATE ON api_keys
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Enable RLS on api_keys
ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;

-- Create policy for users to view only their own API keys
CREATE POLICY api_keys_self_access ON api_keys
  FOR SELECT USING (user_id = auth.uid());

-- Create policy for users to manage their own API keys
CREATE POLICY api_keys_self_manage ON api_keys
  FOR ALL USING (user_id = auth.uid());

-- API Usage Logs Table
CREATE TABLE api_usage_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  api_key_id UUID REFERENCES api_keys(id) ON DELETE SET NULL,
  endpoint VARCHAR(255) NOT NULL,
  method VARCHAR(10) NOT NULL,
  status_code INTEGER NOT NULL,
  response_time_ms INTEGER NOT NULL,
  request_size_bytes INTEGER,
  response_size_bytes INTEGER,
  ip_address VARCHAR(50),
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index for API usage logs
CREATE INDEX idx_api_usage_logs_api_key_id ON api_usage_logs USING btree (api_key_id);
CREATE INDEX idx_api_usage_logs_endpoint ON api_usage_logs USING btree (endpoint);
CREATE INDEX idx_api_usage_logs_created_at ON api_usage_logs USING btree (created_at);

-- Create partitioning for API usage logs by date
CREATE TABLE api_usage_logs_partitioned (
  LIKE api_usage_logs INCLUDING ALL
) PARTITION BY RANGE (created_at);

-- Create partitions for API usage logs (example for 2024)
CREATE TABLE api_usage_logs_y2024m01 PARTITION OF api_usage_logs_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
  
CREATE TABLE api_usage_logs_y2024m02 PARTITION OF api_usage_logs_partitioned
  FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- Webhooks Table
CREATE TABLE webhooks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  url TEXT NOT NULL,
  events TEXT[] NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  secret_key TEXT,
  headers JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_webhooks_updated_at
BEFORE UPDATE ON webhooks
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Enable RLS on webhooks
ALTER TABLE webhooks ENABLE ROW LEVEL SECURITY;

-- Create policy for users to view only their own webhooks
CREATE POLICY webhooks_self_access ON webhooks
  FOR SELECT USING (user_id = auth.uid());

-- Create policy for users to manage their own webhooks
CREATE POLICY webhooks_self_manage ON webhooks
  FOR ALL USING (user_id = auth.uid());

-- Webhook Delivery Logs Table
CREATE TABLE webhook_delivery_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  webhook_id UUID REFERENCES webhooks(id) ON DELETE CASCADE,
  event_type VARCHAR(100) NOT NULL,
  payload JSONB NOT NULL,
  response_code INTEGER,
  response_body TEXT,
  error_message TEXT,
  attempt_count INTEGER DEFAULT 1,
  is_success BOOLEAN,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

-- Create index for webhook delivery logs
CREATE INDEX idx_webhook_delivery_logs_webhook_id ON webhook_delivery_logs USING btree (webhook_id);
CREATE INDEX idx_webhook_delivery_logs_event_type ON webhook_delivery_logs USING btree (event_type);
CREATE INDEX idx_webhook_delivery_logs_created_at ON webhook_delivery_logs USING btree (created_at);

-- GraphQL Schema Definitions Table
CREATE TABLE graphql_schema_definitions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  schema_definition TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  version VARCHAR(20) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_graphql_schema_definitions_updated_at
BEFORE UPDATE ON graphql_schema_definitions
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- REST API Endpoints Table
CREATE TABLE rest_api_endpoints (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  path VARCHAR(255) NOT NULL UNIQUE,
  method VARCHAR(10) NOT NULL,
  description TEXT,
  function_name VARCHAR(100) NOT NULL,
  required_permissions TEXT[],
  rate_limit INTEGER DEFAULT 100,
  is_public BOOLEAN DEFAULT FALSE,
  is_deprecated BOOLEAN DEFAULT FALSE,
  version VARCHAR(20) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_rest_api_endpoints_updated_at
BEFORE UPDATE ON rest_api_endpoints
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Create index for REST API endpoints
CREATE INDEX idx_rest_api_endpoints_path_method ON rest_api_endpoints USING btree (path, method);
CREATE INDEX idx_rest_api_endpoints_function_name ON rest_api_endpoints USING btree (function_name);
```

### Security Implementation Details

1. **Row Level Security (RLS)**
   - Fine-grained access control at the row level
   - Role-based policies for different user types
   - Automatic enforcement of data access restrictions
   - Context-aware policies using database functions

2. **Data Encryption**
   - Column-level encryption for sensitive data
   - Key management system with rotation support
   - Secure functions for encryption/decryption
   - Separation of encrypted data and key references

3. **GDPR Compliance**
   - Automated data retention policies
   - Data subject request management
   - Right to access, delete, and export data
   - Data anonymization for inactive accounts

4. **Audit Logging**
   - Comprehensive change tracking across critical tables
   - User attribution for all database changes
   - Capture of old and new values for auditing
   - Partitioned storage for efficient log management

### API Integration Components

1. **API Key Management**
   - Secure key generation and storage
   - Permission-based access control
   - Rate limiting and usage tracking
   - Expiration and rotation support

2. **Webhook System**
   - Event-based integration with external systems
   - Secure delivery with signing
   - Retry logic and failure handling
   - Comprehensive delivery logging

3. **GraphQL Support**
   - Schema versioning and management
   - Type-safe API definitions
   - Efficient nested data retrieval
   - Compatibility with frontend frameworks

4. **REST API Framework**
   - Endpoint registration and documentation
   - Version management for API stability
   - Permission-based access control
   - Rate limiting and monitoring

### Sample Security Policies

```sql
-- Example of a complex RLS policy for event data
-- This allows users to see:
-- 1. All published events
-- 2. Draft events they created
-- 3. All events if they're an admin
CREATE POLICY event_access_policy ON events
FOR SELECT USING (
  status = 'published' OR
  created_by = auth.uid() OR
  EXISTS (
    SELECT 1 FROM user_roles ur
    JOIN roles r ON ur.role_id = r.id
    WHERE ur.user_id = auth.uid()
    AND r.name = 'admin'
  )
);

-- Example of a function to securely store payment information
CREATE OR REPLACE FUNCTION store_payment_info(
  p_user_id UUID,
  p_payment_info TEXT
) RETURNS VOID AS $$
DECLARE
  v_key_id UUID;
  v_encrypted_data TEXT;
  v_key TEXT;
BEGIN
  -- Get the current active encryption key
  SELECT id, key_name INTO v_key_id, v_key
  FROM encryption_keys
  WHERE is_active = TRUE
  AND key_name = 'payment_info'
  ORDER BY key_version DESC
  LIMIT 1;
  
  -- Encrypt the payment information
  v_encrypted_data := encrypt_sensitive_data(p_payment_info, v_key);
  
  -- Store the encrypted data
  UPDATE user_profiles
  SET 
    encrypted_payment_info = v_encrypted_data,
    payment_info_key_id = v_key_id,
    updated_at = NOW()
  WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Example of a function to handle GDPR data export
CREATE OR REPLACE FUNCTION export_user_data(p_user_id UUID)
RETURNS JSONB AS $$
DECLARE
  v_result JSONB;
BEGIN
  -- Ensure the requesting user is authorized
  IF auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Unauthorized access to user data';
  END IF;

  -- Collect user profile data
  SELECT jsonb_build_object(
    'user', jsonb_build_object(
      'id', u.id,
      'email', u.email,
      'created_at', u.created_at
    ),
    'profile', jsonb_build_object(
      'first_name', up.first_name,
      'last_name', up.last_name,
      'phone_number', up.phone_number,
      'address', up.address,
      'date_of_birth', up.date_of_birth,
      'bio', up.bio
    ),
    'orders', (
      SELECT jsonb_agg(jsonb_build_object(
        'id', o.id,
        'order_number', o.order_number,
        'status', o.status,
        'total_amount', o.total_amount,
        'created_at', o.created_at,
        'items', (
          SELECT jsonb_agg(jsonb_build_object(
            'ticket_type', tt.name,
            'quantity', oi.quantity,
            'unit_price', oi.unit_price,
            'total_price', oi.total_price
          ))
          FROM order_items oi
          JOIN ticket_types tt ON oi.ticket_type_id = tt.id
          WHERE oi.order_id = o.id
        )
      ))
      FROM orders o
      WHERE o.user_id = p_user_id
    ),
    'events_attended', (
      SELECT jsonb_agg(jsonb_build_object(
        'event_name', e.title,
        'event_date', e.date,
        'ticket_type', tt.name
      ))
      FROM orders o
      JOIN order_items oi ON o.id = oi.order_id
      JOIN ticket_types tt ON oi.ticket_type_id = tt.id
      JOIN events e ON tt.event_id = e.id
      WHERE o.user_id = p_user_id
      AND o.status = 'completed'
    )
  ) INTO v_result
  FROM users u
  LEFT JOIN user_profiles up ON u.id = up.user_id
  WHERE u.id = p_user_id;

  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### API Integration Examples

```sql
-- Example of registering a REST API endpoint
INSERT INTO rest_api_endpoints (
  path, 
  method, 
  description, 
  function_name, 
  required_permissions,
  rate_limit,
  is_public,
  version
) VALUES (
  '/api/v1/events',
  'GET',
  'Get a list of published events with optional filtering',
  'get_events',
  ARRAY['events:read'],
  200,
  TRUE,
  '1.0'
);

-- Example of a database function exposed via API
CREATE OR REPLACE FUNCTION api_get_events(
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0,
  p_category TEXT DEFAULT NULL,
  p_start_date DATE DEFAULT NULL,
  p_end_date DATE DEFAULT NULL,
  p_search TEXT DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
  v_result JSONB;
BEGIN
  SELECT jsonb_build_object(
    'data', jsonb_agg(jsonb_build_object(
      'id', e.id,
      'title', e.title,
      'description', e.description,
      'date', e.date,
      'location', e.location,
      'image_url', e.image_url,
      'category', e.category,
      'slug', e.slug
    )),
    'meta', jsonb_build_object(
      'total_count', (
        SELECT COUNT(*) FROM events 
        WHERE status = 'published'
        AND (p_category IS NULL OR category = p_category)
        AND (p_start_date IS NULL OR date >= p_start_date)
        AND (p_end_date IS NULL OR date <= p_end_date)
        AND (p_search IS NULL OR 
             to_tsvector('english', title || ' ' || description) @@ to_tsquery('english', p_search))
      ),
      'limit', p_limit,
      'offset', p_offset
    )
  ) INTO v_result
  FROM events e
  WHERE e.status = 'published'
  AND (p_category IS NULL OR e.category = p_category)
  AND (p_start_date IS NULL OR e.date >= p_start_date)
  AND (p_end_date IS NULL OR e.date <= p_end_date)
  AND (p_search IS NULL OR 
       to_tsvector('english', e.title || ' ' || e.description) @@ to_tsquery('english', p_search))
  ORDER BY e.date ASC
  LIMIT p_limit
  OFFSET p_offset;

  RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Example of a webhook delivery function
CREATE OR REPLACE FUNCTION deliver_webhook(
  p_webhook_id UUID,
  p_event_type TEXT,
  p_payload JSONB
) RETURNS UUID AS $$
DECLARE
  v_webhook RECORD;
  v_log_id UUID;
BEGIN
  -- Get webhook details
  SELECT id, url, secret_key, headers
  INTO v_webhook
  FROM webhooks
  WHERE id = p_webhook_id
  AND is_active = TRUE
  AND p_event_type = ANY(events);
  
  -- If no matching webhook, exit
  IF v_webhook.id IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Create delivery log entry
  INSERT INTO webhook_delivery_logs (
    webhook_id,
    event_type,
    payload,
    created_at
  ) VALUES (
    p_webhook_id,
    p_event_type,
    p_payload,
    NOW()
  ) RETURNING id INTO v_log_id;
  
  -- Note: Actual HTTP delivery would be handled by application code
  -- This function just creates the log entry
  
  RETURN v_log_id;
END;
$$ LANGUAGE plpgsql;
```

### Performance and Security Considerations

1. **Security Optimization**:
   - Principle of least privilege for all database operations
   - Security definer functions for controlled elevation of privileges
   - Parameterized queries to prevent SQL injection
   - Comprehensive input validation at the database level

2. **Performance with Security**:
   - Efficient RLS policies to minimize query overhead
   - Indexing strategies compatible with security filters
   - Optimized encryption/decryption for sensitive data
   - Partitioning for high-volume security logs

3. **API Performance**:
   - Rate limiting to prevent abuse
   - Efficient query design for API endpoints
   - Caching strategies for public data
   - Monitoring and optimization of API usage

4. **Compliance Efficiency**:
   - Automated processes for data retention
   - Efficient data export for subject access requests
   - Optimized audit logging with minimal performance impact
   - Balanced security and usability for end users

This Advanced Security Implementation and API Integration Layer provides a comprehensive foundation for secure data access, regulatory compliance, and external system integration. The schema implements industry best practices for data protection while maintaining high performance and usability for both internal and external consumers of the platform's data.
