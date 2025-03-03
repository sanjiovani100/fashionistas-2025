# Fashionistas Project Directory Structure

This document outlines the optimized directory structure for the Fashionistas project, combining best practices from both the shadcn/ui implementation and the hi-events-dev project analysis. It provides a comprehensive guide for organizing the codebase to ensure maintainability, scalability, and good developer experience.

## Implementation Plan Overview

The Fashionistas project will be implemented in phases rather than all at once. This phased approach allows for iterative development, faster delivery of value, and better resource management.

### Phase 1: Core Infrastructure (Weeks 1-2)
- Set up the basic directory structure
- Configure Next.js, TypeScript, and Tailwind CSS
- Install and configure shadcn/ui
- Set up initial CI/CD pipeline

### Phase 2: Component Foundation (Weeks 3-4)
- Implement basic UI components using shadcn/ui
- Create layout components (header, footer, sidebar)
- Develop reusable design system elements

### Phase 3: Feature Development (Weeks 5-10)
- Implement features in priority order:
  1. Authentication system
  2. Event management
  3. Fashion show features
  4. Sponsor management
  5. Ticketing system

### Phase 4: Cross-Cutting Concerns (Weeks 11-12)
- Enhance authentication and authorization
- Set up analytics tracking
- Add error handling and monitoring

### Phase 5: Optimization and Internationalization (Weeks 13-14)
- Implement performance optimizations
- Add translations for English and Spanish
- Ensure responsive design

### Phase 6: Testing and Quality Assurance (Weeks 15-16)
- Implement comprehensive testing
- Fix bugs and polish UX
- Conduct security and accessibility audits

## Root Structure

```
fashionistas/
├── src/                      # Source code
│   ├── app/                  # Next.js App Router
│   ├── components/           # UI components
│   ├── lib/                  # Utilities and shared code
│   ├── hooks/                # Custom React hooks
│   ├── types/                # TypeScript type definitions
│   ├── styles/               # Global styles and theming
│   └── config/               # Configuration files
├── public/                   # Static assets
│   ├── images/               # Image assets
│   ├── fonts/                # Font assets
│   └── favicon.ico           # Favicon
├── docs/                     # Documentation
│   ├── plan/                 # Planning documents
│   └── api/                  # API documentation
├── scripts/                  # Build and utility scripts
├── tests/                    # Test files
│   ├── unit/                 # Unit tests
│   ├── integration/          # Integration tests
│   └── e2e/                  # End-to-end tests
├── .github/                  # GitHub-specific files
│   └── workflows/            # GitHub Actions workflows
├── .husky/                   # Git hooks
├── .storybook/              # Storybook configuration
├── components.json           # shadcn/ui configuration
├── tailwind.config.js        # Tailwind CSS configuration
├── next.config.js            # Next.js configuration
├── package.json              # Project dependencies
├── postcss.config.js         # PostCSS configuration
├── tsconfig.json             # TypeScript configuration
├── .eslintrc.js              # ESLint configuration
├── .prettierrc               # Prettier configuration
├── .env.example              # Example environment variables
├── jest.config.js            # Jest configuration
└── README.md                 # Project README
```

## App Router Structure

The Next.js App Router follows a more streamlined organization that better leverages Next.js 13+ conventions:

