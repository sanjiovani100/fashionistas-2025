# Recommended Directory Structure for Shadcn/UI Implementation

This document outlines the recommended directory structure for our shadcn/ui implementation in the Fashionistas project. Following these best practices will ensure our codebase remains organized, maintainable, and scalable as the project grows.

## Root Structure

```
shadcn-fashionistas/
├── public/                  # Static assets
├── src/                     # Source code
│   ├── app/                 # Next.js App Router
│   ├── components/          # React components
│   ├── lib/                 # Utility functions and shared code
│   ├── hooks/               # Custom React hooks
│   ├── types/               # TypeScript type definitions
│   ├── styles/              # Global styles (if needed beyond globals.css)
│   ├── config/              # Configuration files
│   └── data/                # Static data, mock data, etc.
├── .eslintrc.js             # ESLint configuration
├── .prettierrc              # Prettier configuration
├── components.json          # shadcn/ui configuration
├── next.config.js           # Next.js configuration
├── package.json             # Project dependencies
├── postcss.config.js        # PostCSS configuration
├── tailwind.config.js       # Tailwind CSS configuration
└── tsconfig.json            # TypeScript configuration
```

## Components Directory Structure

The components directory is the most critical part of our organization. We'll structure it as follows:

```
src/components/
├── ui/                      # shadcn/ui base components
│   ├── button.tsx
│   ├── card.tsx
│   ├── dialog.tsx
│   └── ...
├── blocks/                  # Composite UI blocks from shadcnblocks.com
│   ├── hero/
│   │   ├── main-hero.tsx
│   │   └── event-hero.tsx
│   ├── pricing/
│   │   ├── ticket-pricing.tsx
│   │   └── sponsor-pricing.tsx
│   ├── features/
│   │   └── ...
│   └── ...
├── layout/                  # Layout components
│   ├── header/
│   │   ├── main-nav.tsx
│   │   ├── mobile-nav.tsx
│   │   └── user-nav.tsx
│   ├── footer/
│   │   └── site-footer.tsx
│   ├── sidebar/
│   │   └── ...
│   └── ...
├── forms/                   # Form components
│   ├── event-registration-form.tsx
│   ├── contact-form.tsx
│   ├── newsletter-form.tsx
│   └── ...
├── events/                  # Event-specific components
│   ├── event-card.tsx
│   ├── event-list.tsx
│   ├── event-details.tsx
│   └── ...
├── fashion/                 # Fashion show components
│   ├── designer-card.tsx
│   ├── collection-gallery.tsx
│   ├── runway-schedule.tsx
│   └── ...
├── sponsors/                # Sponsor-related components
│   ├── sponsor-card.tsx
│   ├── sponsor-tier.tsx
│   └── ...
├── attendees/               # Attendee-related components
│   ├── ticket-selection.tsx
│   ├── seating-chart.tsx
│   └── ...
└── shared/                  # Shared components used across features
    ├── page-header.tsx
    ├── section-heading.tsx
    ├── loading-spinner.tsx
    └── ...
```

## App Router Structure

For the Next.js App Router, we'll organize routes based on features:

```
src/app/
├── (auth)/                  # Authentication routes (grouped)
│   ├── login/
│   │   └── page.tsx
│   ├── register/
│   │   └── page.tsx
│   └── layout.tsx           # Shared layout for auth pages
├── (marketing)/             # Public marketing pages (grouped)
│   ├── page.tsx             # Home page
│   ├── about/
│   │   └── page.tsx
│   ├── contact/
│   │   └── page.tsx
│   └── layout.tsx           # Shared layout for marketing pages
├── events/                  # Event pages
│   ├── page.tsx             # Events listing
│   ├── [eventId]/           # Dynamic route for event details
│   │   └── page.tsx
│   └── create/
│       └── page.tsx
├── fashion-shows/           # Fashion show pages
│   ├── page.tsx
│   └── [showId]/
│       └── page.tsx
├── sponsors/                # Sponsor pages
│   └── page.tsx
├── dashboard/               # Admin dashboard
│   ├── page.tsx
│   ├── events/
│   │   └── page.tsx
│   ├── sponsors/
│   │   └── page.tsx
│   ├── attendees/
│   │   └── page.tsx
│   └── layout.tsx           # Dashboard layout
├── api/                     # API routes
│   └── ...
├── globals.css              # Global styles
├── layout.tsx               # Root layout
└── page.tsx                 # Home page (if not using grouped routes)
```

## Lib Directory Structure

The lib directory contains utility functions and shared code:

```
src/lib/
├── utils.ts                 # General utility functions
├── api/                     # API client functions
│   ├── events.ts
│   ├── sponsors.ts
│   └── ...
├── hooks/                   # Custom React hooks
│   ├── use-events.ts
│   ├── use-form.ts
│   └── ...
├── constants/               # Constants and configuration values
│   ├── navigation.ts
│   ├── site.ts
│   └── ...
└── context/                 # React context providers
    ├── theme-provider.tsx
    └── ...
```

## Types Directory Structure

For TypeScript type definitions:

```
src/types/
├── index.ts                 # Re-exports of all types
├── event.ts                 # Event-related types
├── sponsor.ts               # Sponsor-related types
├── user.ts                  # User-related types
└── ...
```

## Best Practices

1. **Component Organization**:
   - Keep components focused on a single responsibility
   - Use index.ts files to re-export components for cleaner imports
   - Group related components in subdirectories

2. **Naming Conventions**:
   - Use kebab-case for file names
   - Use PascalCase for component names
   - Use descriptive names that indicate the component's purpose

3. **Code Splitting**:
   - Leverage Next.js's built-in code splitting
   - Use dynamic imports for large components that aren't needed immediately

4. **State Management**:
   - Use React Context for global state when needed
   - Keep state as local as possible
   - Consider using React Query for server state management

5. **Component Composition**:
   - Build complex UIs by composing smaller components
   - Use the Compound Component pattern for related components

6. **Styling**:
   - Use Tailwind CSS for styling (as configured with shadcn/ui)
   - Use the `cn()` utility for conditional class names
   - Keep styles close to the components they affect

7. **Documentation**:
   - Add JSDoc comments to components and functions
   - Document props using TypeScript interfaces
   - Create example usage in comments for complex components

## Implementation Strategy

1. Start by creating the basic directory structure
2. Set up the core UI components from shadcn/ui
3. Build layout components (header, footer, etc.)
4. Implement page templates and routes
5. Add feature-specific components
6. Integrate with data sources and APIs

This structure provides a solid foundation for our shadcn/ui implementation while maintaining flexibility for future growth and changes. 