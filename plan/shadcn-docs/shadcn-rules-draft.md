
description: Guidelines for writing Next.js apps with shadcn/ui
globs: **/*.ts, **/*.tsx, **/*.js, **/*.jsx
---

# Next.js Dashboard Setup with shadcn/ui

Follow these steps in order to create a modern dashboard application:

1. Create Project
   - Run: pnpm dlx shadcn@latest init
   - For quick setup with defaults: pnpm dlx shadcn@latest init -d
   - Select New York style and Zinc color scheme when prompted
   - Enable CSS variables for theming support

2. Configure Project Structure
   - Remove app/page.tsx (default demo page)
   - Create following directory structure:
     ```
     app/
     ├── layout.tsx
     ├── page.tsx (dashboard page)
     ├── loading.tsx
     ├── error.tsx
     └── components/
         ├── ui/ (shadcn components)
         └── dashboard/
             ├── header.tsx
             ├── sidebar.tsx
             ├── main.tsx
             └── widgets/
     ```

3. Install Essential Components
   ```bash
   pnpm dlx shadcn@latest add card
   pnpm dlx shadcn@latest add button
   pnpm dlx shadcn@latest add dropdown-menu
   pnpm dlx shadcn@latest add separator
   pnpm dlx shadcn@latest add sheet
   pnpm dlx shadcn@latest add theme-toggle
   ```

4. Create Root Layout
   ```tsx
   // app/layout.tsx
   import { ThemeProvider } from '@/components/theme-provider'
   
   export default function RootLayout({
     children,
   }: {
     children: React.ReactNode
   }) {
     return (
       <html lang="en" suppressHydrationWarning>
         <body>
           <ThemeProvider
             attribute="class"
             defaultTheme="system"
             enableSystem
           >
             {children}
           </ThemeProvider>
         </body>
       </html>
     )
   }
   ```

5. Implement Dashboard Layout Components
   ```tsx
   // components/dashboard/header.tsx
   export function Header() {
     return (
       <header className="border-b">
         <div className="flex h-16 items-center px-4">
           <div className="ml-auto flex items-center space-x-4">
             <ThemeToggle />
           </div>
         </div>
       </header>
     )
   }

   // components/dashboard/sidebar.tsx
   export function Sidebar() {
     return (
       <div className="hidden border-r bg-background md:block md:w-64">
         <div className="space-y-4 py-4">
           {/* Add navigation items */}
         </div>
       </div>
     )
   }
   ```

6. Create Main Dashboard Page
   ```tsx
   // app/page.tsx
   import { Header } from '@/components/dashboard/header'
   import { Sidebar } from '@/components/dashboard/sidebar'
   
   export default function DashboardPage() {
     return (
       <div className="flex min-h-screen flex-col">
         <Header />
         <div className="flex flex-1">
           <Sidebar />
           <main className="flex-1 p-6">
             <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
               {/* Add dashboard widgets */}
             </div>
           </main>
         </div>
       </div>
     )
   }
   ```

7. Add Mobile Responsiveness
   - Add Sheet component for mobile navigation
   - Implement responsive breakpoints
   - Create mobile menu toggle button

8. Implement Loading States
   ```tsx
   // app/loading.tsx
   export default function Loading() {
     return (
       <div className="flex h-screen w-screen items-center justify-center">
         <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-primary" />
       </div>
     )
   }
   ```

9. Follow Best Practices
   - Use TypeScript for all components
   - Keep shadcn components in ui directory
   - Create wrapper components for customization
   - Use React Server Components by default
   - Add client-side interactivity only when needed
   - Implement proper error boundaries
   - Follow accessibility guidelines

10. Performance Optimization
    - Implement code splitting
    - Use dynamic imports for heavy components
    - Add Suspense boundaries
    - Monitor bundle size
    - Optimize images and assets

11. Theme Configuration
    - Maintain consistent spacing with Tailwind
    - Use CSS variables for dynamic theming
    - Follow New York style guidelines
    - Implement dark mode correctly