```
src/app/
├── api/                     # API routes
│   ├── auth/
│   │   └── route.ts         # Authentication API routes
│   ├── events/
│   │   └── route.ts         # Events API routes
│   ├── fashion-shows/
│   │   └── route.ts         # Fashion shows API routes
│   ├── sponsors/
│   │   └── route.ts         # Sponsors API routes
│   └── webhooks/
│       └── route.ts         # Webhook handlers
├── (auth)/                  # Authentication route group (organization only)
│   ├── login/
│   │   └── page.tsx         # Login page
│   ├── register/
│   │   └── page.tsx         # Registration page
│   ├── forgot-password/
│   │   └── page.tsx         # Password reset page
│   └── layout.tsx           # Shared layout for auth pages
├── (marketing)/             # Marketing route group (organization only)
│   ├── page.tsx             # Home page
│   ├── about/
│   │   └── page.tsx         # About page
│   ├── contact/
│   │   └── page.tsx         # Contact page
│   ├── pricing/
│   │   └── page.tsx         # Pricing page
│   └── layout.tsx           # Shared layout for marketing pages
├── dashboard/               # Admin dashboard
│   ├── page.tsx             # Dashboard home
│   ├── layout.tsx           # Dashboard layout
│   ├── events/              # Event management
│   │   ├── page.tsx         # Events list
│   │   └── [id]/            # Event details (consistent naming)
│   │       └── page.tsx     # Single event page
│   ├── fashion-shows/       # Fashion show management
│   │   ├── page.tsx         # Shows list
│   │   └── [id]/            # Show details (consistent naming)
│   │       └── page.tsx     # Single show page
│   │   └── designers/       # Designer pages
│   │       ├── page.tsx     # Designers listing
│   │       └── [id]/        # Designer details
│   │           └── page.tsx # Single designer page
│   ├── sponsors/            # Sponsor pages
│   │   ├── page.tsx         # Sponsors listing
│   │   └── [id]/            # Sponsor details (consistent naming)
│   │       └── page.tsx     # Single sponsor page
│   ├── users/               # User management
│   │   └── page.tsx         # Users list
│   └── analytics/           # Analytics dashboard
│       └── page.tsx         # Analytics page
├── [locale]/                # Internationalization (uses Next.js i18n)
│   ├── events/              # Event pages
│   │   ├── page.tsx         # Events listing
│   │   └── [id]/            # Event details (consistent naming)
│   │       └── page.tsx     # Single event page
│   │   └── designers/       # Designer pages
│   │       ├── page.tsx     # Designers listing
│   │       └── [id]/        # Designer details
│   │           └── page.tsx # Single designer page
│   ├── fashion-shows/       # Fashion show pages
│   │   ├── page.tsx         # Shows listing
│   │   └── [id]/            # Show details (consistent naming)
│   │       └── page.tsx     # Single show page
│   │   └── designers/       # Designer pages
│   │       ├── page.tsx     # Designers listing
│   │       └── [id]/        # Designer details
│   │           └── page.tsx # Single designer page
│   ├── sponsors/            # Sponsor pages
│   │   ├── page.tsx         # Sponsors listing
│   │   └── [id]/            # Sponsor details (consistent naming)
│   │       └── page.tsx     # Single sponsor page
│   ├── layout.tsx           # Localized layout
│   └── page.tsx             # Localized home page
├── globals.css              # Global styles
├── layout.tsx               # Root layout
└── page.tsx                 # Default home page (redirects to locale)
```

### React Server Components Usage

The App Router leverages React Server Components for improved performance:

- **Server Components**: Default for all page.tsx files
- **Client Components**: Explicitly marked with "use client" directive
- **Hybrid Approach**: Server components for data fetching, client components for interactivity

## Components Directory Structure

The components directory uses a flattened structure with barrel exports for better organization and developer experience:

```
src/components/
├── ui/                      # shadcn/ui base components
│   ├── button/              # Button component with variants
│   │   ├── button.tsx       # Component implementation
│   │   └── index.ts         # Re-export
│   ├── card/                # Card component with variants
│   │   ├── card.tsx         # Component implementation
│   │   └── index.ts         # Re-export
│   └── index.ts             # Barrel export for all UI components
├── layout/                  # Layout components
│   ├── header.tsx           # Site header
│   ├── footer.tsx           # Site footer 
│   ├── sidebar.tsx          # Sidebar components
│   ├── shell.tsx            # Page shells
│   └── index.ts             # Barrel export for layout
├── events/                  # Event components (flattened)
│   ├── event-card.tsx       # Event card component
│   ├── event-list.tsx       # Event list component
│   ├── event-details.tsx    # Event details component
│   ├── event-form.tsx       # Event form component
│   └── index.ts             # Barrel export for event components
├── fashion/                 # Fashion components (flattened)
│   ├── designer-card.tsx    # Designer card component
│   ├── collection-card.tsx  # Collection card component
│   ├── runway-gallery.tsx   # Runway gallery component
│   └── index.ts             # Barrel export for fashion components
├── sponsors/                # Sponsor components (flattened)
│   ├── sponsor-card.tsx     # Sponsor card component
│   ├── sponsor-tiers.tsx    # Sponsor tiers component
│   └── index.ts             # Barrel export for sponsor components
├── forms/                   # Form components
│   ├── auth/                # Auth forms
│   │   ├── login-form.tsx   # Login form
│   │   └── index.ts         # Barrel export
│   ├── events/              # Event forms
│   │   ├── create-form.tsx  # Create event form
│   │   └── index.ts         # Barrel export
│   └── index.ts             # Barrel export for all forms
├── dashboard/               # Dashboard components
│   ├── stats-card.tsx       # Stats card component
│   ├── data-table.tsx       # Reusable data table
│   └── index.ts             # Barrel export for dashboard
└── shared/                  # Shared components
    ├── page-header.tsx      # Page header component
    ├── loading-spinner.tsx  # Loading spinner
    └── index.ts             # Barrel export for shared
```

