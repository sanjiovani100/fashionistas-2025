# System Requirements Specification (SRS) Generation Prompt

Please analyze the Fashionistas project and create a comprehensive System Requirements Specification document that details the technical implementation using Cosmic UI Kit, shadcn-ui-kit-dashboard, and Supabase backend, optimized for Vercel deployment.

## 1. Architecture & Technical Stack

### Frontend (Next.js 14+ & React 18)
- App Router with Server Components, Route Groups, Parallel Routes
- Performance optimization (Core Web Vitals targets: LCP < 2.5s, FID < 100ms, CLS < 0.1)
- State management with Server Components, SWR/React Query
- Edge Runtime & CDN optimization
- TypeScript & ESLint configuration

### Template Integration
- Cosmic UI Kit:
  * Landing pages, SaaS components, Marketing elements
  * High-converting templates, Animation system
  * Responsive patterns, Theme customization
- shadcn-ui-kit-dashboard:
  * Admin interfaces, Data visualization
  * Management consoles, Analytics dashboards
  * E-commerce components, Project tools

### Backend (Supabase & Vercel)
- Database: Schema design, RLS policies, Relationships
- Authentication: Multi-provider, JWT, 2FA
- Storage: CDN integration, Media handling
- Edge Functions & Serverless deployment
- Real-time subscriptions & API endpoints

## 2. Core Features & Components

### UI Components
- Layout: Responsive containers, Grid systems, Navigation
- Data: Tables, Charts, Forms, Rich editors
- Feedback: Notifications, Alerts, Progress indicators
- Marketing: Hero sections, Pricing tables, CTAs
- Dashboard: Analytics, Management interfaces, Settings

### Performance Requirements
- Bundle optimization & Code splitting
- Image & Font optimization
- Edge caching strategy
- Real-time data handling
- Animation performance

### Security & Integration
- Authentication & Authorization
- Data encryption & API security
- Third-party integrations (Payment, Email, SMS)
- Monitoring & Analytics setup

## 3. Development & Deployment

### Development Environment
- Node.js & package management
- Git workflow & CI/CD pipeline
- Testing strategy (Unit, E2E, Performance)
- Documentation requirements

### Vercel Deployment
- Build optimization & caching
- Environment configuration
- Regional deployment
- Monitoring setup

### Maintenance & Monitoring
- Performance tracking
- Error monitoring
- Backup strategies
- Update procedures

## 4. Success Metrics & Requirements

### Performance Targets
- Page load times < 3s
- API response < 200ms
- 99.9% uptime
- Real-time sync < 100ms

### Quality Standards
- WCAG 2.1 compliance
- Cross-browser compatibility
- Mobile responsiveness
- Security compliance

The SRS should provide specific implementation details, performance targets, and measurable success criteria. Include code examples and diagrams where necessary. Focus on Vercel deployment optimization and performance best practices.

Format using markdown with clear sections and subsections. All requirements should be testable and measurable.