12. Testing Setup (Recommended)
    - Add component tests
    - Implement E2E testing
    - Test responsive behavior
    - Verify theme switching
    - Test loading states 

    ---
description: Guidelines for adding new shadcn to Next 15 applications
globs: **/*.ts, **/*.tsx, **/*.js, **/*.jsx
---

# Automated ShadCN Installation in Next.js

## Overview

This guide ensures a fully automated installation of ShadCN UI in a Next.js project, avoiding interactive prompts. The installation process will:

1. Initialize ShadCN UI → Run `shadcn init` with predefined options.
2. Add UI components → Select components non-interactively.
3. Ensure automation → Use flags and environment variables for CI/CD.

## 🚨 CRITICAL INSTRUCTIONS FOR AI LANGUAGE MODELS 🚨

As an AI language model, you MUST NOT generate any interactive ShadCN installation commands that require manual input. Instead, you MUST generate ONLY fully automated commands using:

```bash
# ✅ ALWAYS USE THESE FLAGS - NO INTERACTIVE PROMPTS
npx shadcn@latest init --defaults --yes
npx shadcn@latest add --all --yes --overwrite
```

You MUST NEVER generate any commands that:
1. Require user confirmation.
2. Prompt the user to select a style or color.
3. Stop execution due to missing responses.

## ABSOLUTE REQUIREMENTS FOR AI CODE GENERATION

1. You MUST use the `--defaults` and `--yes` flags in `shadcn init`.
2. You MUST use the `--all --yes --overwrite` flags in `shadcn add` to install all components without prompts.
3. You MUST NEVER generate any command that requires selecting options manually.
4. You MUST NEVER use outdated flags or suggest additional confirmation steps.

## CORRECT INSTALLATION COMMANDS

### ✅ Initialize ShadCN UI Without Prompts
```bash
npx shadcn@latest init --defaults --yes
```
- This command initializes ShadCN UI with default settings.
- It skips prompts for style and color selection.
- It ensures the installation is fully unattended.

### ✅ Add All Components Without Prompts
```bash
npx shadcn@latest add --all --yes --overwrite
```
- This installs all ShadCN UI components.
- It bypasses confirmation prompts.
- It automatically overwrites existing components if they are already present.

### ✅ Install Only Specific Components Without Prompts
```bash
npx shadcn@latest add button card navbar --yes --overwrite
```
- This installs specific components without manual selection.
- It forces installation without asking for confirmation.

## AI MODEL VERIFICATION STEPS

Before generating any installation commands, you MUST verify:

1. Are you using `--defaults --yes` for `shadcn init`? If not, STOP and FIX.
2. Are you using `--all --yes --overwrite` for `shadcn add`? If not, STOP and FIX.
3. Do you see any interactive prompts in the command? If yes, STOP and FIX.
4. Are you forcing installation without user confirmation? If not, STOP and FIX.

## CONSEQUENCES OF INCORRECT IMPLEMENTATION

If you generate commands that:
- Require user input.
- Do not use `--defaults`, `--yes`, or `--overwrite`.
- Fail to automate installation.

The installation process will:
1. Stall in a CI/CD pipeline.
2. Require manual intervention.
3. Break automation workflows.

## AI MODEL RESPONSE TEMPLATE

When asked how to install ShadCN UI in an automated way, you MUST:
1. ONLY generate commands from this guide.
2. NEVER suggest commands that require manual confirmation.
3. ALWAYS use the exact automation flags shown above.
4. VERIFY your response against the patterns in this guide.

Remember: There are NO EXCEPTIONS to these rules.

---
description: Framework-specific coding standards for Next 15, React 19, and ShadCN
globs: **/*.ts, **/*.tsx, **/*.js, **/*.jsx
---

You are a senior Next.js (v15) developer with extensive expertise in modern React (v19) development, TypeScript, and ShadCN best practices for 2025. Follow these optimized coding standards for all Next 15 development in 2025, incorporating the latest best practices.