### Simplified Import Examples

This flattened structure with barrel exports simplifies imports:

**Before:**
```tsx
import { EventCard } from "@/components/events/cards/event-card";
import { EventList } from "@/components/events/lists/event-list";
import { EventForm } from "@/components/forms/events/event-form";
```

**After:**
```tsx
import { EventCard, EventList } from "@/components/events";
import { EventForm } from "@/components/forms/events";
```

### Feature-based Organization

Components are organized by feature domain (events, fashion, sponsors) rather than by component type, making it easier to:

1. Locate related components for a specific feature
2. Understand the relationship between components
3. Maintain code ownership by feature teams
4. Scale the codebase as new features are added

### Co-location Benefits

The flattened structure allows for better co-location of related files:

```
src/components/events/event-card/
├── event-card.tsx           # Component implementation
├── event-card.test.tsx      # Component tests
├── event-card.module.css    # Component styles (if needed)
└── index.ts                 # Re-export
```

This approach keeps all related files together, making maintenance easier.

## Data Flow Architecture

Based on the hi-events-dev analysis, the Fashionistas project should implement a clean data flow architecture:

1. **Data Retrieval Flow:**
   - React components use custom hooks to access data
   - Hooks call API client functions from the lib/api directory
   - API client makes HTTP requests to backend API routes
   - Data is returned and managed through React Query for caching
   - Components receive and render the data

2. **Data Mutation Flow:**
   - User interactions trigger mutation hooks
   - Hooks call API client methods
   - API client sends requests to backend
   - Response updates local cache
   - UI is updated to reflect changes

## Modern Data Fetching Strategy

Leveraging React Server Components and Next.js 13+ data fetching patterns for optimal performance:

### Server Components vs. Client Components

```
src/lib/
├── api/                     # API utilities
│   ├── server/              # Server-side API functions (RSC compatible)
│   │   ├── events.ts        # Event server actions/fetchers
│   │   ├── auth.ts          # Auth server actions/fetchers
│   │   └── index.ts         # Barrel export
│   ├── client/              # Client-side API functions
│   │   ├── fetcher.ts       # SWR/React Query fetcher
│   │   └── index.ts         # Barrel export
│   └── index.ts             # Barrel export for API
├── data/                    # Data utilities
│   ├── mappers.ts           # Data mapping utilities
│   ├── transforms.ts        # Data transformation utilities
│   └── validators.ts        # Data validation utilities
└── db/                      # Database utilities
    ├── actions/             # Database actions (server actions)
    │   ├── events.ts        # Event database actions
    │   └── index.ts         # Barrel export
    └── schema.ts            # Database schema
```

### Server Component Data Fetching Example

```typescript
// src/lib/api/server/events.ts
import { cache } from 'react';
import { db } from '@/lib/db';
import { EventsQueryParams, Event } from '@/types/event';

// Cached data fetching using React cache() function
export const getEvents = cache(async (params?: EventsQueryParams): Promise<Event[]> => {
  const events = await db.event.findMany({
    where: {
      ...(params?.category ? { category: params.category } : {}),
      ...(params?.status ? { status: params.status } : {}),
    },
    orderBy: { 
      startDate: 'asc' 
    },
    take: params?.limit || 10,
  });
  
  return events;
});

// Using with Next.js built-in data fetching
export async function getEventById(id: string): Promise<Event | null> {
  // This uses the Next.js cache by default
  const event = await db.event.findUnique({
    where: { id },
    include: {
      sponsors: true,
      venue: true,
    },
  });
  
  return event;
}

// Server action for mutations (Next.js 13.4+)
export async function createEvent(data: Partial<Event>) {
  'use server'; // Server action directive
  
  const event = await db.event.create({
    data,
  });
  
  // Optionally revalidate paths
  revalidatePath('/events');
  revalidatePath(`/events/${event.id}`);
  
  return event;
}
```

