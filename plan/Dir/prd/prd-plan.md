# Product Requirements Document (PRD) Plan & Prompts

## Overview
This document provides a concise plan for the Product Requirements Document (PRD) for the fashion event management platform, along with structured prompts to generate each section.

## PRD Structure & Purpose

The PRD translates the platform vision into detailed requirements that guide development, serving to:
- Define functional and non-functional requirements
- Establish clear acceptance criteria
- Provide a reference for design, development, and testing
- Serve as a contract between stakeholders and development team

### Document Sections

1. **Executive Summary & Document Purpose**
2. **Product Overview & Modules**
3. **User Stories & Acceptance Criteria** (by module)
   - Event Planning & Management
   - Ticketing & Registration
   - Sponsor Management
   - Marketing & Promotion
   - Analytics & Reporting
4. **Technical Requirements & Constraints**
5. **Non-functional Requirements**

## Implementation Workflow
1. Generate Executive Summary and Product Overview
2. Develop user stories for each module in priority order
3. Define technical and non-functional requirements
4. Review with stakeholders
5. Finalize and baseline the document

---

# Generation Prompts

## Prompt 1: Executive Summary & Document Purpose

```
Create an executive summary and document purpose section for a Product Requirements Document (PRD) for a fashion event management platform. Include:

1. A concise overview of the product (2-3 paragraphs)
2. The purpose and scope of this PRD
3. Target audience for this document
4. How this document should be used
5. Related documents and dependencies
6. Document conventions and terminology
7. Assumptions and constraints

Format this as a professional PRD section with clear headings, concise language, and appropriate level of detail for both technical and business stakeholders.
```

## Prompt 2: Product Overview & Modules

```
Generate a comprehensive product overview and module breakdown for a fashion event management platform PRD. Include:

1. High-level product description
2. Core product philosophy and principles
3. System context diagram showing how the platform interacts with external systems
4. Key modules and their primary responsibilities:
   - Event Planning & Management
   - Ticketing & Registration
   - Sponsor Management
   - Marketing & Promotion
   - Analytics & Reporting
   - User Management & Authentication
   - Billing & Payments
   - Integration & API Services

5. For each module, provide:
   - Purpose and objectives
   - Key functionality overview
   - Primary user roles interacting with the module
   - Integration points with other modules
   - Critical success factors

Format this as a professional PRD section with clear module definitions, diagrams where appropriate, and concise descriptions that establish the foundation for detailed requirements.
```

## Prompt 3: User Stories & Acceptance Criteria - Event Planning Module

```
Create detailed user stories with acceptance criteria for the Event Planning & Management module of a fashion event management platform. Include user stories for:

1. Event Creation and Setup:
   - Creating new events with basic details
   - Setting up event timeline and schedule
   - Managing venue details and layout
   - Configuring event branding and themes
   - Setting up event teams and permissions

2. Designer and Model Management:
   - Inviting designers to participate
   - Managing designer profiles and collections
   - Casting and scheduling models
   - Managing fittings and rehearsals
   - Tracking designer requirements and logistics

3. Event Schedule Management:
   - Creating multi-day, multi-track schedules
   - Managing time slots and runway shows
   - Handling schedule conflicts and changes
   - Publishing and updating event schedules
   - Notifying stakeholders of schedule changes

4. Resource Management:
   - Allocating equipment and resources
   - Managing staff assignments
   - Tracking inventory and supplies
   - Handling resource conflicts
   - Setting up backstage areas and facilities

For each user story, follow this format:
- User story: "As a [role], I want to [action] so that [benefit]"
- Acceptance criteria: 3-5 specific, testable criteria that define when the story is complete
- Priority: Must-have, Should-have, Could-have, or Won't-have (MoSCoW method)
- Notes: Any additional context, constraints, or considerations

Format this as a professional PRD section with clear organization, consistent structure, and sufficient detail for development planning.
```

## Prompt 4: User Stories & Acceptance Criteria - Ticketing Module

