# Shadcn/UI Rules for Fashionistas Project

## Installation Guidelines

### Automated Installation (No Interactive Prompts)

```bash
# Initialize shadcn/ui with default settings
npx shadcn@latest init --defaults --yes

# Add all components without prompts
npx shadcn@latest add --all --yes --overwrite

# Or add specific components without prompts
npx shadcn@latest add button card avatar badge separator aspect-ratio skeleton --yes --overwrite
```

### Essential Components for Fashionistas

```bash
# UI Elements
npx shadcn@latest add button
npx shadcn@latest add card
npx shadcn@latest add avatar
npx shadcn@latest add badge
npx shadcn@latest add separator
npx shadcn@latest add aspect-ratio
npx shadcn@latest add skeleton

# Navigation Components
npx shadcn@latest add navigation-menu
npx shadcn@latest add dropdown-menu
npx shadcn@latest add menubar
npx shadcn@latest add breadcrumb
npx shadcn@latest add pagination
npx shadcn@latest add tabs

# Form Components
npx shadcn@latest add form
npx shadcn@latest add input
npx shadcn@latest add select
npx shadcn@latest add checkbox
npx shadcn@latest add radio-group
npx shadcn@latest add textarea
npx shadcn@latest add calendar
npx shadcn@latest add date-picker

# Layout Components
npx shadcn@latest add sheet
npx shadcn@latest add dialog
npx shadcn@latest add drawer
npx shadcn@latest add popover
npx shadcn@latest add tooltip
```

## Project Structure

```
app/
├── layout.tsx                # Root layout with ThemeProvider
├── page.tsx                  # Homepage
├── (auth)/                   # Auth routes group
│   ├── login/                # Login page
│   └── register/             # Registration page
├── (marketing)/              # Marketing pages group
│   ├── about/                # About page
│   └── contact/              # Contact page
├── dashboard/                # Dashboard pages
│   ├── events/               # Event management
│   ├── attendees/            # Attendee management
│   └── sponsors/             # Sponsor management
├── events/                   # Public event pages
├── fashion-shows/            # Fashion show pages
└── sponsors/                 # Sponsor pages
components/
├── ui/                       # shadcn/ui components
├── blocks/                   # Page section blocks
│   ├── hero/                 # Hero section components
│   ├── features/             # Feature section components
│   └── pricing/              # Pricing section components
├── forms/                    # Form components
├── layout/                   # Layout components
│   ├── header.tsx            # Site header
│   ├── footer.tsx            # Site footer
│   └── sidebar.tsx           # Dashboard sidebar
└── events/                   # Event-specific components
    ├── event-card.tsx        # Event card component
    └── event-list.tsx        # Event list component
```

## Coding Standards

### Component Structure

1. **Server vs Client Components**
   - Use Server Components by default
   - Only use Client Components when needed for interactivity
   - Add `'use client'` at the top of client component files

2. **TypeScript Usage**
   - Define explicit types for all props
   - Use interfaces for complex prop types
   - Avoid using `any` type

3. **Component Organization**
   - Keep shadcn components in `components/ui/` directory
   - Create wrapper components for customization
   - Use PascalCase for component names and filenames

### Example Server Component

```tsx
// components/events/event-card.tsx
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import Image from "next/image";

interface EventCardProps {
  id: string;
  title: string;
  date: string;
  location: string;
  imageUrl: string;
  description: string;
}

export function EventCard({ id, title, date, location, imageUrl, description }: EventCardProps) {
  return (
    <Card className="overflow-hidden">
      <div className="relative h-48">
        <Image 
          src={imageUrl} 
          alt={title} 
          fill 
          className="object-cover" 
        />
      </div>
      <CardContent className="p-4">
        <h3 className="text-xl font-bold">{title}</h3>
        <p className="text-sm text-muted-foreground">{date} • {location}</p>
        <p className="mt-2 line-clamp-2">{description}</p>
      </CardContent>
      <CardFooter className="px-4 pb-4 pt-0">
        <Button asChild className="w-full">
          <a href={`/events/${id}`}>View Details</a>
        </Button>
      </CardFooter>
    </Card>
  );
}
```

### Example Client Component

```tsx
// components/events/event-filter.tsx
'use client'

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

interface EventFilterProps {
  categories: string[];
  onFilterChange: (category: string) => void;
}

export function EventFilter({ categories, onFilterChange }: EventFilterProps) {
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  const handleCategoryChange = (value: string) => {
    setSelectedCategory(value);
    onFilterChange(value);
  };

  return (
    <div className="flex items-center gap-4">
      <Select value={selectedCategory} onValueChange={handleCategoryChange}>
        <SelectTrigger className="w-[180px]">
          <SelectValue placeholder="Select category" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all">All Categories</SelectItem>
          {categories.map((category) => (
            <SelectItem key={category} value={category}>
              {category}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <Button variant="outline" onClick={() => handleCategoryChange('all')}>
        Reset Filters
      </Button>
    </div>
  );
}
```