### Client Component Data Fetching Example

```typescript
// src/hooks/events/use-events.ts
'use client';

import { useQuery } from '@tanstack/react-query';
import { EventsQueryParams } from '@/types/event';

const fetchEvents = async (params?: EventsQueryParams) => {
  const queryParams = new URLSearchParams();
  if (params?.category) queryParams.append('category', params.category);
  if (params?.status) queryParams.append('status', params.status);
  
  const response = await fetch(`/api/events?${queryParams}`);
  if (!response.ok) throw new Error('Failed to fetch events');
  return response.json();
};

export function useEvents(params?: EventsQueryParams) {
  return useQuery({
    queryKey: ['events', params],
    queryFn: () => fetchEvents(params),
    staleTime: 1000 * 60 * 5, // 5 minutes
  });
}
```

### Data Fetching Best Practices

1. **Prefer Server Components** for data fetching where possible:
   - Reduced JS bundle size
   - Automatic caching and prefetching
   - SEO-friendly rendering

2. **Use Client Components** for interactive elements:
   - Form submissions
   - Real-time updates
   - Complex user interactions

3. **Cache invalidation strategies**:
   - Use revalidatePath/revalidateTag for server-driven updates
   - Use React Query for client-side cache management
   - Implement optimistic updates for better UX

4. **Error handling**:
   - Implement error boundaries
   - Provide fallback UIs
   - Use consistent error formats

## State Management Architecture

Clear boundaries between server and client state with a simplified approach:

### Server State

- Use React Server Components for data fetching and initial rendering
- Use React Query/SWR for client-side caching and synchronization
- Leverage Next.js caching and revalidation for optimal performance

### Client State (Local UI State)

- Use React's built-in useState/useReducer for component-level state
- Use Zustand for global UI state (replacing multiple contexts)
- Apply targeted re-renders with selective subscriptions

### Zustand Store Example

```typescript
// src/lib/state/theme-store.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface ThemeState {
  theme: 'light' | 'dark' | 'system';
  setTheme: (theme: 'light' | 'dark' | 'system') => void;
}

export const useThemeStore = create<ThemeState>()(
  persist(
    (set) => ({
      theme: 'system',
      setTheme: (theme) => set({ theme }),
    }),
    {
      name: 'theme-storage',
    }
  )
);
```

### Usage Example

```tsx
// src/components/theme-toggle.tsx
'use client';

import { useThemeStore } from '@/lib/state/theme-store';
import { Button } from '@/components/ui/button';
import { SunIcon, MoonIcon, LaptopIcon } from '@/components/icons';

export function ThemeToggle() {
  const { theme, setTheme } = useThemeStore();
  
  return (
    <div className="flex items-center space-x-2">
      <Button 
        variant={theme === 'light' ? 'default' : 'ghost'} 
        size="icon"
        onClick={() => setTheme('light')}
      >
        <SunIcon className="h-5 w-5" />
      </Button>
      <Button 
        variant={theme === 'dark' ? 'default' : 'ghost'} 
        size="icon"
        onClick={() => setTheme('dark')}
      >
        <MoonIcon className="h-5 w-5" />
      </Button>
      <Button 
        variant={theme === 'system' ? 'default' : 'ghost'} 
        size="icon"
        onClick={() => setTheme('system')}
      >
        <LaptopIcon className="h-5 w-5" />
      </Button>
    </div>
  );
}
```

### State Management Guidelines

1. **Server State**:
   - Use React Server Components + React Query/SWR
   - Keep complex data fetching logic on the server
   - Use server components for initial data load

2. **Global UI State**:
   - Use Zustand for theme, modals, sidebars, and other UI state
   - Create separate stores for different concerns
   - Use middleware for persistence and advanced features

3. **Form State**:
   - Use React Hook Form for complex forms
   - Keep form validation co-located with form components
   - Use Zod for schema validation

