# Event Pages Implementation Plan

## Overview

This document outlines the implementation plan for the event-related pages of the Fashionistas platform, specifically:
1. Event Listings Page - A comprehensive view of all fashion events
2. Event Details Page - Detailed information about a specific event

The implementation will follow a component-based architecture using Next.js, React, and Tailwind CSS, with data to be sourced from Supabase in the future.

## Table of Contents
- [Design System](#design-system)
- [Dark Theme Strategy](#dark-theme-strategy)
- [Event Listings Page](#event-listings-page)
- [Event Details Page](#event-details-page)
- [Component Architecture](#component-architecture)
- [State Management](#state-management)
- [Routing Strategy](#routing-strategy)
- [Responsive Design Approach](#responsive-design-approach)
- [Accessibility Considerations](#accessibility-considerations)
- [Performance Optimizations](#performance-optimizations)
- [Implementation Timeline](#implementation-timeline)

## Design System

We'll utilize the existing design system as documented in `event-listings-setup.md`, which includes:

### Color Palette
```css
:root {
  /* Light Theme Colors */
  /* Brand Colors */
  --primary-100: #E6F3FF;
  --primary-500: #2B6CB0;
  --primary-900: #1A365D;
  
  /* Accent Colors */
  --accent-500: #ED64A6;
  --accent-600: #D53F8C;
  
  /* Neutral Colors */
  --gray-50: #F7FAFC;
  --gray-100: #EDF2F7;
  --gray-300: #E2E8F0;
  --gray-500: #718096;
  --gray-700: #4A5568;
  --gray-900: #1A202C;
  
  /* Dark Theme Colors */
  --dark-bg-primary: #121212;
  --dark-bg-secondary: #1E1E1E;
  --dark-bg-elevated: #2D2D2D;
  --dark-text-primary: #F7FAFC;
  --dark-text-secondary: #A0AEC0;
  --dark-text-muted: #718096;
  --dark-border: #2D3748;
  --dark-primary-100: #1A365D;
  --dark-primary-500: #4299E1;
  --dark-primary-900: #BEE3F8;
  --dark-accent-500: #F687B3;
  --dark-accent-600: #ED64A6;
}
```

### Typography
```css
:root {
  /* Font Families */
  --font-primary: 'Inter', sans-serif;
  --font-display: 'Playfair Display', serif;

  /* Font Scale */
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px */
  --text-lg: 1.125rem;   /* 18px */
  --text-xl: 1.25rem;    /* 20px */
  --text-2xl: 1.5rem;    /* 24px */
  --text-3xl: 1.875rem;  /* 30px */
  --text-4xl: 2.25rem;   /* 36px */
}
```

## Dark Theme Strategy

The platform will implement a comprehensive dark theme that enhances the fashion event experience while reducing eye strain and providing a premium, elegant aesthetic.

### Theme Implementation

1. **CSS Variables Approach**
   ```css
   /* Base theme variables */
   :root {
     /* Common variables shared between themes */
   }
   
   /* Light theme (default) */
   :root {
     --bg-primary: var(--gray-50);
     --bg-secondary: var(--gray-100);
     --text-primary: var(--gray-900);
     --text-secondary: var(--gray-700);
     /* ... other mappings */
   }
   
   /* Dark theme */
   [data-theme="dark"] {
     --bg-primary: var(--dark-bg-primary);
     --bg-secondary: var(--dark-bg-secondary);
     --text-primary: var(--dark-text-primary);
     --text-secondary: var(--dark-text-secondary);
     /* ... other mappings */
   }
   ```

2. **Tailwind Configuration**
   ```javascript
   // tailwind.config.js
   module.exports = {
     darkMode: 'class', // or 'media' for system preference
     theme: {
       extend: {
         colors: {
           // Custom colors that work in both light and dark modes
         },
         backgroundColor: {
           // Custom background colors
         },
         // ... other extensions
       }
     }
   }
   ```

### Theme Switching

1. **User Preference Detection**
   - Detect system preference using `prefers-color-scheme` media query
   - Store user preference in local storage
   - Provide seamless transition between themes

2. **Theme Toggle Component**
   - Accessible toggle button with appropriate ARIA attributes
   - Visual indicator of current theme
   - Smooth transition animations between themes

### Dark Theme Design Principles

1. **Contrast and Readability**
   - Maintain WCAG AA contrast ratios (minimum 4.5:1 for normal text)
   - Use slightly desaturated colors to reduce eye strain
   - Avoid pure black backgrounds (use dark grays instead)

2. **Visual Hierarchy**
   - Maintain clear visual hierarchy with appropriate contrast
   - Use subtle elevation with shadows or slight color variations
   - Ensure interactive elements remain easily identifiable

3. **Color Psychology**
   - Leverage darker shades of brand colors to maintain identity
   - Use accent colors strategically to highlight important elements
   - Create a sophisticated, premium feel appropriate for fashion events

4. **Image and Media Treatment**
   - Apply subtle darkening overlay to images when in dark mode
   - Ensure media content remains vibrant while fitting the dark aesthetic
   - Consider different image treatments for light vs. dark themes

### Component-Specific Dark Theme Considerations

1. **Event Cards**
   - Elevated card background with subtle borders
   - High contrast for important information (date, title)
   - Subtle hover effects with increased elevation

2. **Form Elements**
   - Darker input backgrounds with lighter borders
   - Clear focus states with brand color highlights
   - Consistent styling across all input types

3. **Buttons and CTAs**
   - Maintain brand colors for primary actions
   - Use more subdued colors for secondary actions
   - Ensure sufficient contrast for text and icons

4. **Modal Dialogs**
   - Slightly elevated background color
   - Subtle shadow to create depth
   - Clear visual separation from background content

### Implementation Approach

1. **Component-Based Theme Properties**
   - Define theme properties at the component level
   - Use CSS variables or Tailwind classes consistently
   - Create theme-aware component variants

2. **Theme Context Provider**
   ```jsx
   // ThemeProvider.jsx
   const ThemeContext = createContext();
   
   export const ThemeProvider = ({ children }) => {
     const [theme, setTheme] = useState('light');
     
     // Toggle theme function
     const toggleTheme = () => {
       const newTheme = theme === 'light' ? 'dark' : 'light';
       setTheme(newTheme);
       document.documentElement.setAttribute('data-theme', newTheme);
       localStorage.setItem('theme', newTheme);
     };
     
     // Initialize theme from local storage or system preference
     useEffect(() => {
       // Implementation details
     }, []);
     
     return (
       <ThemeContext.Provider value={{ theme, toggleTheme }}>
         {children}
       </ThemeContext.Provider>
     );
   };
   ```

3. **Theme Hook**
   ```jsx
   // useTheme.js
   export const useTheme = () => {
     const context = useContext(ThemeContext);
     if (context === undefined) {
       throw new Error('useTheme must be used within a ThemeProvider');
     }
     return context;
   };
   ```

## Event Listings Page

### Page Structure
1. **Hero Section**
   - Dynamic background with fashion event imagery
   - Main title and subtitle
   - Primary CTA button

2. **Search & Filter Section**
   - Search bar for event name, designer, or location
   - Filter options (Event Type, Date Range, Price Range, Location)
   - Sort options (Date, Price, Popularity)
   - Toggle between grid and calendar views

3. **Events Grid**
   - Responsive grid of event cards
   - Pagination or infinite scroll
   - Empty state handling

4. **Calendar View** (Alternative to Grid)
   - Monthly/weekly toggle
   - Event indicators on dates
   - Quick preview on hover

5. **Special Offers Section**
   - Promotional cards for early bird, group bookings, etc.
   - CTA buttons for each offer

6. **Event Categories Section**
   - Visual cards for different event types
   - Count of upcoming events per category

7. **FAQ Section**
   - Collapsible questions and answers
   - Link to full FAQ page

8. **Newsletter Subscription**
   - Email input
   - Preference selection
   - Submit button

### Data Model (Placeholder)
```typescript
interface EventListing {
  id: string;
  title: string;
  date: string;
  time: string;
  location: string;
  venue: string;
  category: string;
  status: 'Early Bird' | 'Coming Soon' | 'Sold Out' | 'Available';
  priceRange: {
    min: number;
    max: number;
    currency: string;
  };
  featuredImage: string;
  designers: string[];
}
```

### Component Breakdown
1. `EventCard` - Individual event preview
2. `FilterSidebar` - Collapsible filter options
3. `SearchSortBar` - Search and sorting controls
4. `EventGrid` - Container for event cards
5. `CalendarView` - Alternative event display
6. `Pagination` - Page navigation
7. `CategoryCard` - Event category preview
8. `PromotionCard` - Special offer display
9. `FAQAccordion` - Collapsible FAQ items
10. `NewsletterForm` - Email subscription

## Event Details Page

### Page Structure
1. **Hero Section**
   - Large feature image or carousel
   - Event title and tagline
   - Key event details (date, time, location)
   - Primary CTA button

2. **Event Overview**
   - Date, time, location with map
   - Price range
   - Category and status
   - Share buttons

3. **Event Description**
   - Rich text description
   - Event highlights

4. **Featured Designers**
   - Designer cards with images
   - Brief description
   - Link to designer profile

5. **Venue & Facilities**
   - Venue information
   - Amenities list
   - Location map

6. **Ticket Packages**
   - Pricing tiers
   - Package details
   - Purchase buttons

7. **Schedule**
   - Timeline of event activities
   - Visual timeline representation

8. **Sponsors**
   - Sponsor logos and categories
   - Sponsor information

9. **Gallery**
   - Images from past similar events
   - Video content if available

10. **Related Events**
    - Cards for similar or upcoming events
    - "More events" link

11. **Call to Action Section**
    - Primary and secondary CTAs
    - Countdown timer if applicable

### Data Model (Placeholder)
```typescript
interface EventDetail extends EventListing {
  description: string;
  highlights: {
    title: string;
    description: string;
  }[];
  designers: {
    id: string;
    name: string;
    image: string;
    description: string;
    collections: string[];
  }[];
  venue: {
    name: string;
    address: string;
    mapUrl: string;
    facilities: string[];
  };
  ticketPackages: {
    id: string;
    name: string;
    price: number;
    currency: string;
    description: string;
    benefits: string[];
    available: boolean;
  }[];
  schedule: {
    time: string;
    activity: string;
  }[];
  sponsors: {
    category: string;
    companies: {
      name: string;
      logo: string;
    }[];
  }[];
  gallery: {
    type: 'image' | 'video';
    url: string;
    caption?: string;
  }[];
  relatedEvents: string[]; // IDs of related events
}
```

### Component Breakdown
1. `EventHero` - Hero section with key details
2. `EventOverview` - Summary of event information
3. `DesignerCard` - Featured designer information
4. `VenueInfo` - Venue details and map
5. `TicketPackage` - Individual ticket tier
6. `EventSchedule` - Timeline of activities
7. `SponsorSection` - Sponsor logos and info
8. `EventGallery` - Image/video gallery
9. `RelatedEventCard` - Similar event preview
10. `EventCTA` - Call to action section

## Component Architecture

### Shared Components
1. `Button` - Reusable button component with variants
2. `Card` - Base card component
3. `Badge` - Status indicators
4. `Icon` - SVG icon system
5. `Modal` - Popup dialogs
6. `Tabs` - Tabbed interface
7. `Dropdown` - Select menus
8. `Tooltip` - Informational tooltips
9. `Breadcrumbs` - Navigation aid
10. `LoadingSpinner` - Loading state indicator

### Layout Components
1. `PageLayout` - Base page structure
2. `Header` - Site navigation
3. `Footer` - Site footer
4. `Container` - Content container
5. `Grid` - Responsive grid system
6. `Sidebar` - Side navigation or filters

## State Management

1. **Local Component State**
   - UI state (open/closed, active tab)
   - Form inputs

2. **React Query** (for future implementation)
   - Event data fetching
   - Caching strategy
   - Pagination state

3. **URL State**
   - Filter parameters
   - Search queries
   - Pagination

## Routing Strategy

1. **Event Listings**
   - Main route: `/events`
   - Filtered: `/events?category=runway&date=march-2025`

2. **Event Details**
   - Dynamic routes: `/events/[slug]`
   - Example: `/events/spring-bloom-2025`

3. **Category Pages**
   - `/events/categories/[category]`
   - Example: `/events/categories/runway`

## Responsive Design Approach

1. **Mobile-First Development**
   - Design for smallest screens first
   - Progressive enhancement for larger screens

2. **Breakpoints**
   - Small (sm): 640px
   - Medium (md): 768px
   - Large (lg): 1024px
   - Extra Large (xl): 1280px

3. **Layout Adjustments**
   - Stack elements vertically on mobile
   - Side-by-side on larger screens
   - Collapsible filters on mobile
   - Reduced image sizes on mobile

4. **Touch-Friendly Interfaces**
   - Larger tap targets on mobile
   - Swipe gestures where appropriate

## Accessibility Considerations

1. **Semantic HTML**
   - Proper heading hierarchy
   - ARIA roles and attributes
   - Keyboard navigation

2. **Color Contrast**
   - WCAG AA compliance minimum
   - Text legibility on all backgrounds

3. **Screen Reader Support**
   - Alt text for images
   - ARIA labels for interactive elements
   - Skip navigation links

4. **Keyboard Navigation**
   - Focus indicators
   - Logical tab order
   - Keyboard shortcuts where appropriate

## Performance Optimizations

1. **Image Optimization**
   - Next.js Image component
   - Responsive images
   - WebP format with fallbacks
   - Lazy loading

2. **Code Splitting**
   - Component-level code splitting
   - Dynamic imports for heavy components

3. **Lazy Loading**
   - Below-the-fold content
   - Non-critical resources

4. **Caching Strategy** (for future implementation)
   - Browser caching
   - React Query caching
   - Service worker for offline support

## Implementation Timeline

### Phase 1: Setup and Core Components
- Project structure setup
- Design system implementation
- Core shared components
- Basic layout components
- Dark theme foundation and toggle mechanism

### Phase 2: Event Listings Page
- Hero section
- Search and filter functionality
- Event grid implementation
- Responsive design
- Dark theme styling for listings page

### Phase 3: Event Details Page
- Hero and overview sections
- Designer and venue information
- Ticket packages
- Schedule and gallery
- Dark theme styling for details page

### Phase 4: Enhanced Features
- Calendar view
- Special offers section
- Related events
- Animation and transitions
- Dark theme refinements and polish

### Phase 5: Database Integration (Future)
- Supabase setup
- API integration
- Data fetching and caching
- Authentication and authorization
- Theme preference persistence in user profiles

### Phase 6: Testing and Optimization
- Unit and integration testing
- Performance optimization
- Accessibility audit
- Browser compatibility testing
- Dark theme accessibility and contrast testing

## Dark Theme Mockups

### Event Listings Page (Dark Theme)

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    HERO SECTION                      │    │
│  │                                                      │    │
│  │  Upcoming Fashion Events                             │    │
│  │  Discover and Book Your Next Fashion Experience      │    │
│  │                                                      │    │
│  │  [Filter Events]                                     │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────┐  ┌─────────────────────────────────────┐   │
│  │             │  │                                     │   │
│  │  FILTERS    │  │  SEARCH & SORT                      │   │
│  │             │  │                                     │   │
│  │  Date       │  │  ┌─────────────────────────────┐   │   │
│  │  Category   │  │  │ Search events...            │   │   │
│  │  Price      │  │  └─────────────────────────────┘   │   │
│  │  Location   │  │                                     │   │
│  │             │  │  Sort by: ▼ Date                    │   │
│  │             │  │                                     │   │
│  └─────────────┘  └─────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │             │  │             │  │             │         │
│  │  EVENT      │  │  EVENT      │  │  EVENT      │         │
│  │  CARD       │  │  CARD       │  │  CARD       │         │
│  │             │  │             │  │             │         │
│  │  Mar 14     │  │  Mar 28     │  │  Apr 15     │         │
│  │  Spring     │  │  Spring     │  │  Spring     │         │
│  │  Swim 2025  │  │  Bloom 2025 │  │  Collection │         │
│  │             │  │             │  │             │         │
│  │  Early Bird │  │  Coming     │  │  Register   │         │
│  │             │  │  Soon       │  │  Soon       │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Event Details Page (Dark Theme)

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    HERO SECTION                      │    │
│  │                                                      │    │
│  │  Spring Bloom 2025                                   │    │
│  │  Blossom into Fashion                                │    │
│  │                                                      │    │
│  │  [Sign Up]                                           │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  EVENT OVERVIEW                                      │    │
│  │                                                      │    │
│  │  Date: March 28th, 2025                              │    │
│  │  Time: 8:00 PM - 2:00 AM                             │    │
│  │  Location: Dulcinea Nightclub                        │    │
│  │  Category: Spring Fashion                            │    │
│  │  Status: Coming Soon                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  EVENT DESCRIPTION                                   │    │
│  │                                                      │    │
│  │  Experience the beauty of spring fashion at Spring   │    │
│  │  Bloom 2025. This enchanting showcase features       │    │
│  │  exquisite collections from Colombian designers.     │    │
│  │                                                      │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │             │  │             │  │             │         │
│  │  DESIGNER   │  │  DESIGNER   │  │  DESIGNER   │         │
│  │  CARD       │  │  CARD       │  │  CARD       │         │
│  │             │  │             │  │             │         │
│  │  Bloom &    │  │  Garden     │  │  Flora      │         │
│  │  Petal      │  │  Glamour    │  │  Fashion    │         │
│  │             │  │             │  │  House      │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Dark Theme Component Examples

### Button Component

```jsx
// Button.tsx
import { useTheme } from '@/hooks/useTheme';
import { cva } from 'class-variance-authority';

const buttonStyles = cva(
  "font-medium rounded-md transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2",
  {
    variants: {
      intent: {
        primary: [
          "bg-primary-500 text-white hover:bg-primary-600",
          "dark:bg-dark-primary-500 dark:hover:bg-blue-500 dark:focus:ring-blue-400",
        ],
        secondary: [
          "bg-gray-200 text-gray-900 hover:bg-gray-300",
          "dark:bg-dark-bg-elevated dark:text-dark-text-primary dark:hover:bg-gray-700",
        ],
        accent: [
          "bg-accent-500 text-white hover:bg-accent-600",
          "dark:bg-dark-accent-500 dark:hover:bg-pink-500",
        ],
      },
      size: {
        sm: "py-1 px-3 text-sm",
        md: "py-2 px-4 text-base",
        lg: "py-3 px-6 text-lg",
      },
    },
    defaultVariants: {
      intent: "primary",
      size: "md",
    },
  }
);

export const Button = ({ 
  children, 
  intent, 
  size, 
  className, 
  ...props 
}) => {
  const { theme } = useTheme();
  
  return (
    <button
      className={buttonStyles({ intent, size, className })}
      data-theme={theme}
      {...props}
    >
      {children}
    </button>
  );
};
```

### Event Card Component

```jsx
// EventCard.tsx
import { useTheme } from '@/hooks/useTheme';
import Image from 'next/image';
import Link from 'next/link';

export const EventCard = ({ event }) => {
  const { theme } = useTheme();
  
  return (
    <div 
      className={`
        rounded-lg overflow-hidden transition-all duration-300 hover:transform hover:scale-[1.02]
        ${theme === 'light' 
          ? 'bg-white border border-gray-200 shadow-sm hover:shadow-md' 
          : 'bg-dark-bg-elevated border border-dark-border shadow-lg hover:shadow-xl'
        }
      `}
    >
      <div className="relative h-48 w-full">
        <Image
          src={event.featuredImage}
          alt={event.title}
          fill
          className="object-cover"
        />
        <div 
          className={`
            absolute inset-0 
            ${theme === 'dark' ? 'bg-black bg-opacity-20' : ''}
          `}
        />
        <div 
          className={`
            absolute top-4 left-4 px-2 py-1 rounded-md text-xs font-medium
            ${theme === 'light' 
              ? 'bg-primary-100 text-primary-900' 
              : 'bg-dark-primary-100 text-dark-primary-900'
            }
          `}
        >
          {new Date(event.date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
        </div>
      </div>
      
      <div className="p-4">
        <h3 
          className={`
            text-lg font-semibold mb-1
            ${theme === 'light' ? 'text-gray-900' : 'text-dark-text-primary'}
          `}
        >
          {event.title}
        </h3>
        
        <p 
          className={`
            text-sm mb-3
            ${theme === 'light' ? 'text-gray-600' : 'text-dark-text-secondary'}
          `}
        >
          {event.venue}
        </p>
        
        <div className="flex justify-between items-center">
          <span 
            className={`
              text-xs font-medium px-2 py-1 rounded-full
              ${event.status === 'Early Bird' 
                ? theme === 'light' 
                  ? 'bg-green-100 text-green-800' 
                  : 'bg-green-900 bg-opacity-30 text-green-400'
                : event.status === 'Coming Soon'
                  ? theme === 'light'
                    ? 'bg-yellow-100 text-yellow-800'
                    : 'bg-yellow-900 bg-opacity-30 text-yellow-400'
                  : theme === 'light'
                    ? 'bg-blue-100 text-blue-800'
                    : 'bg-blue-900 bg-opacity-30 text-blue-400'
              }
            `}
          >
            {event.status}
          </span>
          
          <Link 
            href={`/events/${event.slug}`}
            className={`
              text-sm font-medium
              ${theme === 'light' 
                ? 'text-primary-500 hover:text-primary-700' 
                : 'text-dark-primary-500 hover:text-blue-400'
              }
            `}
          >
            View details →
          </Link>
        </div>
      </div>
    </div>
  );
};
```

### Search Input Component

```jsx
// SearchInput.tsx
import { useTheme } from '@/hooks/useTheme';
import { SearchIcon } from '@/components/icons/SearchIcon';

export const SearchInput = ({ placeholder, value, onChange }) => {
  const { theme } = useTheme();
  
  return (
    <div className="relative">
      <div 
        className={`
          absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none
          ${theme === 'light' ? 'text-gray-500' : 'text-dark-text-muted'}
        `}
      >
        <SearchIcon className="w-5 h-5" />
      </div>
      
      <input
        type="text"
        value={value}
        onChange={onChange}
        className={`
          block w-full pl-10 pr-3 py-2 rounded-md text-sm
          focus:outline-none focus:ring-2
          ${theme === 'light' 
            ? 'bg-white border border-gray-300 text-gray-900 focus:border-primary-500 focus:ring-primary-500' 
            : 'bg-dark-bg-secondary border border-dark-border text-dark-text-primary focus:border-dark-primary-500 focus:ring-dark-primary-500'
          }
        `}
        placeholder={placeholder}
      />
    </div>
  );
};
```

### Theme Toggle Component

```jsx
// ThemeToggle.tsx
import { useTheme } from '@/hooks/useTheme';
import { SunIcon, MoonIcon } from '@/components/icons';

export const ThemeToggle = () => {
  const { theme, toggleTheme } = useTheme();
  
  return (
    <button
      onClick={toggleTheme}
      className={`
        p-2 rounded-full transition-colors
        ${theme === 'light' 
          ? 'bg-gray-200 hover:bg-gray-300 text-gray-800' 
          : 'bg-dark-bg-elevated hover:bg-gray-700 text-dark-text-primary'
        }
      `}
      aria-label={`Switch to ${theme === 'light' ? 'dark' : 'light'} mode`}
    >
      {theme === 'light' ? (
        <MoonIcon className="w-5 h-5" />
      ) : (
        <SunIcon className="w-5 h-5" />
      )}
    </button>
  );
};
```

## Next Steps

1. Implement the core shared components
2. Set up the dark theme infrastructure and toggle mechanism
3. Develop the event listings page structure with dark theme support
4. Create the event details page template with dark theme styling
5. Integrate static data for initial development
6. Prepare for future database integration 