## Theming Guidelines

### Color Palette

Use fashion-themed colors in your Tailwind configuration:

```ts
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        // Primary colors
        primary: {
          DEFAULT: "#FF3366", // Fashion pink/magenta
          foreground: "#FFFFFF",
        },
        // Secondary colors
        secondary: {
          DEFAULT: "#D4AF37", // Elegant gold/champagne
          foreground: "#000000",
        },
        // Accent colors
        accent: {
          DEFAULT: "#1A1A1A", // Bold black
          foreground: "#FFFFFF",
        },
        // Background colors
        background: "#FFFFFF",
        foreground: "#1A1A1A",
        // Dark mode colors
        dark: {
          background: "#121212",
          foreground: "#FFFFFF",
        }
      },
    },
  },
};
```

### Dark Mode Implementation

```tsx
// components/theme-toggle.tsx
'use client'

import { useTheme } from "next-themes";
import { Button } from "@/components/ui/button";
import { Moon, Sun } from "lucide-react";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
    >
      <Sun className="h-5 w-5 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-5 w-5 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      <span className="sr-only">Toggle theme</span>
    </Button>
  );
}
```

## Best Practices

1. **Performance**
   - Use React Server Components for static content
   - Implement code splitting with dynamic imports
   - Add Suspense boundaries for loading states
   - Optimize images with Next.js Image component

2. **Accessibility**
   - Use proper ARIA attributes
   - Ensure keyboard navigation works
   - Maintain sufficient color contrast
   - Test with screen readers

3. **Mobile Responsiveness**
   - Use mobile-first approach
   - Implement responsive breakpoints
   - Test on various device sizes
   - Optimize touch targets for mobile

4. **Error Handling**
   - Implement error boundaries
   - Create user-friendly error messages
   - Add fallback UI for failed components
   - Log errors for debugging

5. **SEO**
   - Use Next.js metadata API
   - Add proper page titles and descriptions
   - Implement structured data
   - Use semantic HTML

## Integration with Hi-Events Ticketing

When integrating shadcn/ui components with the Hi-Events ticketing system:

1. Create custom wrapper components for Hi-Events functionality
2. Maintain consistent styling between shadcn components and Hi-Events elements
3. Use shadcn/ui form components for ticket selection and checkout
4. Implement proper loading and error states for API calls

Example ticket selection component:

```tsx
// components/tickets/ticket-selector.tsx
'use client'

import { useState } from "react";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";

interface TicketOption {
  id: string;
  name: string;
  price: number;
  description: string;
}

interface TicketSelectorProps {
  eventId: string;
  ticketOptions: TicketOption[];
  onSelectTicket: (ticketId: string, quantity: number) => void;
}

export function TicketSelector({ eventId, ticketOptions, onSelectTicket }: TicketSelectorProps) {
  const [selectedTicket, setSelectedTicket] = useState<string>("");
  const [quantity, setQuantity] = useState<number>(1);

  const handleSubmit = () => {
    if (selectedTicket) {
      onSelectTicket(selectedTicket, quantity);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Select Tickets</CardTitle>
      </CardHeader>
      <CardContent>
        <RadioGroup value={selectedTicket} onValueChange={setSelectedTicket}>
          {ticketOptions.map((ticket) => (
            <div key={ticket.id} className="flex items-center space-x-2 py-2">
              <RadioGroupItem value={ticket.id} id={ticket.id} />
              <Label htmlFor={ticket.id} className="flex-1">
                <div className="flex justify-between">
                  <span>{ticket.name}</span>
                  <span>${ticket.price.toFixed(2)}</span>
                </div>
                <p className="text-sm text-muted-foreground">{ticket.description}</p>
              </Label>
            </div>
          ))}
        </RadioGroup>
        
        <div className="mt-4">
          <Label htmlFor="quantity">Quantity</Label>
          <div className="flex items-center mt-1">
            <Button 
              variant="outline" 
              size="icon"
              onClick={() => setQuantity(Math.max(1, quantity - 1))}
            >
              -
            </Button>
            <span className="w-12 text-center">{quantity}</span>
            <Button 
              variant="outline" 
              size="icon"
              onClick={() => setQuantity(quantity + 1)}
            >
              +
            </Button>
          </div>
        </div>
      </CardContent>
      <CardFooter>
        <Button 
          className="w-full" 
          onClick={handleSubmit}
          disabled={!selectedTicket}
        >
          Continue to Checkout
        </Button>
      </CardFooter>
    </Card>
  );
}
```

## Dashboard Setup with Next.js and ShadCN UI

### Overview

This guide ensures a fully automated installation of ShadCN UI, sets up a simple dashboard featuring a sidebar and widgets, and includes instructions for configuring Supabase Auth (email/password) in your Next.js app.