4. **Component State**:
   - Use React's useState/useReducer for local component state
   - Keep state as close to where it's used as possible
   - Lift state up only when necessary

5. **State Directory Structure**:

```
src/lib/state/
├── stores/              # Zustand stores
│   ├── theme-store.ts   # Theme state
│   ├── modal-store.ts   # Modal state
│   └── sidebar-store.ts # Sidebar state
├── context/             # React contexts (when needed)
│   └── auth-provider.tsx # Authentication provider
└── utils/               # State utilities
    └── state-utils.ts   # Helper functions
```

This approach gives clear separation between server-side and client-side state management, making the application more maintainable and easier to reason about.

## CSS Strategy

We employ a hybrid CSS strategy leveraging Tailwind CSS as the primary styling approach, supplemented by CSS Modules for complex components:

### Primary Approach: Tailwind CSS

- Use Tailwind for all styling by default
- Leverage shadcn/ui's Tailwind-based components
- Use `cn()` utility for conditional classes

```tsx
// src/components/ui/button/button.tsx
import { cn } from "@/lib/utils";

export function Button({ 
  variant = "default", 
  size = "default", 
  className, 
  ...props 
}: ButtonProps) {
  return (
    <button
      className={cn(
        "rounded-md font-medium transition-colors focus-visible:outline-none",
        // Variant styles
        variant === "default" && "bg-primary text-primary-foreground hover:bg-primary/90",
        variant === "outline" && "border border-input bg-background hover:bg-accent",
        // Size styles
        size === "default" && "h-10 px-4 py-2",
        size === "sm" && "h-9 px-3",
        // Additional classes
        className
      )}
      {...props}
    />
  );
}
```

### CSS Modules for Complex Components

For components with complex states or animations, we use CSS Modules:

```
src/components/events/event-card/
├── event-card.tsx           # Component implementation
├── event-card.module.css    # CSS Module
└── index.ts                 # Re-export
```

```css
/* src/components/events/event-card/event-card.module.css */
.card {
  position: relative;
  transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.featured {
  border-left: 4px solid var(--color-primary);
}
```

```tsx
// src/components/events/event-card/event-card.tsx
import styles from './event-card.module.css';
import { cn } from '@/lib/utils';

export function EventCard({ event, featured }: EventCardProps) {
  return (
    <div className={cn(
      styles.card,
      featured && styles.featured,
      "rounded-lg p-4 bg-card"
    )}>
      {/* Card content */}
    </div>
  );
}
```

### Global Styles

Global styles live in `src/app/globals.css`:

```css
/* src/app/globals.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    /* Other CSS variables */
  }

  .dark {
    --background: 240 10% 3.9%;
    --foreground: 0 0% 98%;
    /* Dark theme variables */
  }
}

@layer components {
  /* Shared component styles */
  .prose {
    @apply max-w-3xl mx-auto leading-7;
  }
}

@layer utilities {
  /* Custom utilities */
  .text-balance {
    text-wrap: balance;
  }
}
```

### Styling Organization

Our styling approach is organized as follows:

1. **Component-Level Styles**:
   - Tailwind classes directly in components
   - CSS Modules for complex components
   - Zero custom CSS outside of modules when possible

2. **Theme Variables**:
   - Defined in `tailwind.config.js`
   - Exposed as CSS variables
   - Accessible in both Tailwind and CSS Modules

3. **Design System Components**:
   - All UI components follow the same styling pattern
   - Variants defined consistently using the same approach
   - Size variations use consistent scale

### Responsive Design Strategy

We use a mobile-first approach with Tailwind's responsive breakpoints:

```tsx
<div className="
  grid
  grid-cols-1
  sm:grid-cols-2
  md:grid-cols-3
  lg:grid-cols-4
  gap-4
">
  {/* Grid content */}
</div>
```

### Performance Considerations

To optimize CSS performance:

1. **Purge Unused Styles**:
   - Configure Tailwind's JIT mode to only include used styles
   - Use PurgeCSS to remove unused CSS from production builds

2. **Minimize CSS-in-JS**:
   - Avoid runtime CSS-in-JS libraries
   - Use Tailwind and CSS Modules for better performance

3. **Critical CSS**:
   - Use Next.js built-in CSS optimization
   - Inline critical styles for faster initial render

### Animation Strategy

For animations, we use a combination of:

1. **Simple Transitions**: Use Tailwind's transition utilities
2. **Complex Animations**: Use CSS Modules or Framer Motion
3. **Interaction Feedback**: Use Tailwind's hover/focus states

This hybrid CSS strategy provides the best balance of developer experience, performance, and maintainability.

## Internationalization Strategy

Leveraging Next.js built-in internationalization through the App Router:

### App Router Internationalization

The [locale] directory pattern provides a clean approach to internationalization:

```
src/app/
├── [locale]/                # Locale-specific routes
│   ├── events/              # Event pages in the current locale
│   ├── fashion-shows/       # Fashion show pages in the current locale
│   ├── sponsors/            # Sponsor pages in the current locale
│   ├── layout.tsx           # Locale-aware layout
│   └── page.tsx             # Locale-aware home page
├── layout.tsx               # Root layout
└── page.tsx                 # Root page (redirects to preferred locale)
```

### Locale Detection and Routing

```tsx
// src/app/page.tsx
import { redirect } from 'next/navigation';
import { cookies, headers } from 'next/headers';
import { SUPPORTED_LOCALES, DEFAULT_LOCALE } from '@/config/i18n';

export default function RootPage() {
  // 1. Get the preferred locale from cookie or header
  const cookieStore = cookies();
  const localeCookie = cookieStore.get('NEXT_LOCALE');
  
  // 2. Or from Accept-Language header
  const headersList = headers();
  const acceptLanguage = headersList.get('accept-language') || '';
  const preferredLocale = acceptLanguage.split(',')[0].split('-')[0];
  
  // 3. Determine which locale to use
  const locale = 
    (localeCookie?.value && SUPPORTED_LOCALES.includes(localeCookie.value)) ? 
      localeCookie.value : 
    (preferredLocale && SUPPORTED_LOCALES.includes(preferredLocale)) ? 
      preferredLocale : 
      DEFAULT_LOCALE;
  
  // 4. Redirect to the locale-specific page
  redirect(`/${locale}`);
}
```

### Translation Structure

```
src/i18n/
├── dictionaries/            # Translation dictionaries
│   ├── en.json              # English translations
│   │   ├── common           # Common strings
│   │   ├── events           # Event-related strings
│   │   └── auth             # Auth-related strings
│   └── es.json              # Spanish translations
│       ├── common           # Common strings
│       ├── events           # Event-related strings
│       └── auth             # Auth-related strings
├── server.ts                # Server-side i18n utilities
├── client.ts                # Client-side i18n utilities
└── config.ts                # i18n configuration
```

### Server-Side Translation

```tsx
// src/i18n/server.ts
import 'server-only';
import { SUPPORTED_LOCALES, DEFAULT_LOCALE } from '@/config/i18n';

const dictionaries = {
  en: () => import('./dictionaries/en.json').then(module => module.default),
  es: () => import('./dictionaries/es.json').then(module => module.default),
};

export async function getDictionary(locale = DEFAULT_LOCALE) {
  const selectedLocale = SUPPORTED_LOCALES.includes(locale) ? locale : DEFAULT_LOCALE;
  return dictionaries[selectedLocale]();
}
```

### Usage in Server Components

```tsx
// src/app/[locale]/events/page.tsx
import { getDictionary } from '@/i18n/server';

export default async function EventsPage({ params }: { params: { locale: string } }) {
  // Get dictionary for the current locale
  const dict = await getDictionary(params.locale);
  
  return (
    <div>
      <h1>{dict.events.pageTitle}</h1>
      <p>{dict.events.introText}</p>
      {/* Rest of the page */}
    </div>
  );
}
```

### Client-Side Translation

For interactive components that need translations:

```tsx
// src/i18n/client.ts
'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import { DEFAULT_LOCALE } from '@/config/i18n';

const dictionaries = {
  en: () => import('./dictionaries/en.json').then(module => module.default),
  es: () => import('./dictionaries/es.json').then(module => module.default),
};

export function useTranslation() {
  const params = useParams();
  const locale = params?.locale as string || DEFAULT_LOCALE;
  const [dictionary, setDictionary] = useState({});
  
  useEffect(() => {
    dictionaries[locale]()
      .then(dict => setDictionary(dict))
      .catch(() => {
        console.error(`Could not load dictionary for locale: ${locale}`);
        dictionaries[DEFAULT_LOCALE]().then(dict => setDictionary(dict));
      });
  }, [locale]);
  
  return {
    t: (key: string) => {
      // Split the key by dots to access nested properties
      const keys = key.split('.');
      let value = { ...dictionary };
      
      for (const k of keys) {
        value = value[k];
        if (!value) return key; // Fallback to key if translation not found
      }
      
      return value as string;
    },
    locale,
  };
}
```

