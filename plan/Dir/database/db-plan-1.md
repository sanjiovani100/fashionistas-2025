# Fashionistas Event Platform - Database Schema Design (Part 1: Core Foundation)

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
```

[Content continues with all of Phase 1 from the original document]

## Next Steps

For the continuation of this database schema, please see:
- [Part 2: Ticketing and Designer Management](db-plan-2.md)
- [Part 3: Sponsorship and Marketing](db-plan-3.md)
- [Part 4: Security and API Integration](db-plan-4.md) 