1. Initialize ShadCN UI → Run `shadcn init` with predefined options.
2. Add UI components → Install necessary building blocks.
3. Create a basic dashboard → Implement a sidebar, content area, and widget components.
4. Configure Supabase Auth → Email + password authentication in Next.js.

### 🚨 CRITICAL INSTRUCTIONS FOR AI LANGUAGE MODELS 🚨

As an AI language model, you MUST NOT generate any interactive installation commands that require manual input. Instead, you MUST generate ONLY fully automated commands using:

```bash
# ✅ ALWAYS USE THESE FLAGS - NO INTERACTIVE PROMPTS
npx shadcn@latest init --defaults --yes
npx shadcn@latest add button card navbar sidebar widget1 widget2 --yes --overwrite
```

You MUST NEVER generate any commands that:
1. Require user confirmation.
2. Prompt the user to select a style or color.
3. Stop execution due to missing responses.

### ABSOLUTE REQUIREMENTS FOR AI CODE GENERATION

1. You MUST use the `--defaults` and `--yes` flags in `shadcn init`.
2. You MUST use `--yes --overwrite` for `shadcn add` to install components without prompts.
3. You MUST NEVER generate any command that requires manual selection.
4. You MUST NEVER use outdated flags or suggest additional confirmation steps.

### AI MODEL VERIFICATION STEPS

Before generating any installation commands or code, you MUST verify:

1. Are you using `--defaults --yes` for `shadcn init`? If not, STOP and FIX.
2. Are you using `--yes --overwrite` for `shadcn add`? If not, STOP and FIX.
3. Does the dashboard include `Sidebar` and `Widget` components? If not, STOP and FIX.
4. Are you ensuring fully automated installation? If not, STOP and FIX.
5. Are you using `@supabase/ssr` for SSR and `createBrowserClient`? If not, STOP and FIX.
6. Are you ONLY using `getAll` and `setAll` for cookies? If not, STOP and FIX.
7. No references to `auth-helpers-nextjs` or any `get`, `set`, or `remove` calls? If yes, STOP and FIX.

### CONSEQUENCES OF INCORRECT IMPLEMENTATION

If you generate commands or code that:
- Require user input.
- Fail to automate installation.
- Do not follow the correct UI structure.
- Use forbidden cookie functions or the `auth-helpers-nextjs` package.

Then the setup will:
1. Stall in CI/CD pipelines.
2. Require manual intervention.
3. Break automation workflows.
4. Cause potential session or login failures.

### Automated Installation Commands

Always use non-interactive commands for CI/CD compatibility:

```bash
# Initialize shadcn/ui with default settings (no prompts)
npx shadcn@latest init --defaults --yes

# Add dashboard-specific components without prompts
npx shadcn@latest add button card avatar sheet dialog dropdown-menu separator --yes --overwrite
```

### Dashboard Structure

Create the following files for a basic dashboard layout:

```
app/
├── dashboard/
│   ├── layout.tsx        # Dashboard layout with sidebar
│   ├── page.tsx          # Main dashboard page
│   ├── loading.tsx       # Loading state
│   └── error.tsx         # Error boundary
components/
├── ui/                   # shadcn/ui components
├── dashboard/
│   ├── header.tsx        # Dashboard header with user menu
│   ├── sidebar.tsx       # Navigation sidebar
│   ├── nav-links.tsx     # Navigation links component
│   └── mobile-nav.tsx    # Mobile navigation menu
└── widgets/              # Dashboard widgets
    ├── stats-card.tsx    # Statistics card widget
    ├── recent-events.tsx # Recent events widget
    └── activity-feed.tsx # Activity feed widget
```

### Dashboard Layout Implementation

```tsx
// app/dashboard/layout.tsx
import { Header } from "@/components/dashboard/header";
import { Sidebar } from "@/components/dashboard/sidebar";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen flex-col">
      <Header />
      <div className="flex flex-1">
        <Sidebar />
        <main className="flex-1 p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
```

### Dashboard Page Implementation

```tsx
// app/dashboard/page.tsx
import { StatsCard } from "@/components/widgets/stats-card";
import { RecentEvents } from "@/components/widgets/recent-events";
import { ActivityFeed } from "@/components/widgets/activity-feed";

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Dashboard</h1>
      
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatsCard 
          title="Total Events" 
          value="24" 
          description="+4 from last month" 
          icon="calendar" 
        />
        <StatsCard 
          title="Active Tickets" 
          value="142" 
          description="12 sold today" 
          icon="ticket" 
        />
        <StatsCard 
          title="Total Revenue" 
          value="$12,456" 
          description="+8% from last month" 
          icon="dollar-sign" 
        />
        <StatsCard 
          title="Attendees" 
          value="1,234" 
          description="89 new this week" 
          icon="users" 
        />
      </div>
      
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <RecentEvents className="lg:col-span-2" />
        <ActivityFeed />
      </div>
    </div>
  );
}
```