```
Create detailed user stories with acceptance criteria for the Ticketing & Registration module of a fashion event management platform. Include user stories for:

1. Ticket Configuration:
   - Setting up ticket types and tiers (VIP, Early Bird, Standard)
   - Configuring pricing and availability
   - Setting up discount codes and promotions
   - Managing ticket inventory and capacity
   - Creating ticket packages and bundles

2. Purchase Experience:
   - Browsing available tickets
   - Selecting and purchasing tickets
   - Applying discount codes
   - Managing shopping cart and checkout
   - Receiving confirmation and tickets
   - Modifying or canceling orders

3. Check-in and Validation:
   - Generating QR codes and digital tickets
   - Validating tickets at entry points
   - Managing VIP and special access
   - Handling group check-ins
   - Processing walk-up registrations
   - Managing capacity and access control

4. Reporting and Analytics:
   - Tracking sales and revenue
   - Monitoring attendance and check-ins
   - Analyzing purchase patterns
   - Generating attendee lists and reports
   - Reconciling financial transactions

For each user story, follow this format:
- User story: "As a [role], I want to [action] so that [benefit]"
- Acceptance criteria: 3-5 specific, testable criteria that define when the story is complete
- Priority: Must-have, Should-have, Could-have, or Won't-have (MoSCoW method)
- Notes: Any additional context, constraints, or considerations

Format this as a professional PRD section with clear organization, consistent structure, and sufficient detail for development planning.
```

## Prompt 5: User Stories & Acceptance Criteria - Sponsor Management Module

```
Create detailed user stories with acceptance criteria for the Sponsor Management module of a fashion event management platform. Include user stories for:

1. Sponsor Acquisition and Onboarding:
   - Creating sponsorship packages and tiers
   - Managing sponsor recruitment workflow
   - Processing sponsor applications
   - Generating and managing contracts
   - Collecting sponsor assets and requirements

2. Sponsor Portal and Management:
   - Sponsor profile and dashboard
   - Managing sponsor assets and materials
   - Tracking deliverables and commitments
   - Communicating with event organizers
   - Accessing analytics and performance data

3. Sponsor Visibility and Promotion:
   - Displaying sponsors on event website and app
   - Managing sponsor placement and visibility
   - Scheduling sponsored content and activities
   - Tracking impressions and engagement
   - Generating sponsor QR codes and tracking links

4. Sponsor ROI and Reporting:
   - Tracking sponsor-specific metrics
   - Generating performance reports
   - Calculating ROI and value delivered
   - Comparing performance across events
   - Generating post-event sponsor reports

For each user story, follow this format:
- User story: "As a [role], I want to [action] so that [benefit]"
- Acceptance criteria: 3-5 specific, testable criteria that define when the story is complete
- Priority: Must-have, Should-have, Could-have, or Won't-have (MoSCoW method)
- Notes: Any additional context, constraints, or considerations

Format this as a professional PRD section with clear organization, consistent structure, and sufficient detail for development planning.
```

## Prompt 6: User Stories & Acceptance Criteria - Marketing Module

```
Create detailed user stories with acceptance criteria for the Marketing & Promotion module of a fashion event management platform. Include user stories for:

1. Email Marketing:
   - Creating email templates and campaigns
   - Managing subscriber lists and segments
   - Scheduling and sending automated emails
   - Tracking email performance metrics
   - A/B testing email content and subject lines

2. Social Media Integration:
   - Connecting social media accounts
   - Scheduling and publishing posts
   - Creating and managing hashtag campaigns
   - Monitoring social media engagement
   - Aggregating social media content for display

3. Influencer Management:
   - Identifying and recruiting influencers
   - Managing influencer relationships and agreements
   - Tracking influencer content and mentions
   - Measuring influencer campaign performance
   - Generating influencer-specific promo codes

4. Content Management:
   - Creating and publishing event content
   - Managing digital assets and media library
   - Creating landing pages and microsites
   - Scheduling content releases
   - Managing press releases and media kits

For each user story, follow this format:
- User story: "As a [role], I want to [action] so that [benefit]"
- Acceptance criteria: 3-5 specific, testable criteria that define when the story is complete
- Priority: Must-have, Should-have, Could-have, or Won't-have (MoSCoW method)
- Notes: Any additional context, constraints, or considerations

Format this as a professional PRD section with clear organization, consistent structure, and sufficient detail for development planning.
```

## Prompt 7: User Stories & Acceptance Criteria - Analytics Module

```
Create detailed user stories with acceptance criteria for the Analytics & Reporting module of a fashion event management platform. Include user stories for:

1. Real-time Event Analytics:
   - Monitoring live attendance and check-ins
   - Tracking session popularity and engagement
   - Visualizing attendee flow and hotspots
   - Monitoring ticket sales in real-time
   - Tracking social media mentions and sentiment

2. Financial Analytics:
   - Tracking revenue by ticket type and source
   - Monitoring expenses against budget
   - Calculating profit margins and ROI
   - Forecasting final financial outcomes
   - Comparing performance against projections

3. Marketing Performance:
   - Measuring campaign effectiveness
   - Tracking conversion rates and attribution
   - Analyzing customer acquisition costs
   - Measuring email and social media performance
   - Evaluating influencer campaign results

4. Custom Reports and Dashboards:
   - Creating custom report templates
   - Building personalized dashboards
   - Scheduling automated reports
   - Exporting data in multiple formats
   - Sharing reports with stakeholders

For each user story, follow this format:
- User story: "As a [role], I want to [action] so that [benefit]"
- Acceptance criteria: 3-5 specific, testable criteria that define when the story is complete
- Priority: Must-have, Should-have, Could-have, or Won't-have (MoSCoW method)
- Notes: Any additional context, constraints, or considerations

Format this as a professional PRD section with clear organization, consistent structure, and sufficient detail for development planning.
```

