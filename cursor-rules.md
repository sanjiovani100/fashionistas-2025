# Fashionistas Platform - Essential Development Rules

## 1. Code Quality Standards

```markdown
- Follow single responsibility principle for all fashion show event components
- Use TypeScript with strict mode for all project files
- Maximum file length: 300 lines (especially for complex fashion show/designer components)
- Maximum function length: 25 lines
- Maximum cyclomatic complexity: 10
- Fashion show-specific naming conventions:
  - Interfaces: `IFashionShow`, `IDesigner`, `ISponsor`, `ITicket`
  - Types: `TRunwaySchedule`, `TShowSegment`, `TSponsorTier`
  - Enums: `EFashionSeason`, `EShowType`, `ETicketCategory`
  - Constants: `FASHION_SHOW_CITIES`, `TICKET_TIERS`, `SPONSOR_LEVELS`
  - Variables/functions: camelCase (e.g., `getShowsByDesigner`, `calculateTicketRevenue`)
  - Components: PascalCase (e.g., `ShowCard`, `DesignerProfile`, `SponsorBanner`)
- Prefer early returns in event filtering and search functions
- Use named constants for all fashion show-specific values (seasons, show types, etc.)
```

## 2. Security Practices

```markdown
- Implement CSP to protect against XSS in user-generated content (designer bios, show descriptions)
- Validate all user inputs, especially for show creation, sponsorship applications, and ticket purchases
- Use parameterized queries for all database operations involving show/user/ticket data
- Implement role-based authentication (attendee, designer, sponsor, organizer, admin)
- Encrypt sensitive data (payment details, exclusive show access codes, sponsor contracts)
- Apply security headers on all public-facing pages
- Set secure and HttpOnly flags for session cookies
- Implement proper CORS policies for API endpoints
- Regular security audits of third-party ticketing and payment APIs
- Secure storage of sponsor marketing materials and exclusive show content
```

## 3. Performance Optimization

```markdown
- Implement code splitting for major sections (shows, designers, sponsors, tickets)
- Use memoization for expensive operations (show filtering, ticket inventory calculations)
- Image optimization for fashion show content:
  - Use next/image for all runway, designer, and sponsor images
  - Implement WebP/AVIF with proper fallbacks
  - Use appropriate sizing based on display context (thumbnails vs. full gallery)
  - Lazy load all below-the-fold runway and collection images
- Minimize bundle size:
  - Tree shake all fashion show component libraries
  - Dynamic import large components (runway galleries, venue maps, ticketing interfaces)
  - Optimize third-party dependencies (date pickers, carousels, payment processors)
- Implement caching for show listings, ticket availability, and sponsor showcases
- Virtualize long lists of shows, collections, and sponsor catalogs
- Optimize real-time ticket inventory and sales dashboards
```

## 4. Architecture Patterns

### Frontend Architecture

```markdown
- Component structure:
  - Atoms: Buttons, inputs, badges (status indicators for shows, ticket availability)
  - Molecules: Show cards, designer cards, sponsor banners, ticket selectors
  - Organisms: Show listings, sponsor galleries, checkout forms, marketing campaigns
  - Templates: Show page layouts, sponsor profile layouts, ticketing interfaces
  - Pages: Shows, designers, sponsors, tickets, marketing, sales reports
- State management:
  - Local state: Component-specific UI states
  - Complex local state: Form handling, filtering options, ticket selection
  - Global state: User authentication, shopping cart, selected show preferences
  - Server state: Show data, ticket inventory, sponsor information, sales metrics
- Next.js App Router for all routing
- React Hook Form for all forms (show registration, sponsor applications, ticket purchases)
- Zod for validation schemas
- Tailwind CSS with custom fashion show color palette
- Tremor components for all analytics and dashboards:
  - BarCharts for ticket sales by category
  - LineCharts for revenue trends
  - DonutCharts for sponsor contribution distribution
  - AreaCharts for attendance forecasting
  - Tables for detailed show and sales data
```

### Backend Architecture

```markdown
- RESTful API design for all fashion show endpoints
- Consistent HTTP methods and status codes
- API versioning for fashion show data, ticketing, and sponsorship
- Middleware for authentication, logging, and error handling
- Standardized error responses across all endpoints
- Rate limiting for public show APIs and ticketing endpoints
- Role-based authorization middleware
- Comprehensive logging for user actions, ticket transactions, and system events
- Database schema optimized for fashion show relationships, sponsorship tiers, and ticketing
- Efficient queries for real-time ticket inventory and sales reporting
```

## 5. Testing Standards

### Test Coverage

```markdown
- Target coverage metrics:
  - Statements: 80%
  - Branches: 75%
  - Functions: 80%
  - Lines: 80%
- Unit tests for:
  - Show filtering and sorting utilities
  - Ticket pricing and inventory calculations
  - Sponsorship tier benefits validation
  - Custom hooks (useShows, useTickets, useSponsors)
  - State management reducers
  - API clients
- Component tests for all UI elements
- Integration tests for critical flows (show registration, sponsorship application, ticket purchase)
- E2E tests for user journeys (browsing shows, applying for sponsorship, purchasing tickets)
- Mock responses for fashion show APIs, ticketing services, and payment processors
- Load testing for ticket sales during high-demand show launches
```