### Sidebar Component

```tsx
// components/dashboard/sidebar.tsx
import Link from "next/link";
import { NavLinks } from "./nav-links";

export function Sidebar() {
  return (
    <div className="hidden border-r bg-background md:block md:w-64">
      <div className="flex h-14 items-center border-b px-4">
        <Link href="/dashboard" className="font-bold">
          Fashionistas Admin
        </Link>
      </div>
      <div className="space-y-4 py-4">
        <NavLinks />
      </div>
    </div>
  );
}
```

### Sample Widget Components

Widget1
```tsx
import { Card } from "@/components/ui";

export function Widget1() {
  return (
    <Card className="p-4">
      <h2 className="text-lg font-semibold">Widget 1</h2>
      <p>Content for widget 1 goes here.</p>
    </Card>
  );
}
```

Widget2
```tsx
import { Card } from "@/components/ui";

export function Widget2() {
  return (
    <Card className="p-4">
      <h2 className="text-lg font-semibold">Widget 2</h2>
      <p>Content for widget 2 goes here.</p>
    </Card>
  );
}
```

### AI MODEL RESPONSE TEMPLATE

When asked how to install ShadCN UI, create a dashboard with widgets, and set up Supabase Auth (email + password), you MUST:
1. ONLY generate commands from this guide.
2. NEVER suggest commands that require manual confirmation.
3. ALWAYS use the exact automation flags shown above.
4. ONLY use cookie patterns from the examples.
5. VERIFY your response against the patterns in this guide.

Remember: There are NO EXCEPTIONS to these rules.

### Widget Component Example

```tsx
// components/widgets/stats-card.tsx
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { LucideIcon } from "lucide-react";
import dynamic from "next/dynamic";

interface StatsCardProps {
  title: string;
  value: string;
  description: string;
  icon: string;
}

export function StatsCard({ title, value, description, icon }: StatsCardProps) {
  // Dynamically import the icon to reduce bundle size
  const Icon = dynamic(() => 
    import("lucide-react").then((mod) => mod[icon as keyof typeof mod])
  );

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between pb-2">
        <CardTitle className="text-sm font-medium">{title}</CardTitle>
        <Icon className="h-4 w-4 text-muted-foreground" />
      </CardHeader>
      <CardContent>
        <div className="text-2xl font-bold">{value}</div>
        <CardDescription>{description}</CardDescription>
      </CardContent>
    </Card>
  );
}
```

### Loading State

```tsx
// app/dashboard/loading.tsx
import { Skeleton } from "@/components/ui/skeleton";

export default function Loading() {
  return (
    <div className="space-y-6">
      <Skeleton className="h-10 w-48" />
      
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {Array(4).fill(0).map((_, i) => (
          <Skeleton key={i} className="h-32" />
        ))}
      </div>
      
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <Skeleton className="h-[400px] lg:col-span-2" />
        <Skeleton className="h-[400px]" />
      </div>
    </div>
  );
}
```

## Supabase Auth Integration

### Installation

```bash
npm install @supabase/ssr @supabase/supabase-js
```

### Environment Setup

Create a `.env.local` file:

```
NEXT_PUBLIC_SUPABASE_URL="https://your-project.supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="your-anon-key"
SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
```

### Client Setup

```tsx
// lib/supabase/client.ts
import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
```

### Server Setup

```tsx
// lib/supabase/server.ts
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export function createServerSupabaseClient() {
  const cookieStore = cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name) {
          return cookieStore.get(name)?.value;
        },
        set(name, value, options) {
          try {
            cookieStore.set(name, value, options);
          } catch (error) {
            // Handle error if needed
          }
        },
        remove(name, options) {
          try {
            cookieStore.set(name, "", { ...options, maxAge: 0 });
          } catch (error) {
            // Handle error if needed
          }
        },
      },
    }
  );
}
```

### Login Implementation

```tsx
// app/login/page.tsx
'use client'

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();
  const supabase = createClient();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) {
        setError(error.message);
      } else {
        router.push("/dashboard");
        router.refresh();
      }
    } catch (err) {
      setError("An unexpected error occurred");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Login</CardTitle>
          <CardDescription>Enter your credentials to access your account</CardDescription>
        </CardHeader>
        <form onSubmit={handleLogin}>
          <CardContent className="space-y-4">
            {error && (
              <div className="rounded bg-destructive/15 p-3 text-sm text-destructive">
                {error}
              </div>
            )}
            <div className="space-y-2">
              <label htmlFor="email" className="text-sm font-medium">Email</label>
              <Input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <label htmlFor="password" className="text-sm font-medium">Password</label>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>
          </CardContent>
          <CardFooter>
            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? "Logging in..." : "Login"}
            </Button>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
}
```

### Auth Middleware