## Prompt 8: Technical Requirements & Constraints

```
Generate comprehensive technical requirements and constraints for a fashion event management platform PRD. Include:

1. Performance Requirements:
   - Response time expectations
   - Throughput requirements (concurrent users, transactions per second)
   - Scalability requirements for peak usage
   - Availability and uptime requirements
   - Data processing and reporting speed requirements

2. Security Requirements:
   - Authentication and authorization requirements
   - Data protection and privacy compliance (GDPR, CCPA, etc.)
   - Secure payment processing standards
   - Data encryption requirements
   - Security testing and certification requirements

3. Integration Requirements:
   - Required third-party integrations (payment gateways, CRM, marketing tools)
   - API requirements and standards
   - Single sign-on requirements
   - Data import/export capabilities
   - Mobile app integration requirements

4. Technical Constraints:
   - Supported browsers and versions
   - Mobile device compatibility
   - Bandwidth and network considerations
   - Hosting and deployment constraints
   - Technology stack requirements or limitations

5. Compliance Requirements:
   - Accessibility standards (WCAG 2.1 AA)
   - Industry-specific regulations
   - International considerations and localization
   - Data retention and archiving requirements
   - Audit and logging requirements

Format this as a professional PRD section with clear categorization, specific measurable requirements where possible, and rationale for critical requirements.
```

## Prompt 9: Non-functional Requirements

```
Create a comprehensive section on non-functional requirements for a fashion event management platform PRD. Include:

1. Usability Requirements:
   - User interface standards and guidelines
   - Accessibility requirements (WCAG compliance level)
   - Internationalization and localization requirements
   - User experience benchmarks and standards
   - Training and onboarding requirements

2. Reliability Requirements:
   - System availability targets (uptime percentage)
   - Fault tolerance requirements
   - Disaster recovery requirements
   - Backup and restore capabilities
   - Error handling and notification standards

3. Supportability Requirements:
   - Logging and monitoring requirements
   - Troubleshooting capabilities
   - Maintenance windows and procedures
   - Support tier structure and SLAs
   - Documentation requirements

4. Scalability Requirements:
   - User growth projections and requirements
   - Data volume growth expectations
   - Performance under peak load conditions
   - Geographic distribution requirements
   - Horizontal vs. vertical scaling considerations

5. Environmental Requirements:
   - Hosting environment specifications
   - Network infrastructure requirements
   - Third-party service dependencies
   - Development, staging, and production environments
   - Deployment and DevOps requirements

Format this as a professional PRD section with clear, measurable requirements where possible, and explanations of why each requirement is important to the platform's success.
```

## Prompt 10: Complete Product Requirements Document

```
Using the sections previously generated (Executive Summary, Product Overview, User Stories for each module, Technical Requirements, and Non-functional Requirements), compile a complete Product Requirements Document (PRD) for a fashion event management platform. Add:

1. A table of contents with hyperlinks to each section
2. A glossary of terms and abbreviations
3. A version history table
4. A document approval section
5. Appropriate appendices for supplementary information
6. Cross-references between related requirements
7. An index of features by priority

Ensure the document has:
- Consistent formatting and numbering of requirements
- Clear traceability between business objectives and requirements
- Appropriate use of tables, diagrams, and visual elements
- A logical flow from high-level overview to detailed specifications
- Proper categorization and organization of requirements

The final document should be comprehensive yet accessible, providing clear guidance for design and development teams while remaining valuable to business stakeholders.
```

## How to Use These Prompts

1. **Sequential Approach**: Work through these prompts in order to build your PRD section by section
2. **Modular Development**: Focus on one module at a time for the user stories sections
3. **Review and Refine**: After generating content with each prompt, review and refine it to align with your platform vision
4. **Stakeholder Input**: Share draft sections with key stakeholders for feedback before finalizing
5. **Final Assembly**: Use the final prompt to compile all sections into a cohesive document

## Maintenance Guidelines
- Version-control all PRD documents
- Follow formal change management processes
- Conduct regular reviews to ensure alignment with vision
- Maintain cross-references to other documents 