### Usage in Client Components

```tsx
// src/components/events/event-filters.tsx
'use client';

import { useTranslation } from '@/i18n/client';

export function EventFilters() {
  const { t } = useTranslation();
  
  return (
    <div>
      <h2>{t('events.filters.title')}</h2>
      <label>{t('events.filters.dateRange')}</label>
      {/* Rest of the component */}
    </div>
  );
}
```

This internationalization strategy integrates seamlessly with Next.js App Router, providing a clean way to handle multiple languages while maintaining good performance and developer experience.

## Testing Strategy

We implement a comprehensive testing strategy with flexible approaches to test organization:

### Option 1: Co-located Tests (Recommended)

Tests are placed alongside the components or functions they test:

```
src/components/ui/button/
├── button.tsx               # Component implementation
├── button.test.tsx          # Unit tests
├── button.stories.tsx       # Storybook stories (optional)
└── index.ts                 # Re-export
```

Benefits:
- Tests and components stay in sync when files are moved
- Easier to find tests for specific components
- More natural to update tests when components change
- Better visibility encourages maintaining tests

### Option 2: Parallel Test Directories

Tests are organized in a separate directory structure that mirrors the source:

```
src/
├── components/
│   └── ui/
│       └── button/
│           ├── button.tsx
│           └── index.ts
└── __tests__/
    └── components/
        └── ui/
            └── button/
                └── button.test.tsx
```

Benefits:
- Clear separation between production and test code
- Cleaner source directories
- May work better with certain testing configurations

### Component Testing Example

```tsx
// src/components/ui/button/button.test.tsx
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { Button } from "./button";

describe("Button", () => {
  it("renders correctly", () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole("button", { name: /click me/i })).toBeInTheDocument();
  });

  it("calls onClick when clicked", async () => {
    const onClick = jest.fn();
    render(<Button onClick={onClick}>Click me</Button>);
    await userEvent.click(screen.getByRole("button", { name: /click me/i }));
    expect(onClick).toHaveBeenCalledTimes(1);
  });
  
  it("applies variant classes correctly", () => {
    render(<Button variant="outline">Outline Button</Button>);
    const button = screen.getByRole("button", { name: /outline button/i });
    expect(button).toHaveClass("border", "border-input", "bg-background");
  });
});
```

### Hook Testing Example

```tsx
// src/hooks/use-counter/use-counter.test.tsx
import { renderHook, act } from "@testing-library/react-hooks";
import { useCounter } from "./use-counter";

describe("useCounter", () => {
  it("should initialize with default value", () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });

  it("should initialize with provided value", () => {
    const { result } = renderHook(() => useCounter(10));
    expect(result.current.count).toBe(10);
  });

  it("should increment counter", () => {
    const { result } = renderHook(() => useCounter());
    act(() => {
      result.current.increment();
    });
    expect(result.current.count).toBe(1);
  });
});
```

### Test Types

Our testing strategy covers multiple test types:

1. **Unit Tests**:
   - Test individual components, hooks, and utilities
   - Focus on isolated behavior
   - Should be fast and reliable

2. **Integration Tests**:
   - Test interactions between components
   - Validate feature workflows
   - Focus on component communication

3. **E2E Tests**:
   - Test complete user journeys
   - Run against a deployed environment
   - Focus on critical user flows

### Testing Tools

- **Jest**: Test runner and assertion library
- **React Testing Library**: Component testing
- **Playwright**: End-to-end testing
- **Mock Service Worker**: API mocking
- **Storybook**: Component development and visual testing

### Testing Best Practices

1. **Test Behavior, Not Implementation**:
   - Focus on what the component does, not how it's built
   - Write tests from the user's perspective
   - Avoid testing implementation details