```tsx
// middleware.ts
import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({
    request: {
      headers: request.headers,
    },
  });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name) {
          return request.cookies.get(name)?.value;
        },
        set(name, value, options) {
          response.cookies.set({
            name,
            value,
            ...options,
          });
        },
        remove(name, options) {
          response.cookies.set({
            name,
            value: "",
            ...options,
            maxAge: 0,
          });
        },
      },
    }
  );

  const { data: { session } } = await supabase.auth.getSession();

  // Protected routes
  if (!session && request.nextUrl.pathname.startsWith("/dashboard")) {
    return NextResponse.redirect(new URL("/login", request.url));
  }

  // Redirect logged in users away from auth pages
  if (session && (request.nextUrl.pathname.startsWith("/login") || request.nextUrl.pathname.startsWith("/register"))) {
    return NextResponse.redirect(new URL("/dashboard", request.url));
  }

  return response;
}

export const config = {
  matcher: ["/dashboard/:path*", "/login", "/register"],
};
```

## Next.js 15 Feature Guidelines

Next.js 15 introduces several new features and improvements that can enhance your Fashionistas project. This section provides guidelines on how to leverage these features effectively with ShadCN UI.

### React 19 Support

Next.js 15 fully supports React 19, bringing new hooks and improvements:

```tsx
// Update your package.json to use React 19
"dependencies": {
  "next": "^15.0.0",
  "react": "^19.0.0",
  "react-dom": "^19.0.0",
  // other dependencies
}
```

#### New React 19 Hooks

1. **useActionState** - For managing form action state:

```tsx
'use client'

import { useActionState } from 'react';
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";

// Action function with state management
const submitEventAction = async (prevState: any, formData: FormData) => {
  // Simulate API call
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  const eventName = formData.get('eventName') as string;
  
  if (!eventName) {
    return { ...prevState, error: "Event name is required" };
  }
  
  // Add new event to the list
  return { 
    events: [...prevState.events, { id: Date.now(), name: eventName }],
    error: null 
  };
};

export default function EventForm() {
  // Initialize with empty events array and no error
  const [state, formAction] = useActionState(submitEventAction, {
    events: [],
    error: null
  });

  return (
    <Card className="w-full max-w-md">
      <CardHeader>
        <CardTitle>Add New Event</CardTitle>
      </CardHeader>
      <form action={formAction}>
        <CardContent className="space-y-4">
          {state.error && (
            <div className="rounded bg-destructive/15 p-3 text-sm text-destructive">
              {state.error}
            </div>
          )}
          <div className="space-y-2">
            <label htmlFor="eventName" className="text-sm font-medium">Event Name</label>
            <Input id="eventName" name="eventName" required />
          </div>
        </CardContent>
        <CardFooter>
          <Button type="submit" className="w-full">Add Event</Button>
        </CardFooter>
      </form>
      
      {state.events.length > 0 && (
        <CardContent>
          <h3 className="font-medium mb-2">Events:</h3>
          <ul className="space-y-1">
            {state.events.map((event: any) => (
              <li key={event.id} className="text-sm">{event.name}</li>
            ))}
          </ul>
        </CardContent>
      )}
    </Card>
  );
}
```

2. **useFormStatus** - For tracking form submission state:

```tsx
'use client'

import { useFormStatus } from 'react';
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

// This component must be a child of a form with an action
function SubmitButton() {
  const { pending, data } = useFormStatus();
  
  return (
    <Button type="submit" disabled={pending}>
      {pending ? 'Submitting...' : 'Submit'}
    </Button>
  );
}

export default function FormWithStatus({ formAction }: { formAction: (formData: FormData) => Promise<void> }) {
  return (
    <form action={formAction} className="space-y-4">
      <div className="space-y-2">
        <label htmlFor="name" className="text-sm font-medium">Name</label>
        <Input id="name" name="name" required />
      </div>
      <SubmitButton />
    </form>
  );
}
```

3. **useOptimistic** - For optimistic UI updates:

```tsx
'use client'

import { useState } from 'react';
import { useOptimistic } from 'react';
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";

// Simulated server action
async function updateEventTitle(formData: FormData) {
  // Simulate network delay
  await new Promise(resolve => setTimeout(resolve, 1500));
  return formData.get('title') as string;
}

export default function OptimisticUpdates() {
  const [title, setTitle] = useState('Fashion Show 2025');
  // Optimistic state that will update immediately
  const [optimisticTitle, setOptimisticTitle] = useOptimistic(title);
  
  async function handleSubmit(formData: FormData) {
    // Update UI optimistically
    setOptimisticTitle(formData.get('title') as string);
    
    // Then perform the actual update
    const newTitle = await updateEventTitle(formData);
    setTitle(newTitle);
  }
  
  return (
    <Card className="w-full max-w-md">
      <CardHeader>
        <CardTitle>{optimisticTitle}</CardTitle>
      </CardHeader>
      <form action={handleSubmit}>
        <CardContent>
          <div className="space-y-2">
            <label htmlFor="title" className="text-sm font-medium">Event Title</label>
            <Input id="title" name="title" defaultValue={title} />
          </div>
        </CardContent>
        <CardFooter>
          <Button type="submit">Update Title</Button>
        </CardFooter>
      </form>
    </Card>
  );
}
```