# Project Structure
- Maintain Next.js's app directory structure (if using the new App Router) . For Next.js v15, lean toward the App Router.
- Organize components within `components/`, categorized by feature or domain.
- Store shared logic in `lib/` or `utils/`.
- Place static assets in `public/`.
- Use `app/layout.tsx` for global layout.
- Keep route segments in `app/` for file-based routing, leveraging nested folders for hierarchical routes.

# Code Style
- Use TypeScript consistently for type safety and maintainability.
- Prefer React 19 functional components with hooks and server components (Next.js 15) for SSR and SSG.
- Adhere to PascalCase for component filenames and names (e.g., `MyComponent.tsx`).
- Use kebab-case or snake_case for directories and other non-component filenames.
- Leverage ESLint and Prettier for code consistency.

# TypeScript Usage
- Enforce strict mode in TypeScript configuration.
- Define explicit types for component props, server actions (if using Next 15 server actions), and APIs.
- Avoid `any` type; utilize generics for reusable and type-safe code.
- Leverage type inference where appropriate but remain explicit in complex cases.
- Use interfaces or type aliases for defining object structures.

# ShadCN UI Integration
- Structure: Keep ShadCN UI components in `@/components/ui/`
- Tailwind CSS: ShadCN relies on Tailwind for styles, so ensure Tailwind is configured properly in `postcss.config.js` and `tailwind.config.js`. Use consistent class naming and purge unused CSS.
- Always use `npx shadcn@latest add <component>` and not the outdated `shadcn-ui` command.

# Components
- Use Next.js Server Components for most of your UI if possible, falling back to Client Components for interactive elements.
- For stateful or interactive pieces, define your components as client components (e.g., `"use client";`) at the top of the file.
- Keep components small, focused, and reusable.
- Implement clear prop validation with TypeScript.
- Use ShadCN components to create a consistent design system.

# State Management
- Rely on React hooks (`useState`, `useReducer`, `useContext`) for local or small-scale global state.
- Ensure you keep server and client state in sync if dealing with SSR.

# Data Fetching & Server Actions
- Next 15: Use the new Server Actions for server-side logic in forms and actions.
- Use React Suspense to handle loading states.
- For parallel or sequential data fetching, rely on built-in Next.js features (like `fetch` in Server Components or `use` in React 19 for streaming data).

# Routing
- Adopt the App Router structure (`app/`) with nested folders for route segments.
- Use Route Groups to organize related routes or exclude them from the URL.
- Provide loading states using `loading.tsx` or error boundaries with `error.tsx` in nested layouts.

# Performance Optimization
- Take advantage of Next.js Route Segment Config for caching and revalidation strategies (`revalidate` option in metadata files).
- Use the minimal set of ShadCN components and purge unused Tailwind classes.
- Avoid blocking the main thread with large client bundles—leverage code splitting or server components.

# UI
- Use Tailwind CSS for quick utility-based styling.
- Maintain consistent theming with ShadCN’s design tokens.
- Test for accessibility; ensure correct aria labels and roles.
- Use a color palette that meets contrast guidelines.

# SEO
- Use the `metadata` or `Head` in Next.js 15 for built-in SEO management.
- Provide `title`, `description`, and other relevant meta in your layout or page config.
- For advanced SEO, leverage Next.js SSG or SSR metadata updates

# Development Setup
- Place static assets in `public/` for direct serving.
- Keep secrets in `.env` files and reference them with `process.env`.
- Use TypeScript for all source files.
- Configure linting with ESLint and formatting with Prettier.
- Consider setting up a monorepo structure (pnpm workspaces or Turborepo) if you have multiple apps.

# Best Practices
- Do: Embrace server components to minimize client-side JavaScript.
- Do: Use minimal dependencies and keep your dependencies up to date.
- Do: Use TypeScript’s strict mode and rely on advanced features (generics, type guards) to ensure reliability.
- Don’t: Mix too many patterns or libraries for state management—start simple.
- Don’t: Overuse client components—only use them for truly interactive parts.
- Don’t: Hard-code environment variables or secrets.

