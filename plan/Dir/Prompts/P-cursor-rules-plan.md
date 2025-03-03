# Prompt: Fashionistas Platform Cursor Rules Documentation

Create a comprehensive set of cursor rules documentation for the Fashionistas platform that ensures consistent development practices, efficient code organization, and seamless integration across all platform components.

## Document Structure

1. **Core Rule Categories (30-40 lines per category)**

   a) **File Organization Rules**
   - Directory structure standards
   - File naming conventions
   - Module organization
   - Component hierarchy
   - Asset management
   - Example patterns
   - Anti-patterns to avoid

   b) **Code Style Rules**
   - TypeScript/JavaScript standards
   - React component patterns
   - CSS/SCSS organization
   - Import ordering
   - Comment standards
   - Documentation requirements
   - Example implementations

   c) **Integration Rules**
   - API integration patterns
   - Service connection standards
   - Authentication handling
   - Error management
   - State management
   - Example implementations
   - Common pitfalls

   d) **Performance Rules**
   - Load time optimization
   - Bundle size management
   - Image optimization
   - Caching strategies
   - Code splitting
   - Example configurations
   - Performance metrics

2. **Feature-Specific Rules (20-30 lines per feature)**

   a) **Event Management**
   ```typescript
   // Example rule format:
   {
     "glob": "src/features/events/**/*",
     "rules": [
       "Use Hi.Events SDK for all event operations",
       "Implement error boundaries for event components",
       "Follow ticket management patterns",
       "Use standard event type definitions"
     ]
   }
   ```

   b) **CRM Integration**
   ```typescript
   {
     "glob": "src/features/crm/**/*",
     "rules": [
       "Use Twenty CRM SDK for all CRM operations",
       "Follow contact management patterns",
       "Implement pipeline tracking standards",
       "Use standard lead scoring system"
     ]
   }
   ```

   c) **Communication Features**
   ```typescript
   {
     "glob": "src/features/communication/**/*",
     "rules": [
       "Use WhatsApp SDK for messaging",
       "Follow template management patterns",
       "Implement message queuing",
       "Use standard notification system"
     ]
   }
   ```

   d) **Payment Processing**
   ```typescript
   {
     "glob": "src/features/payments/**/*",
     "rules": [
       "Use Stripe SDK for all transactions",
       "Follow PCI compliance patterns",
       "Implement error handling",
       "Use standard payment flows"
     ]
   }
   ```

   e) **Media Management**
   ```typescript
   {
     "glob": "src/features/media/**/*",
     "rules": [
       "Use Cloudinary SDK for media",
       "Follow optimization patterns",
       "Implement lazy loading",
       "Use standard image components"
     ]
   }
   ```

3. **Component Rules (15-20 lines per component type)**

   a) **UI Components**
   ```typescript
   {
     "glob": "src/components/ui/**/*",
     "rules": [
       "Follow atomic design principles",
       "Use styled-components patterns",
       "Implement accessibility standards",
       "Follow responsive design rules"
     ]
   }
   ```

   b) **Form Components**
   ```typescript
   {
     "glob": "src/components/forms/**/*",
     "rules": [
       "Use React Hook Form",
       "Follow validation patterns",
       "Implement error handling",
       "Use standard input components"
     ]
   }
   ```

   c) **Layout Components**
   ```typescript
   {
     "glob": "src/components/layout/**/*",
     "rules": [
       "Use grid system",
       "Follow responsive patterns",
       "Implement container rules",
       "Use standard breakpoints"
     ]
   }
   ```

4. **Integration-Specific Rules (15-20 lines per integration)**

   a) **API Integration**
   ```typescript
   {
     "glob": "src/api/**/*",
     "rules": [
       "Use axios instances",
       "Follow error handling patterns",
       "Implement retry logic",
       "Use standard response types"
     ]
   }
   ```

   b) **State Management**
   ```typescript
   {
     "glob": "src/store/**/*",
     "rules": [
       "Use Redux Toolkit",
       "Follow slice patterns",
       "Implement selector standards",
       "Use standard action types"
     ]
   }
   ```

5. **Testing Rules (20-30 lines)**
   ```typescript
   {
     "glob": "src/**/*.test.ts",
     "rules": [
       "Use React Testing Library",
       "Follow testing patterns",
       "Implement coverage standards",
       "Use standard test utilities"
     ]
   }
   ```

## Required Rule Documentation Files

1. **Core Rules**
   - `docs/cursor-rules/file-organization.md`
   - `docs/cursor-rules/code-style.md`
   - `docs/cursor-rules/integration-standards.md`
   - `docs/cursor-rules/performance-rules.md`

2. **Feature Rules**
   - `docs/cursor-rules/features/event-management.md`
   - `docs/cursor-rules/features/crm-integration.md`
   - `docs/cursor-rules/features/communication.md`
   - `docs/cursor-rules/features/payments.md`
   - `docs/cursor-rules/features/media.md`

3. **Component Rules**
   - `docs/cursor-rules/components/ui-components.md`
   - `docs/cursor-rules/components/form-components.md`
   - `docs/cursor-rules/components/layout-components.md`

4. **Integration Rules**
   - `docs/cursor-rules/integrations/api-standards.md`
   - `docs/cursor-rules/integrations/state-management.md`
   - `docs/cursor-rules/integrations/testing-standards.md`

## Rule Documentation Format

Each rule document should follow this structure:
```markdown
# [Rule Category] Standards

## Overview
Brief description of the rule category and its importance

## Rules
1. Rule name
   - Description
   - Rationale
   - Example
   - Anti-pattern
   - Additional notes

## Implementation
Code examples and patterns

## Common Issues
Known issues and solutions

## Related Rules
Links to related rule documents
```

## Maintenance Guidelines

1. **Rule Updates**
   - Regular review schedule
   - Version control
   - Change documentation
   - Team notification process

2. **Enforcement**
   - Linting configuration
   - Pre-commit hooks
   - CI/CD integration
   - Code review checklist

3. **Training**
   - Onboarding documentation
   - Example repositories
   - Training workshops
   - Knowledge sharing

The final documentation should provide clear, actionable rules that ensure consistent development practices across the Fashionistas platform while maintaining flexibility for future growth and adaptation.
