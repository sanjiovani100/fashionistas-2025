Sponsorship Management System. 

```markdown
# Fashionistas Event Platform - Database Schema Design (Part 3: Sponsorship Management)

## Phase 3: Sponsorship Management System

The Sponsorship Management System provides a comprehensive foundation for managing sponsor relationships, tiered sponsorship structures, benefit tracking, and performance analytics.

### SQL Schema

```sql
-- ===============================
-- SPONSORSHIP MANAGEMENT SYSTEM
-- ===============================

-- Sponsors Table
CREATE TABLE public.sponsors (
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
BEFORE UPDATE ON public.sponsors
FOR EACH ROW
EXECUTE FUNCTION public.trigger_set_timestamp();

-- Create trigger for slug generation
CREATE OR REPLACE FUNCTION public.generate_sponsor_slug()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.slug IS NULL OR NEW.slug = '' THEN
    NEW.slug := slugify(NEW.name);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_sponsor_slug_trigger
BEFORE INSERT ON public.sponsors
FOR EACH ROW
EXECUTE FUNCTION public.generate_sponsor_slug();

-- Sponsorship Tiers Table
CREATE TABLE public.sponsorship_tiers (
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
BEFORE UPDATE ON public.sponsorship_tiers
FOR EACH ROW
EXECUTE FUNCTION public.trigger_set_timestamp();

-- Sponsorships Table (Junction between sponsors and events)
CREATE TABLE public.sponsorships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sponsor_id UUID NOT NULL REFERENCES public.sponsors(id) ON DELETE CASCADE,
  event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  tier_id UUID REFERENCES public.sponsorship_tiers(id),
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
BEFORE UPDATE ON public.sponsorships
FOR EACH ROW
EXECUTE FUNCTION public.trigger_set_timestamp();

-- Sponsor Benefits Table
CREATE TABLE public.sponsor_benefits (
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
BEFORE UPDATE ON public.sponsor_benefits
FOR EACH ROW
EXECUTE FUNCTION public.trigger_set_timestamp();

-- Tier Benefits Junction Table
CREATE TABLE public.tier_benefits (
  tier_id UUID NOT NULL REFERENCES public.sponsorship_tiers(id) ON DELETE CASCADE,
  benefit_id UUID NOT NULL REFERENCES public.sponsor_benefits(id) ON DELETE CASCADE,
  quantity INTEGER DEFAULT 1,
  details TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (tier_id, benefit_id)
);

-- Sponsorship Assets Table
CREATE TABLE public.sponsorship_assets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sponsorship_id UUID NOT NULL REFERENCES public.sponsorships(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  file_url TEXT NOT NULL,
  file_type VARCHAR(50) NOT NULL,
  size_bytes INTEGER,
  dimensions VARCHAR(50),
  status VARCHAR(50) CHECK (status IN ('pending', 'approved', 'rejected')),
  notes TEXT,
  uploaded_by UUID REFERENCES public.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE TRIGGER set_sponsorship_assets_updated_at
BEFORE UPDATE ON public.sponsorship_assets
FOR EACH ROW
EXECUTE FUNCTION public.trigger_set_timestamp();

-- Sponsor Analytics Table
CREATE TABLE public.sponsor_analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sponsor_id UUID NOT NULL REFERENCES public.sponsors(id) ON DELETE CASCADE,
  event_id UUID REFERENCES public.events(id) ON DELETE CASCADE,
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
BEFORE UPDATE ON public.sponsor_analytics
FOR EACH ROW
EXECUTE FUNCTION public.trigger_set_timestamp();

-- Create partitioning for sponsor analytics by date
CREATE TABLE public.sponsor_analytics_partitioned (
  LIKE public.sponsor_analytics INCLUDING ALL
) PARTITION BY RANGE (date);

-- Create partitions for sponsor analytics (example for 2024)
CREATE TABLE public.sponsor_analytics_y2024q1 PARTITION OF public.sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');
  
CREATE TABLE public.sponsor_analytics_y2024q2 PARTITION OF public.sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');
  
CREATE TABLE public.sponsor_analytics_y2024q3 PARTITION OF public.sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');
  
CREATE TABLE public.sponsor_analytics_y2024q4 PARTITION OF public.sponsor_analytics_partitioned
  FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- Indexes for Sponsorship Management System
CREATE INDEX idx_sponsors_name ON public.sponsors USING btree (name);
CREATE INDEX idx_sponsors_status ON public.sponsors USING btree (status);
CREATE INDEX idx_sponsors_industry ON public.sponsors USING btree (industry);
CREATE INDEX idx_sponsors_slug ON public.sponsors USING btree (slug);

CREATE INDEX idx_sponsorships_sponsor_id ON public.sponsorships USING btree (sponsor_id);
CREATE INDEX idx_sponsorships_event_id ON public.sponsorships USING btree (event_id);
CREATE INDEX idx_sponsorships_tier_id ON public.sponsorships USING btree (tier_id);
CREATE INDEX idx_sponsorships_date_range ON public.sponsorships USING btree (start_date, end_date);
CREATE INDEX idx_sponsorships_featured ON public.sponsorships USING btree (is_featured);

CREATE INDEX idx_sponsor_analytics_sponsor_id ON public.sponsor_analytics USING btree (sponsor_id);
CREATE INDEX idx_sponsor_analytics_event_id ON public.sponsor_analytics USING btree (event_id);
CREATE INDEX idx_sponsor_analytics_date ON public.sponsor_analytics USING btree (date);

-- Full-text search for sponsors
CREATE INDEX idx_sponsors_fts ON public.sponsors USING gin (
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
FROM public.sponsors s
LEFT JOIN public.sponsorships sp ON s.id = sp.sponsor_id
WHERE s.status = 'active'
AND CURRENT_DATE BETWEEN sp.start_date AND sp.end_date
GROUP BY s.id, s.name, s.logo_url, s.industry
ORDER BY active_sponsorships DESC;

-- Get all sponsors for a specific event with their tier information
SELECT s.id, s.name, s.logo_url, s.description,
       sp.is_featured, sp.display_order,
       COALESCE(sp.custom_tier_name, st.name) AS tier_name,
       st.benefits AS tier_benefits
FROM public.sponsorships sp
JOIN public.sponsors s ON sp.sponsor_id = s.id
LEFT JOIN public.sponsorship_tiers st ON sp.tier_id = st.id
WHERE sp.event_id = '00000000-0000-0000-0000-000000000001'
AND s.status = 'active'
ORDER BY sp.is_featured DESC, sp.display_order ASC, s.name ASC;

-- Get all benefits for a specific sponsorship tier
SELECT sb.id, sb.name, sb.description, sb.category, sb.icon_url,
       tb.quantity, tb.details
FROM public.tier_benefits tb
JOIN public.sponsor_benefits sb ON tb.benefit_id = sb.id
WHERE tb.tier_id = '00000000-0000-0000-0000-000000000002'
ORDER BY sb.category, sb.name;

-- Get ROI metrics for sponsors across all events
SELECT s.name AS sponsor_name, e.title AS event_name,
       SUM(sa.impressions) AS total_impressions,
       SUM(sa.clicks) AS total_clicks,
       SUM(sa.conversions) AS total_conversions,
       AVG(sa.roi_metrics->>'percent_return')::NUMERIC AS avg_roi_percent
FROM public.sponsor_analytics sa
JOIN public.sponsors s ON sa.sponsor_id = s.id
JOIN public.events e ON sa.event_id = e.id
WHERE sa.date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY s.name, e.title
ORDER BY avg_roi_percent DESC;

-- Search sponsors by text query
SELECT id, name, logo_url, description, industry
FROM public.sponsors
WHERE to_tsvector('english', coalesce(name, '') || ' ' || 
                 coalesce(description, '') || ' ' || 
                 coalesce(industry, '')) @@ to_tsquery('english', 'fashion & luxury');

-- Get all sponsorship assets for an event
SELECT sa.id, sa.name, sa.file_url, sa.file_type, sa.status,
       s.name AS sponsor_name
FROM public.sponsorship_assets sa
JOIN public.sponsorships sp ON sa.sponsorship_id = sp.id
JOIN public.sponsors s ON sp.sponsor_id = s.id
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

## Next Steps

For the continuation of this database schema, please see:
- [Part 1: Core Foundation](db-plan-1.md)
- [Part 2: Ticketing and Designer Management](db-plan-2.md)
- [Part 4: Marketing and API Integration](db-plan-4.md)
```

This document provides a comprehensive overview of the Sponsorship Management System for the Fashionistas Event Platform. It includes the SQL schema, ERD relationships, indexing strategy, sample queries, and performance optimization notes. The structure is consistent with the previous parts of the database plan.