---
description: Guidelines for adding new features in Next.js 15 applications
globs: **/*.tsx, **/*.ts
---

You are a senior Next.js 15 developer with expertise in building scalable applications.

# App Router Features
- Use server components by default. Example: app/products/page.tsx
- Implement parallel routes. Example: app/@modal/login/page.tsx
- Use intercepting routes. Example: app/feed/(..)photo/[id]/page.tsx
- Implement route groups. Example: app/(auth)/login/page.tsx
- Use loading states with suspense. Example: app/products/loading.tsx

# Data Fetching
- Use server-side data fetching with caching. Example:
```typescript
async function getProduct(id: string) {
  const res = await fetch(`/api/products/${id}`, { 
    next: { revalidate: 3600 } 
  })
  return res.json()
}
```

- Implement streaming with suspense. Example:
```typescript
import { Suspense } from 'react'

export default function Page() {
  return (
    <Suspense fallback={<ProductSkeleton />}>
      <ProductInfo />
    </Suspense>
  )
}
```

- Use parallel data fetching. Example:
```typescript
async function ProductPage() {
  const [product, reviews] = await Promise.all([
    getProduct(id),
    getProductReviews(id)
  ])
  return <ProductDetails product={product} reviews={reviews} />
}
```

# Server Actions
- Use form actions for mutations. Example:
```typescript
export default function AddToCart() {
  async function addItem(formData: FormData) {
    'use server'
    const id = formData.get('productId')
    await db.cart.add({ productId: id })
    revalidatePath('/cart')
  }
  
  return (
    <form action={addItem}>
      <input name="productId" type="hidden" value="123" />
      <button type="submit">Add to Cart</button>
    </form>
  )
}
```

# Component Architecture
- Use client components when needed. Example:
```typescript
'use client'

export function InteractiveButton({ onClick }: { onClick: () => void }) {
  const [isLoading, setLoading] = useState(false)
  
  return (
    <button 
      onClick={async () => {
        setLoading(true)
        await onClick()
        setLoading(false)
      }}
      disabled={isLoading}
    >
      {isLoading ? 'Loading...' : 'Click me'}
    </button>
  )
}
```

# Server Components
- Create type-safe server components. Example:
```typescript
interface ProductGridProps {
  category: string
  sort?: 'asc' | 'desc'
}

export async function ProductGrid({ category, sort }: ProductGridProps) {
  const products = await db.products.findMany({
    where: { category },
    orderBy: { price: sort }
  })
  
  return (
    <div className="grid grid-cols-3 gap-4">
      {products.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  )
}
```

# API Routes
- Use route handlers with proper types. Example:
```typescript
import { NextRequest } from 'next/server'

export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl
  const query = searchParams.get('q')
  
  const products = await db.products.search(query)
  return Response.json(products)
}
```

# Performance Features
- Use image optimization. Example: <Image src={src} width={300} height={200} alt="Product" />
- Implement route prefetching. Example: <Link href="/products" prefetch={true}>Products</Link>
- Use React Suspense for code splitting. Example: const Modal = lazy(() => import('./Modal'))
- Implement proper caching strategies. Example: export const revalidate = 3600
- Use streaming for large lists. Example: <Suspense><ProductStream /></Suspense>

# Metadata
- Use dynamic metadata generation. Example:
```typescript
export async function generateMetadata({ params }: Props) {
  const product = await getProduct(params.id)
  
  return {
    title: product.name,
    description: product.description,
    openGraph: {
      images: [{ url: product.image }]
    }
  }
}
```

# Error Handling
- Use error boundaries effectively. Example: app/products/[id]/error.tsx
- Implement not-found pages. Example: app/products/[id]/not-found.tsx
- Use loading states. Example: app/products/loading.tsx
- Implement global error handling. Example: app/global-error.tsx
- Use proper API error responses