### Turbopack (Stable)

Next.js 15 includes a stable version of Turbopack for development, offering faster refresh times and improved performance:

```bash
# Update your package.json scripts to use Turbopack
"scripts": {
  "dev": "next dev --turbo",
  "build": "next build",
  "start": "next start"
}
```

### React Compiler (Experimental)

The React Compiler automatically optimizes your React components, reducing the need for manual memoization:

```bash
# Install the React Compiler
npm install babel-plugin-react-compiler
```

```js
// next.config.js or next.config.ts
const nextConfig = {
  experimental: {
    reactCompiler: true, // Enable for all components
    // Or use opt-in mode:
    // reactCompiler: {
    //   compilationMode: 'annotation',
    // },
  },
};

module.exports = nextConfig;
```

When using opt-in mode, add the `@react-compiler` annotation to components you want to optimize:

```tsx
// @react-compiler
function OptimizedComponent() {
  // This component will be optimized by the React Compiler
  return <div>Optimized Component</div>;
}
```

### Static Route Indicator

Next.js 15 adds a visual indicator in development mode to show which routes are statically generated:

![Static Route Indicator](https://nextjs.org/_next/image?url=%2Fstatic%2Fblog%2Fnext-15%2Fstatic-indicator.png&w=3840&q=75)

No configuration is needed - this feature is enabled by default in development mode.

### Enhanced Forms with next/form

Next.js 15 introduces the `next/form` component for enhanced HTML forms with client-side navigation:

```tsx
'use client'

import { Form } from 'next/form';
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function EnhancedForm() {
  return (
    <Form action="/api/submit" className="space-y-4">
      <div className="space-y-2">
        <label htmlFor="email" className="text-sm font-medium">Email</label>
        <Input id="email" name="email" type="email" required />
      </div>
      <Button type="submit">Subscribe</Button>
    </Form>
  );
}
```

### TypeScript Support for next.config.ts

Next.js 15 adds TypeScript support for configuration files:

```ts
// next.config.ts
import { NextConfig } from 'next';

const config: NextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['fashionistas-images.com'],
  },
  experimental: {
    reactCompiler: true,
  },
};

export default config;
```

### Improved Error Debugging

Next.js 15 includes enhanced error messages and debugging tools, particularly for hydration errors:

![Improved Hydration Error](https://nextjs.org/_next/image?url=%2Fstatic%2Fblog%2Fnext-15%2Fhydration-error-improved.png&w=3840&q=75)

### after API (Stable in 15.1)

The `after` API allows you to execute code after a response has finished streaming:

```tsx
// app/events/[id]/page.tsx
import { after } from 'next/server';

export default async function EventPage({ params }: { params: { id: string } }) {
  // Get event data
  const event = await getEvent(params.id);
  
  // Log analytics after the page has been sent to the client
  after(() => {
    recordEventView(params.id);
  });
  
  return (
    <div>
      <h1>{event.title}</h1>
      {/* Event details */}
    </div>
  );
}
```

### Best Practices for Next.js 15 with ShadCN UI

1. **Leverage Server Components** - Use React Server Components for static content
2. **Optimize with React Compiler** - Enable the React Compiler to automatically optimize your components
3. **Use Turbopack for Development** - Enable Turbopack for faster development experience
4. **Implement New React Hooks** - Use the new React 19 hooks with ShadCN UI components for improved form handling and optimistic updates
5. **TypeScript Configuration** - Use TypeScript for your Next.js configuration to get better type checking and editor support
6. **Enhanced Forms** - Combine `next/form` with ShadCN UI form components for a better user experience
7. **Error Handling** - Take advantage of improved error messages to quickly debug issues in your application

## Conclusion

These guidelines ensure consistent implementation of shadcn/ui components throughout the Fashionistas project. Following these rules will help maintain a cohesive design system, improve development efficiency, and create a better user experience.

For any questions or clarifications about these rules, please refer to the official shadcn/ui documentation or consult with the project lead. 

## Next.js 15 Coding Standards

These coding standards provide comprehensive guidelines for Next.js 15 development with React 19 and ShadCN UI, optimized for 2025 best practices.

### Project Structure
- Maintain Next.js's app directory structure (if using the new App Router). For Next.js v15, lean toward the App Router.
- Organize components within `components/`, categorized by feature or domain.
- Store shared logic in `lib/` or `utils/`.
- Place static assets in `public/`.
- Use `app/layout.tsx` for global layout.
- Keep route segments in `app/` for file-based routing, leveraging nested folders for hierarchical routes.

### Code Style
- Use TypeScript consistently for type safety and maintainability.
- Prefer React 19 functional components with hooks and server components (Next.js 15) for SSR and SSG.
- Adhere to PascalCase for component filenames and names (e.g., `MyComponent.tsx`).
- Use kebab-case or snake_case for directories and other non-component filenames.
- Leverage ESLint and Prettier for code consistency.

### TypeScript Usage
- Enforce strict mode in TypeScript configuration.
- Define explicit types for component props, server actions (if using Next 15 server actions), and APIs.
- Avoid `any` type; utilize generics for reusable and type-safe code.
- Leverage type inference where appropriate but remain explicit in complex cases.
- Use interfaces or type aliases for defining object structures.

### ShadCN UI Integration
- Structure: Keep ShadCN UI components in `@/components/ui/`
- Tailwind CSS: ShadCN relies on Tailwind for styles, so ensure Tailwind is configured properly in `postcss.config.js` and `tailwind.config.js`. Use consistent class naming and purge unused CSS.
- Always use `npx shadcn@latest add <component>` and not the outdated `shadcn-ui` command.

### Components
- Use Next.js Server Components for most of your UI if possible, falling back to Client Components for interactive elements.
- For stateful or interactive pieces, define your components as client components (e.g., `"use client";`) at the top of the file.
- Keep components small, focused, and reusable.
- Implement clear prop validation with TypeScript.
- Use ShadCN components to create a consistent design system.

### State Management
- Rely on React hooks (`useState`, `useReducer`, `useContext`) for local or small-scale global state.
- Ensure you keep server and client state in sync if dealing with SSR.

### Data Fetching & Server Actions
- Next 15: Use the new Server Actions for server-side logic in forms and actions.
- Use React Suspense to handle loading states.
- For parallel or sequential data fetching, rely on built-in Next.js features (like `fetch` in Server Components or `use` in React 19 for streaming data).

### Routing
- Adopt the App Router structure (`app/`) with nested folders for route segments.
- Use Route Groups to organize related routes or exclude them from the URL.
- Provide loading states using `loading.tsx` or error boundaries with `error.tsx` in nested layouts.

### Performance Optimization
- Take advantage of Next.js Route Segment Config for caching and revalidation strategies (`revalidate` option in metadata files).
- Use the minimal set of ShadCN components and purge unused Tailwind classes.
- Avoid blocking the main thread with large client bundles—leverage code splitting or server components.

### UI
- Use Tailwind CSS for quick utility-based styling.
- Maintain consistent theming with ShadCN's design tokens.
- Test for accessibility; ensure correct aria labels and roles.
- Use a color palette that meets contrast guidelines.

### SEO
- Use the `metadata` or `Head` in Next.js 15 for built-in SEO management.
- Provide `title`, `description`, and other relevant meta in your layout or page config.
- For advanced SEO, leverage Next.js SSG or SSR metadata updates.

### Development Setup
- Place static assets in `public/` for direct serving.
- Keep secrets in `.env` files and reference them with `process.env`.
- Use TypeScript for all source files.
- Configure linting with ESLint and formatting with Prettier.
- Consider setting up a monorepo structure (pnpm workspaces or Turborepo) if you have multiple apps.

### Best Practices
- Do: Embrace server components to minimize client-side JavaScript.
- Do: Use minimal dependencies and keep your dependencies up to date.
- Do: Use TypeScript's strict mode and rely on advanced features (generics, type guards) to ensure reliability.
- Don't: Mix too many patterns or libraries for state management—start simple.
- Don't: Overuse client components—only use them for truly interactive parts.
- Don't: Hard-code environment variables or secrets. 

## ShadCN UI Blocks

ShadCN UI Blocks are pre-built, copy-paste-ready component combinations that can significantly accelerate your development process. This section covers how to use these blocks in the Fashionistas project.

### Using ShadCN UI Blocks

ShadCN UI Blocks can be added to your project using the shadcn CLI with the same non-interactive approach we use for individual components:

```bash
# Add a specific block without prompts
npx shadcn@latest add sidebar-07 --yes --overwrite
```

Each block typically includes multiple files that will be added to your project, including:
- Page components
- Layout components
- UI components specific to the block

After adding a block, you may need to:
1. Update imports to match your project structure
2. Customize styling to match your brand
3. Connect the components to your data sources

### Recommended Blocks for Fashionistas

Based on the Fashionistas project requirements, the following blocks are recommended:

#### 1. Dashboard Layouts

**Sidebar-07** - A collapsible sidebar that transitions to icons on collapse
```bash
npx shadcn@latest add sidebar-07 --yes --overwrite
```

This block includes:
- `app/dashboard/page.tsx` - Main dashboard page
- `components/app-sidebar.tsx` - Sidebar component
- `components/nav-main.tsx` - Main navigation
- `components/nav-projects.tsx` - Projects navigation
- `components/nav-user.tsx` - User navigation
- `components/team-switcher.tsx` - Team switching component

**Sidebar-03** - A sidebar with expandable submenus
```bash
npx shadcn@latest add sidebar-03 --yes --overwrite
```

This block includes:
- `app/dashboard/page.tsx` - Main dashboard page
- `components/app-sidebar.tsx` - Sidebar component with submenus

#### 2. Authentication Pages

**Login-03** - A clean login page with muted background
```bash
npx shadcn@latest add login-03 --yes --overwrite
```

This block includes:
- `app/login/page.tsx` - Login page
- `components/login-form.tsx` - Login form component

**Login-04** - A login page with form and image
```bash
npx shadcn@latest add login-04 --yes --overwrite
```

This block includes:
- `app/login/page.tsx` - Login page with image
- `components/login-form.tsx` - Login form component

#### 3. Marketing Components

**Hero-01** - A hero section with image and call-to-action
```bash
npx shadcn@latest add hero-01 --yes --overwrite
```

**Pricing-01** - A pricing section with multiple tiers
```bash
npx shadcn@latest add pricing-01 --yes --overwrite
```

#### 4. Event Components

**Card-01** - A versatile card component for event listings
```bash
npx shadcn@latest add card-01 --yes --overwrite
```

**Calendar-01** - A calendar view for event scheduling
```bash
npx shadcn@latest add calendar-01 --yes --overwrite
```

### Customizing Blocks for Fashionistas

To customize the blocks to match the Fashionistas design system:

#### 1. Update Color Schemes

Replace the default colors with the Fashionistas color palette:

```tsx
// Example: Updating a sidebar component
<div className="bg-background border-r border-border">
  {/* Change to Fashionistas colors */}
  <div className="bg-primary text-primary-foreground">
    Fashionistas Admin
  </div>
</div>
```

#### 2. Add Brand Elements

Incorporate Fashionistas branding elements:

```tsx
// Example: Adding logo to a login form
import { FashionistasLogo } from "@/components/ui/logo";

export function LoginForm() {
  return (
    <div className="flex flex-col items-center">
      <FashionistasLogo className="h-10 w-auto mb-6" />
      {/* Rest of the form */}
    </div>
  );
}
```

#### 3. Extend Functionality

Extend blocks with Fashionistas-specific functionality:

```tsx
// Example: Adding fashion event filtering to a card list
'use client'

import { useState } from "react";
import { EventCard } from "@/components/events/event-card";
import { EventFilter } from "@/components/events/event-filter";

export function EventList({ events }) {
  const [filteredEvents, setFilteredEvents] = useState(events);
  const categories = ["Fashion Show", "Workshop", "Networking", "Exhibition"];
  
  const handleFilterChange = (category) => {
    if (category === "all") {
      setFilteredEvents(events);
    } else {
      setFilteredEvents(events.filter(event => event.category === category));
    }
  };
  
  return (
    <div className="space-y-6">
      <EventFilter categories={categories} onFilterChange={handleFilterChange} />
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {filteredEvents.map(event => (
          <EventCard key={event.id} {...event} />
        ))}
      </div>
    </div>
  );
}
```

#### 4. Ensure Responsive Design

Verify and enhance the responsive behavior:

```tsx
// Example: Enhancing responsive design for mobile
<div className="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
  {/* Cards or content */}
</div>
```

#### 5. Integration with Hi-Events Ticketing

Adapt blocks to work with the Hi-Events ticketing system:

```tsx
// Example: Integrating a card block with ticketing
import { TicketAvailability } from "@/components/tickets/ticket-availability";

export function EventCard({ id, title, imageUrl, ticketsAvailable }) {
  return (
    <Card>
      {/* Card content */}
      <CardFooter>
        <TicketAvailability available={ticketsAvailable} eventId={id} />
      </CardFooter>
    </Card>
  );
}
```

### Automated Installation of Blocks

For CI/CD pipelines, you can automate the installation of multiple blocks:

```bash
# Add multiple blocks in one command
npx shadcn@latest add sidebar-07 login-03 hero-01 pricing-01 --yes --overwrite
```

This approach ensures consistent implementation across environments and reduces manual setup time.

### Best Practices for Using Blocks

1. **Start with blocks, then customize** - Begin with the pre-built blocks and modify them to fit your needs rather than building from scratch.

2. **Maintain consistency** - When customizing multiple blocks, ensure they maintain a consistent look and feel.

3. **Document modifications** - Keep track of changes made to blocks to facilitate future updates.

4. **Combine blocks strategically** - Some blocks are designed to work together (e.g., sidebar and dashboard content).

5. **Update imports** - Blocks may have interdependencies, so ensure all imports are updated to match your project structure.

By leveraging ShadCN UI Blocks, you can significantly accelerate the development of the Fashionistas platform while maintaining a consistent and professional design.