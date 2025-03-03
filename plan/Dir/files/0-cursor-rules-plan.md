# Fashionistas Platform - Cursor Rules Documentation

## Introduction

This document defines the comprehensive cursor rules for the Fashionistas platform, ensuring consistent development practices, efficient code organization, and seamless integration across all platform components. These rules are designed to enhance developer productivity, maintain code quality, and facilitate seamless collaboration.

## 1. Core Rule Categories

### 1.1 File Organization Rules

#### Directory Structure
```
fashionistas/
├── src/
│   ├── components/      # Reusable UI components
│   ├── features/        # Feature-specific modules
│   ├── hooks/          # Custom React hooks
│   ├── api/            # API integration layer
│   ├── store/          # State management
│   ├── utils/          # Utility functions
│   ├── styles/         # Global styles
│   └── types/          # TypeScript type definitions
├── public/             # Static assets
└── docs/              # Documentation
```

#### Naming Conventions
- Files: `kebab-case.tsx` for components
- Directories: `kebab-case` for feature modules
- Types: `PascalCase` for interfaces and types
- Constants: `UPPER_SNAKE_CASE` for global constants
- Functions: `camelCase` for utilities and hooks

#### Module Organization
```typescript
// Standard module structure
import { Dependencies } from '@external/lib'
import { InternalDeps } from '@/internal'
import { Types } from '@/types'

// Constants
export const CONFIG = { ... }

// Types
export interface ComponentProps { ... }

// Component/Function
export const Component = () => { ... }
```

#### Asset Management
- Images: `/public/images/<feature>/<asset>.webp`
- Icons: `/public/icons/<category>/<icon>.svg`
- Fonts: `/public/fonts/<font-family>/<weight>.woff2`

### 1.2 Code Style Rules

#### TypeScript Standards
```typescript
// Use explicit types for props
interface ButtonProps {
  variant: 'primary' | 'secondary';
  onClick: () => void;
  children: React.ReactNode;
}

// Use function declarations for components
export function Button({ variant, onClick, children }: ButtonProps) {
  return (
    <button 
      className={`btn-${variant}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
}
```

#### React Patterns
```typescript
// Use custom hooks for complex logic
function useEventData(eventId: string) {
  const [event, setEvent] = useState<Event | null>(null);
  
  useEffect(() => {
    // Fetch and manage event data
  }, [eventId]);
  
  return { event };
}

// Use composition over inheritance
function EventCard({ event, onAction }: EventCardProps) {
  return (
    <Card>
      <EventHeader event={event} />
      <EventDetails event={event} />
      <EventActions onAction={onAction} />
    </Card>
  );
}
```

#### CSS Organization
```scss
// Use CSS modules with component-scoped styles
.container {
  display: flex;
  gap: var(--spacing-md);
  
  @media (max-width: 768px) {
    flex-direction: column;
  }
  
  .content {
    flex: 1;
  }
}
```

### 1.3 Integration Rules

#### API Integration
```typescript
// Use centralized API client
export const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 10000,
});

// Use typed responses
interface ApiResponse<T> {
  data: T;
  meta: ResponseMetadata;
}

// Implement error handling
export async function fetchEvent<T>(id: string): Promise<ApiResponse<T>> {
  try {
    const response = await apiClient.get(`/events/${id}`);
    return response.data;
  } catch (error) {
    handleApiError(error);
    throw error;
  }
}
```

#### Authentication
```typescript
// Use auth middleware
export const withAuth = (handler: NextApiHandler): NextApiHandler => {
  return async (req, res) => {
    try {
      const session = await getSession(req);
      if (!session) {
        return res.status(401).json({ error: 'Unauthorized' });
      }
      return handler(req, res);
    } catch (error) {
      return res.status(500).json({ error: 'Internal Server Error' });
    }
  };
};
```

### 1.4 Performance Rules

#### Load Time Optimization
```typescript
// Use dynamic imports for routes
const EventDashboard = dynamic(() => import('@/features/events/EventDashboard'), {
  loading: () => <LoadingSpinner />,
});

// Implement image optimization
<Image
  src={eventImage}
  alt={eventTitle}
  width={800}
  height={400}
  placeholder="blur"
  loading="lazy"
/>
```

#### Caching Strategy
```typescript
// Implement SWR for data fetching
function useEventData(eventId: string) {
  const { data, error } = useSWR(
    `/api/events/${eventId}`,
    fetcher,
    {
      revalidateOnFocus: false,
      revalidateOnReconnect: true,
    }
  );
  
  return {
    event: data,
    isLoading: !error && !data,
    isError: error
  };
}
```

## 2. Feature-Specific Rules

### 2.1 Event Management
```typescript
{
  "glob": "src/features/events/**/*",
  "rules": [
    {
      "name": "Hi.Events SDK Usage",
      "pattern": "import { HiEvents } from '@hi-events/sdk'",
      "message": "Always use Hi.Events SDK for event operations"
    },
    {
      "name": "Error Boundaries",
      "pattern": "class EventErrorBoundary extends React.Component",
      "message": "Implement error boundaries for event components"
    }
  ]
}
```

### 2.2 CRM Integration
```typescript
{
  "glob": "src/features/crm/**/*",
  "rules": [
    {
      "name": "Twenty CRM SDK",
      "pattern": "import { TwentyCRM } from '@twenty/sdk'",
      "message": "Use Twenty CRM SDK for all CRM operations"
    },
    {
      "name": "Pipeline Tracking",
      "pattern": "usePipelineTracking",
      "message": "Implement standard pipeline tracking"
    }
  ]
}
```

## 3. Component Rules

### 3.1 UI Components
```typescript
{
  "glob": "src/components/ui/**/*",
  "rules": [
    {
      "name": "Atomic Design",
      "folders": ["atoms", "molecules", "organisms"],
      "message": "Follow atomic design structure"
    },
    {
      "name": "Accessibility",
      "pattern": "aria-*",
      "message": "Implement ARIA attributes"
    }
  ]
}
```

## 4. Testing Rules
```typescript
{
  "glob": "src/**/*.test.ts",
  "rules": [
    {
      "name": "Testing Library",
      "pattern": "import { render, screen } from '@testing-library/react'",
      "message": "Use React Testing Library for component tests"
    },
    {
      "name": "Coverage",
      "threshold": 80,
      "message": "Maintain minimum 80% test coverage"
    }
  ]
}
```

## Maintenance and Updates

### Review Schedule
- Weekly: Code style and linting rules
- Monthly: Integration patterns and performance metrics
- Quarterly: Full documentation review

### Enforcement
```json
{
  "hooks": {
    "pre-commit": [
      "lint-staged",
      "type-check",
      "test-affected"
    ],
    "pre-push": [
      "full-test",
      "build-check"
    ]
  }
}
```

### Training Resources
1. Onboarding Documentation
   - Setup guide
   - Development workflow
   - Common patterns
   
2. Example Repositories
   - Component library
   - Feature templates
   - Integration examples

## Success Metrics

1. Code Quality
   - Maintainability Index > 85
   - Test Coverage > 80%
   - Zero critical security issues

2. Developer Experience
   - Build time < 2 minutes
   - Hot reload < 2 seconds
   - Clear error messages

3. Performance
   - First Load < 3s
   - Time to Interactive < 4s
   - Lighthouse score > 90

This documentation serves as the single source of truth for Fashionistas platform development practices. All team members are expected to follow these guidelines to maintain consistency and quality across the codebase.