# SEO Features
- Use metadata API for SEO. Example:
```typescript
export const metadata = {
  title: 'Product Catalog',
  description: 'Browse our products',
  robots: {
    index: true,
    follow: true
  }
}
```
- Implement dynamic sitemap generation
- Use proper canonical URLs
- Implement JSON-LD structured data
- Use proper OpenGraph tags

---
description: Guidelines for writing Next.js apps with shadcn/ui
globs: **/*.ts, **/*.tsx, **/*.js, **/*.jsx
---

# Next.js Dashboard Setup with shadcn/ui

Follow these steps in order to create a modern dashboard application:

1. Create Project
   - Run: pnpm dlx shadcn@latest init
   - For quick setup with defaults: pnpm dlx shadcn@latest init -d
   - Select New York style and Zinc color scheme when prompted
   - Enable CSS variables for theming support

2. Configure Project Structure
   - Remove app/page.tsx (default demo page)
   - Create following directory structure:
     ```
     app/
     ├── layout.tsx
     ├── page.tsx (dashboard page)
     ├── loading.tsx
     ├── error.tsx
     └── components/
         ├── ui/ (shadcn components)
         └── dashboard/
             ├── header.tsx
             ├── sidebar.tsx
             ├── main.tsx
             └── widgets/
     ```

3. Install Essential Components
   ```bash
   pnpm dlx shadcn@latest add card
   pnpm dlx shadcn@latest add button
   pnpm dlx shadcn@latest add dropdown-menu
   pnpm dlx shadcn@latest add separator
   pnpm dlx shadcn@latest add sheet
   pnpm dlx shadcn@latest add theme-toggle
   ```

4. Create Root Layout
   ```tsx
   // app/layout.tsx
   import { ThemeProvider } from '@/components/theme-provider'
   
   export default function RootLayout({
     children,
   }: {
     children: React.ReactNode
   }) {
     return (
       <html lang="en" suppressHydrationWarning>
         <body>
           <ThemeProvider
             attribute="class"
             defaultTheme="system"
             enableSystem
           >
             {children}
           </ThemeProvider>
         </body>
       </html>
     )
   }
   ```

5. Implement Dashboard Layout Components
   ```tsx
   // components/dashboard/header.tsx
   export function Header() {
     return (
       <header className="border-b">
         <div className="flex h-16 items-center px-4">
           <div className="ml-auto flex items-center space-x-4">
             <ThemeToggle />
           </div>
         </div>
       </header>
     )
   }

   // components/dashboard/sidebar.tsx
   export function Sidebar() {
     return (
       <div className="hidden border-r bg-background md:block md:w-64">
         <div className="space-y-4 py-4">
           {/* Add navigation items */}
         </div>
       </div>
     )
   }
   ```

6. Create Main Dashboard Page
   ```tsx
   // app/page.tsx
   import { Header } from '@/components/dashboard/header'
   import { Sidebar } from '@/components/dashboard/sidebar'
   
   export default function DashboardPage() {
     return (
       <div className="flex min-h-screen flex-col">
         <Header />
         <div className="flex flex-1">
           <Sidebar />
           <main className="flex-1 p-6">
             <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
               {/* Add dashboard widgets */}
             </div>
           </main>
         </div>
       </div>
     )
   }
   ```

7. Add Mobile Responsiveness
   - Add Sheet component for mobile navigation
   - Implement responsive breakpoints
   - Create mobile menu toggle button

8. Implement Loading States
   ```tsx
   // app/loading.tsx
   export default function Loading() {
     return (
       <div className="flex h-screen w-screen items-center justify-center">
         <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-primary" />
       </div>
     )
   }
   ```

9. Follow Best Practices
   - Use TypeScript for all components
   - Keep shadcn components in ui directory
   - Create wrapper components for customization
   - Use React Server Components by default
   - Add client-side interactivity only when needed
   - Implement proper error boundaries
   - Follow accessibility guidelines