### Test Quality

```markdown
- Test behavior of fashion show components, not implementation details
- Isolate tests from external dependencies
- Use meaningful assertions for fashion show domain concepts
- Implement proper test data cleanup
- Write descriptive test names that explain fashion show scenarios
- Follow Arrange-Act-Assert pattern
- Test edge cases (sold-out shows, waitlists, limited ticket availability, sponsor conflicts)
- Verify marketing campaign tracking and analytics reporting accuracy
```

## 6. Development Workflow

### Version Control

```markdown
- Branch naming convention:
  - feature/FAS-123-show-filtering
  - feature/FAS-124-sponsor-dashboard
  - feature/FAS-125-ticket-checkout
  - bugfix/FAS-456-image-loading-error
  - hotfix/FAS-789-payment-processing-failure
- Commit message format:
  - feat(shows): implement filtering by designer and season
  - feat(tickets): add tiered pricing calculator
  - feat(sponsors): implement sponsor showcase gallery
  - fix(checkout): resolve payment gateway timeout
  - style(designers): update profile card layout
- Create focused commits around specific fashion show features
- Rebase/squash before merging to maintain clean history
- Pull request guidelines:
  - Include screenshots for UI changes to shows/tickets/sponsors
  - Link to related fashion show feature tickets
  - Provide testing instructions for complex features
```

### Code Review Process

```markdown
- Review checklist:
  - Code follows fashion show domain naming conventions
  - Show/ticket/sponsor features work as expected
  - Tests cover critical fashion show user flows
  - Security considerations for payment/personal data
  - Performance for image-heavy pages and real-time ticket inventory
  - Documentation for fashion show-specific features
- Provide constructive feedback
- Focus reviews on code quality and user experience
- Require approval from at least one domain expert
```

## 7. AI Assistance Best Practices

### Context Management

```markdown
- Include relevant fashion show domain files when using AI:
  - Related show/ticket/sponsor components
  - Fashion show domain type definitions
  - Existing patterns for similar features
- For complex fashion show features, include:
  - Example components with similar functionality
  - Fashion show business rules
  - Relevant API response structures
  - Ticketing and sponsorship logic
```

### Effective Prompting

```markdown
- Be specific about fashion show domain requirements
- For complex features, break down into steps:
  1. Define fashion show domain types (shows, tickets, sponsors)
  2. Create base components
  3. Implement business logic
- Prioritize including:
  - Fashion show domain types (shows, designers, sponsors, tickets)
  - UI component patterns
  - Business rules for fashion shows, ticketing, and sponsorships
- Request explanations for fashion show-specific logic
```

### Feedback Loop

```markdown
- Iteratively refine AI outputs for fashion show components
- Provide domain-specific context when outputs need improvement
- Save successful prompts for similar fashion show features
- Document AI-generated patterns for team reference
```

## 8. Tech Stack Specifics

### Tremor Dashboard Components

```markdown
- Use Tremor for all analytics and data visualization:
  - @tremor/react: Latest version for all dashboard components
  - Configure with fashion show theme colors
  - Implement responsive layouts for all dashboards
- Standard Tremor components to use:
  - Card: For containing dashboard widgets and metrics
  - Grid: For responsive dashboard layouts
  - Metric: For key performance indicators (ticket sales, revenue)
  - BarChart: For comparing ticket sales across shows
  - LineChart: For tracking sales and attendance over time
  - DonutChart: For sponsor contribution distribution
  - AreaChart: For cumulative sales and forecasting
  - ScatterChart: For analyzing show performance metrics
  - Table: For detailed show, sponsor, and sales data
- Custom Tremor configurations:
  - Create reusable chart configurations in utils/chartUtils.ts
  - Implement consistent color schemes across all visualizations
  - Define standard data transformers for API responses
```

### Next.js and React

```markdown
- Next.js App Router for all routing
- Server Components for data-heavy pages
- Client Components for interactive elements
- React Server Actions for form submissions
- Image component for all fashion show imagery
- Font optimization for consistent typography
- Metadata API for SEO optimization of show pages
```

## 9. PowerShell Command Guidelines

```markdown
- Always use proper PowerShell syntax for project commands
- Navigate to project directories using:
  ```powershell
  Set-Location -Path .\template-solar
  # or
  cd .\template-solar
  ```
- Run development server with:
  ```powershell
  Push-Location -Path .\template-solar; npm run dev; Pop-Location
  ```
- Install dependencies with:
  ```powershell
  npm install package-name
  ```
- For running multiple commands, use semicolons:
  ```powershell
  Set-Location -Path .\template-solar; npm run build; npm run start
  ```
- Use proper path separators (backslashes) in Windows environments
- For background tasks, use:
  ```powershell
  Start-Process -NoNewWindow npm -ArgumentList "run dev"
  ```
- Check environment with:
  ```powershell
  $env:NODE_ENV = "development"
  ```
- Reference the powershell-doc.md file for additional command syntax
```

This configuration is tailored specifically for the Fashionistas fashion show events platform, focusing on the unique requirements of fashion show management, designer showcases, sponsor management, ticket sales, marketing campaigns, and event planning. 