2. **Consistent Patterns**:
   - Use consistent naming (e.g., `[ComponentName].test.tsx`)
   - Structure tests consistently (arrange-act-assert)
   - Group related tests with descriptive `describe` blocks

3. **Test Coverage**:
   - Aim for high coverage of critical paths
   - Don't fixate on 100% coverage
   - Focus on user-facing functionality

4. **Integration with CI/CD**:
   - Run unit and integration tests on every PR
   - Run E2E tests on staging deployments
   - Block merges if tests fail

This flexible testing strategy allows teams to choose the approach that best fits their workflow while maintaining high code quality.

## Best Practices to Follow

### Component Organization

1. **Co-locate Related Files:**
   - Keep component files with their styles, tests, and utilities
   - Use index.ts files for clean exports

2. **Consistent Component Structure:**
   ```tsx
   // src/components/events/cards/event-card.tsx
   import { Card, CardContent, CardFooter } from "@/components/ui/card";
   import { cn } from "@/lib/utils/cn";
   import { Event } from "@/types/event";

   interface EventCardProps {
     event: Event;
     variant?: "default" | "compact";
     className?: string;
   }

   export function EventCard({ 
     event, 
     variant = "default", 
     className 
   }: EventCardProps) {
     return (
       <Card className={cn(
         "transition-all hover:shadow-md",
         variant === "compact" && "max-w-sm",
         className
       )}>
         <CardContent>
           {/* Card content */}
         </CardContent>
         <CardFooter>
           {/* Card footer */}
         </CardFooter>
       </Card>
     );
   }
   ```

3. **Feature-Based Grouping:**
   - Group related components by feature (events, fashion, sponsors)
   - Further group by component type within features (cards, lists, details)

### API and Data Fetching

1. **Centralized API Clients:**
   ```ts
   // src/lib/api/events.ts
   import { api } from "./client";
   import { Event, EventResponse, EventsQueryParams } from "@/types/event";

   export const eventsApi = {
     getAll: async (params?: EventsQueryParams) => {
       const response = await api.get<EventResponse>('events', { params });
       return response.data;
     },
     
     getById: async (id: string) => {
       const response = await api.get<Event>(`events/${id}`);
       return response.data;
     },
     
     create: async (event: Partial<Event>) => {
       const response = await api.post<Event>('events', event);
       return response.data;
     },
     
     update: async (id: string, event: Partial<Event>) => {
       const response = await api.put<Event>(`events/${id}`, event);
       return response.data;
     }
   };
   ```

2. **Custom Hooks for Data:**
   ```ts
   // src/hooks/events/use-events.ts
   import { useQuery } from "@tanstack/react-query";
   import { eventsApi } from "@/lib/api/events";
   import { EventsQueryParams } from "@/types/event";

   export function useEvents(params?: EventsQueryParams) {
     return useQuery({
       queryKey: ['events', params],
       queryFn: () => eventsApi.getAll(params),
       staleTime: 1000 * 60 * 5, // 5 minutes
     });
   }
   ```

### Routing and Layouts

1. **Route Groups:**
   - Use route groups (parentheses folders) to organize related routes
   - Share layouts within route groups

2. **Layout Composition:**
   ```tsx
   // src/app/(marketing)/layout.tsx
   import { SiteHeader } from "@/components/layout/header/site-header";
   import { SiteFooter } from "@/components/layout/footer/site-footer";

   export default function MarketingLayout({
     children,
   }: {
     children: React.ReactNode;
   }) {
     return (
       <>
         <SiteHeader />
         <main className="flex-1">{children}</main>
         <SiteFooter />
       </>
     );
   }
   ```

### State Management

1. **Local State First:**
   - Keep state as local as possible
   - Only elevate state when needed for sharing

2. **React Query for Server State:**
   - Use React Query for all API data
   - Take advantage of caching and background refetching

3. **Context for Global UI State:**
   ```tsx
   // src/lib/context/theme-provider.tsx
   "use client"
   
   import { createContext, useContext, useState } from "react";
   import { ThemeProvider as NextThemesProvider } from "next-themes";

   export function ThemeProvider({
     children,
   }: {
     children: React.ReactNode;
   }) {
     return (
       <NextThemesProvider attribute="class" defaultTheme="system" enableSystem>
         {children}
       </NextThemesProvider>
     );
   }
   ```