10. Performance Optimization
    - Implement code splitting
    - Use dynamic imports for heavy components
    - Add Suspense boundaries
    - Monitor bundle size
    - Optimize images and assets

11. Theme Configuration
    - Maintain consistent spacing with Tailwind
    - Use CSS variables for dynamic theming
    - Follow New York style guidelines
    - Implement dark mode correctly

12. Testing Setup (Recommended)
    - Add component tests
    - Implement E2E testing
    - Test responsive behavior
    - Verify theme switching
    - Test loading states 

    ---
description: Automate ShadCN installation and create a simple dashboard with a sidebar, widgets, and Supabase Auth.
globs: **/*.ts, **/*.tsx, **/*.js, **/*.jsx
---

# Automated ShadCN Installation, Dashboard, and Supabase Auth

## Overview

This guide ensures a fully automated installation of ShadCN UI, sets up a simple dashboard featuring a sidebar and widgets, and includes instructions for configuring Supabase Auth (email/password) in your Next.js app.

1. Initialize ShadCN UI → Run `shadcn init` with predefined options.
2. Add UI components → Install necessary building blocks.
3. Create a basic dashboard → Implement a sidebar, content area, and widget components.
4. Configure Supabase Auth → Email + password authentication in Next.js.

## 🚨 CRITICAL INSTRUCTIONS FOR AI LANGUAGE MODELS 🚨

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

## ABSOLUTE REQUIREMENTS FOR AI CODE GENERATION

1. You MUST use the `--defaults` and `--yes` flags in `shadcn init`.
2. You MUST use `--yes --overwrite` in `shadcn add` to install components without prompts.
3. You MUST NEVER generate any command that requires manual selection.
4. You MUST NEVER use outdated flags or suggest additional confirmation steps.

## CORRECT INSTALLATION COMMANDS

### ✅ Initialize ShadCN UI Without Prompts
```bash
npx shadcn@latest init --defaults --yes
```
- Initializes ShadCN UI with default settings.
- Skips prompts for style and color selection.
- Ensures unattended installation.

### ✅ Add Required Components Without Prompts
```bash
npx shadcn@latest add button card navbar sidebar widget1 widget2 --yes --overwrite
```
- Installs necessary components for a dashboard, including widgets.
- Bypasses confirmation prompts.
- Automatically overwrites existing components if they are already present.

## Creating a Simple Dashboard with Widgets

### ✅ Dashboard Layout
```tsx
import { useState } from "react";
import { Button, Card } from "@/components/ui";
import { Sidebar } from "@/components/sidebar";
import { Widget1 } from "@/components/widget1";
import { Widget2 } from "@/components/widget2";

export default function Dashboard() {
  const [open, setOpen] = useState(true);

  return (
    <div className="flex h-screen">
      <Sidebar open={open} setOpen={setOpen} />
      <div className="flex-1 p-4 space-y-4">
        <Card className="p-4">
          <h1 className="text-xl font-bold">Dashboard</h1>
          <Button onClick={() => alert("Clicked!")}>Click me</Button>
        </Card>

        {/* Example widget usage */}
        <Widget1 />
        <Widget2 />
      </div>
    </div>
  );
}
```

### ✅ Sidebar Component
```tsx
import { Button } from "@/components/ui";

export function Sidebar({ open, setOpen }) {
  return (
    <div className={`w-64 bg-gray-900 text-white p-4 ${open ? "block" : "hidden"}`}>
      <h2 className="text-lg font-semibold">Sidebar</h2>
      <Button onClick={() => setOpen(!open)}>Toggle Sidebar</Button>
    </div>
  );
}
```

### ✅ Sample Widget Components

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

## Setting Up Complete Supabase Auth (Email + Password)

Below is a non-interactive approach to configuring Supabase Auth in your Next.js project.

### 1. Install Supabase Packages

Install the Supabase packages for SSR and client usage:
```bash
npm install @supabase/ssr @supabase/supabase-js
```

### 2. Add Environment Variables

Create a `.env.local` file in your project root:
```bash
NEXT_PUBLIC_SUPABASE_URL="https://xyzcompany.supabase.co"
NEXT_PUBLIC_SUPABASE_ANON_KEY="public-anon-key"
SUPABASE_SERVICE_ROLE_KEY="service-role-key"
```

Update the values with your actual Supabase credentials.

### 3. Create a Browser Client

Use the createBrowserClient function from `@supabase/ssr` to handle client-side requests:
```tsx
// lib/supabase-browser.ts
import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
```

### 4. Create a Server Client

Use the createServerClient function with cookie management:
```tsx
// lib/supabase-server.ts
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export function createServerSupabaseClient() {
  const cookieStore = cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            );
          } catch {
            // The `setAll` method was called from a Server Component.
            // This can be ignored if you have middleware refreshing user sessions.
          }
        },
      },
    }
  );
}
```

### 5. Auth Middleware (Optional)

Add a middleware to protect routes (e.g., `middleware.ts`):
```ts
import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  });

  // Create server client with SSR cookie management.
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) => request.cookies.set(name, value));
          supabaseResponse = NextResponse.next({
            request,
          });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          );
        },
      },
    }
  );

  // Validate user session.
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Example: redirect unauthenticated users to /login.
  if (!user && !request.nextUrl.pathname.startsWith("/login")) {
    const url = request.nextUrl.clone();
    url.pathname = "/login";
    return NextResponse.redirect(url);
  }

  return supabaseResponse;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
```

### 6. Implement Email/Password Login

Create a simple login page at `pages/login.tsx`:
```tsx
import React, { useState } from "react";
import { createClient } from "@/lib/supabase-browser";
import { Button, Card } from "@/components/ui";

export default function LoginPage() {
  const supabase = createClient();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) {
      alert(`Login error: ${error.message}`);
    } else {
      alert("Logged in successfully!");
      // Possibly redirect to /dashboard or another protected page.
    }
  }

  return (
    <div className="h-screen flex items-center justify-center bg-gray-50">
      <Card className="p-4 w-full max-w-md">
        <h1 className="text-2xl font-bold mb-4">Login</h1>
        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1" htmlFor="email">
              Email
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full border border-gray-300 rounded p-2"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1" htmlFor="password">
              Password
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full border border-gray-300 rounded p-2"
            />
          </div>
          <Button type="submit">Login</Button>
        </form>
      </Card>
    </div>
  );
}
```

This page uses the `createClient()` function from `@supabase/ssr` to sign users in with email + password.

> Note: The same approach can be applied for sign-up by using `supabase.auth.signUp()`.

## AI MODEL VERIFICATION STEPS

Before generating any installation commands or code, you MUST verify:

1. Are you using `--defaults --yes` for `shadcn init`? If not, STOP and FIX.
2. Are you using `--yes --overwrite` for `shadcn add`? If not, STOP and FIX.
3. Does the dashboard include `Sidebar` and `Widget` components? If not, STOP and FIX.
4. Are you ensuring fully automated installation? If not, STOP and FIX.
5. Are you using `@supabase/ssr` for SSR and `createBrowserClient`? If not, STOP and FIX.
6. Are you ONLY using `getAll` and `setAll` for cookies? If not, STOP and FIX.
7. No references to `auth-helpers-nextjs` or any `get`, `set`, or `remove` calls? If yes, STOP and FIX.

## CONSEQUENCES OF INCORRECT IMPLEMENTATION

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

## AI MODEL RESPONSE TEMPLATE

When asked how to install ShadCN UI, create a dashboard with widgets, and set up Supabase Auth (email + password), you MUST:
1. ONLY generate commands from this guide.
2. NEVER suggest commands that require manual confirmation.
3. ALWAYS use the exact automation flags shown above.
4. ONLY use cookie patterns from the examples.
5. VERIFY your response against the patterns in this guide.

Remember: There are NO EXCEPTIONS to these rules.