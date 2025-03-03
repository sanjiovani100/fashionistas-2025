# AI-Powered Prompts for Event Management Platform Development

This document contains structured prompts optimized for building an end-to-end event management platform using Cursor AI. These prompts are organized by development stages to create a clear roadmap for implementation.

## Development Roadmap Overview

### Stage 1: Core Features
Essential functionality to get the platform operational with basic event management capabilities.

### Stage 2: Intermediate Features
Enhanced functionality that improves user experience and adds valuable business capabilities.

### Stage 3: Advanced Features
Sophisticated features leveraging AI and advanced analytics to provide competitive advantages.

---

## Stage 1: Core Features

### Event Planning & Scheduling

#### Event Creation Workflow
```
Generate a React component for a multi-step event creation form with the following features:
- Basic event details (name, description, type, category)
- Date and time selection with timezone support
- Venue selection and capacity management
- Designer and model assignment
- Sponsor allocation
- Budget planning
Include form validation, state management with React Context, and API integration.
```

#### Venue & Capacity Management
```
Develop a venue management system with:
- Database schema for venues (PostgreSQL)
- API endpoints for CRUD operations
- Capacity calculation based on venue layout
- Seating arrangement visualization
- Accessibility compliance checking
Include best practices for data validation and error handling.
```

### Ticketing & Registration

#### Multi-tier Ticketing System
```
Design a ticketing system with:
- Database schema for ticket types (VIP, Early Bird, Standard)
- React components for ticket selection and purchase
- Backend logic for inventory management
- Discount code functionality
- Group booking options
Include Stripe integration for payment processing and proper error handling.
```

#### Ticket Validation System
```
Create a mobile-optimized ticket validation system with:
- QR code generation for tickets (using qrcode.react)
- Scanner functionality for event staff (using react-qr-reader)
- Real-time validation against database
- Check-in status tracking and analytics
- Offline mode with sync capabilities
Implement with Next.js and React, with proper error states and success animations.
```

### Sponsor & Partnership Management

#### Sponsor Onboarding Automation
```
Create a sponsor onboarding workflow that:
- Generates customized sponsorship packages based on event type
- Automates contract generation with dynamic terms
- Implements digital signature integration (DocuSign/HelloSign)
- Creates sponsor profiles with logo and brand guidelines
- Sets up payment schedules and tracking
Use React Hook Form for form handling and Zod for validation.
```

### Communication & Attendee Engagement

#### Automated Event Communications
```
Develop a communication system that:
- Sends personalized event reminders via email and WhatsApp
- Delivers real-time updates about schedule changes
- Provides weather alerts for outdoor events
- Sends transportation and parking information
- Distributes post-event materials and recordings
Use a template-based system with dynamic content insertion and proper scheduling.
```

#### Interactive Event Dashboard
```
Develop a real-time event dashboard for attendees:
- Personalized agenda with session reminders
- Live updates on session availability and changes
- Interactive venue map with points of interest
- Activity feed of event highlights and announcements
- Personalized recommendations based on user interests
Implement with React and WebSockets for real-time updates.
```

### System Integration & Scalability

#### Third-party API Integration
```
Develop a unified API integration layer for:
- Payment processing (Stripe, PayPal)
- Analytics (Google Analytics, Mixpanel)
- Media management (Cloudinary, AWS S3)
- Email delivery (SendGrid, Mailchimp)
- CRM systems (Salesforce, HubSpot)
Implement with proper error handling, rate limiting, and retry logic.
```

#### Scalable Architecture Design
```
Create a scalable architecture blueprint with:
- Microservices definition for core platform functions
- Database sharding strategy for multi-tenant support
- Caching implementation for performance optimization
- Serverless functions for event-driven processes
- CI/CD pipeline configuration
Include infrastructure-as-code templates and deployment documentation.
```

---

## Stage 2: Intermediate Features

### Event Planning & Scheduling

#### Schedule Conflict Detection
```
Create a TypeScript utility that detects scheduling conflicts for:
- Venue availability
- Designer availability
- Model booking conflicts
- Staff scheduling overlaps
The utility should accept an array of existing events and a proposed new event, then return any conflicts with detailed information.
```

#### Automated Workflow Coordination
```
Create a workflow automation system using Next.js API routes that:
- Sends automated notifications to designers when assigned to an event
- Coordinates model casting and fitting schedules
- Manages sponsor placement and requirements
- Generates task timelines with dependencies
- Sends reminders for upcoming deadlines
Implement with a queue-based system using Bull/Redis for reliability.
```

### Ticketing & Registration

#### Dynamic Pricing Engine
```
Implement a dynamic pricing algorithm that:
- Adjusts ticket prices based on current sales velocity
- Implements time-based pricing tiers
- Factors in historical data for similar events
- Includes configurable minimum and maximum price bounds
- Provides an admin dashboard for monitoring and manual overrides
Use TypeScript for type safety and include comprehensive unit tests.
```

#### Refund & Cancellation Workflow
```
Develop an automated refund processing system that:
- Implements configurable refund policies (full, partial, time-based)
- Handles cancellation requests through a user dashboard
- Processes refunds through payment gateway APIs
- Manages ticket inventory after cancellations
- Generates appropriate notifications and receipts
Include proper logging and transaction history.
```

### Sponsor & Partnership Management

#### Sponsor Benefits Tracking
```
Create a dashboard for tracking sponsor benefits delivery:
- Visual checklist of contractual obligations
- Timeline for deliverable due dates
- Upload functionality for proof of delivery
- Automated notifications for upcoming deadlines
- Status reporting for sponsors and organizers
Use React with Tailwind CSS for the UI and implement proper state management.
```

### Marketing & Promotion

#### Email Marketing Sequence Generator
```
Create a system that generates email marketing sequences for events:
- Pre-event excitement building (3 months, 1 month, 2 weeks, 1 week, day before)
- Post-registration onboarding emails
- Last-minute ticket sales campaigns
- Post-event follow-up and feedback collection
- Personalized content based on attendee interests
Implement with React, Node.js, and integrate with email service providers via API.
```

#### Social Media Content Strategy
```
Develop a content calendar generator that:
- Creates a timeline of posts across platforms (Instagram, Twitter, LinkedIn)
- Suggests optimal posting times based on audience analytics
- Generates content templates for different event milestones
- Includes hashtag recommendations and audience targeting
- Schedules posts with preview functionality
Use React for the frontend and implement a drag-and-drop interface for rearranging posts.
```

### Sales & Revenue Optimization

#### Automated Financial Reporting
```
Create a financial reporting system that:
- Generates daily sales summaries
- Reconciles transactions across payment providers
- Calculates profit margins and break-even analysis
- Tracks expenses against budget
- Provides cash flow projections
Use React for the frontend and implement exportable reports in multiple formats.
```

### Communication & Attendee Engagement

#### Real-time Support System
```
Create a real-time support platform with:
- Live chat functionality for attendees and sponsors
- AI-powered first-response system for common questions
- Ticket categorization and routing to appropriate staff
- Knowledge base integration for self-service
- Performance analytics for support team
Implement with WebSockets for real-time communication and proper queue management.
```

### Analytics & Performance Tracking

#### Real-time Event Analytics
```
Create a comprehensive analytics dashboard with:
- Real-time attendance tracking by session and area
- Ticket sales velocity and revenue metrics
- Engagement scores for different event elements
- Social media sentiment and mention tracking
- Comparative analysis against previous events
Use React with a charting library and implement real-time data updates.
```

#### Automated Post-Event Reporting
```
Create a system that generates comprehensive post-event reports:
- Attendance and demographic analysis
- Financial performance and ROI calculations
- Sponsor value delivery metrics
- Marketing campaign effectiveness
- Year-over-year growth analysis
Implement with customizable templates and multiple export formats.
```

### System Integration & Scalability

#### CRM & Marketing Integration
```
Implement a data synchronization system between:
- Event platform and CRM systems
- Marketing automation tools
- Email marketing platforms
- Social media management tools
- Customer support systems
Use webhooks and scheduled jobs for reliable data consistency.
```

---

## Stage 3: Advanced Features

### Event Planning & Scheduling

#### AI-Powered Event Optimization
```
Develop an AI system that optimizes event schedules based on:
- Historical attendance patterns
- Speaker/performer popularity
- Venue capacity constraints
- Weather predictions
- Competing events in the area
Implement with machine learning models and provide confidence scores for recommendations.
```

### Sponsor & Partnership Management

#### AI-Powered Sponsor Matching
```
Develop an algorithm that matches potential sponsors to events based on:
- Historical attendee demographics
- Event category and theme alignment
- Previous sponsorship performance
- Brand affinity scores
- Competitive analysis
Implement with TypeScript and include visualization of match scores for admin users.
```

#### Sponsor ROI Analytics
```
Implement an analytics system that measures sponsor ROI through:
- Impression tracking on digital materials
- Booth visitor analytics
- Lead generation metrics
- Post-event survey data analysis
- Comparative performance against similar events
Use Chart.js or Recharts for visualizations and implement data export functionality.
```

### Marketing & Promotion

#### Attendee Inquiry Chatbot
```
Implement a chatbot system using:
- Intent recognition for common questions
- Integration with event database for dynamic responses
- Escalation to human support when needed
- Multi-language support
- Analytics dashboard for common questions and satisfaction rates
Use React for the frontend and implement with a modern chatbot framework.
```

#### Influencer Campaign Tracking
```
Create a system for managing influencer marketing:
- Influencer profile database with audience demographics
- Campaign brief generation and distribution
- Tracking links and promo code generation
- Performance analytics (clicks, conversions, engagement)
- Payment processing based on performance metrics
Implement with TypeScript and include proper data visualization components.
```

### Sales & Revenue Optimization

#### Predictive Sales Analytics
```
Develop a sales forecasting system that:
- Analyzes historical sales patterns for similar events
- Factors in current sales velocity and marketing activities
- Provides daily/weekly projections with confidence intervals
- Identifies sales anomalies and potential issues
- Recommends pricing or marketing adjustments
Implement with TypeScript and use TensorFlow.js for prediction models.
```

#### Upsell Recommendation Engine
```
Implement a recommendation engine for ticket add-ons:
- VIP upgrades based on user behavior
- Complementary event suggestions
- Merchandise recommendations
- Premium experience packages
- Group discount opportunities
Use collaborative filtering algorithms and implement A/B testing capabilities.
```

#### Dynamic Pricing Strategy
```
Create an AI-driven pricing optimization system that:
- Analyzes competitor event pricing
- Factors in demand signals and inventory levels
- Implements time-based discounting strategies
- Provides price elasticity analysis
- Recommends optimal price points for maximum revenue
Implement with TypeScript and include an admin dashboard for strategy configuration.
```

### Communication & Attendee Engagement

#### Networking Recommendations
```
Implement an AI-driven networking system that:
- Analyzes attendee profiles and interests
- Suggests potential connections at the event
- Facilitates meeting scheduling during the event
- Provides conversation starters based on shared interests
- Tracks networking effectiveness through feedback
Use graph algorithms for connection recommendations and implement privacy controls.
```

### Analytics & Performance Tracking

#### Sentiment Analysis System
```
Implement a sentiment analysis system for:
- Social media mentions of the event
- Feedback form responses
- Support ticket content
- Post-event survey results
- App store reviews
Use natural language processing techniques and provide trend analysis over time.
```

#### Predictive Success Modeling
```
Develop predictive models for:
- Attendee satisfaction based on event characteristics
- Future attendance projections for recurring events
- Content popularity for session planning
- Revenue optimization opportunities
- Churn prediction for repeat attendees
Implement with TensorFlow.js and provide confidence intervals for predictions.
```

### System Integration & Scalability

#### AI Decision Support Integration
```
Develop an AI decision support system that:
- Recommends optimal event timing based on historical data
- Suggests pricing strategies for maximum revenue
- Identifies potential issues before they occur
- Recommends marketing budget allocation
- Provides staffing recommendations based on attendance projections
Implement with a modular architecture that allows for model updates and A/B testing.
```

---

## Development Timeline Recommendations

### Stage 1: Core Features (Months 1-3)
Focus on building the essential infrastructure and basic functionality to get the platform operational. This includes event creation, ticketing, sponsor management, and basic communication tools.

### Stage 2: Intermediate Features (Months 4-6)
Enhance the platform with more sophisticated features that improve user experience and business operations. This includes workflow automation, dynamic pricing, and enhanced analytics.

### Stage 3: Advanced Features (Months 7-12)
Implement AI-powered features that provide competitive advantages and sophisticated capabilities. This includes predictive analytics, recommendation engines, and advanced optimization algorithms.

---

## Best Practices for Using These Prompts

1. **Provide Context**: When using these prompts, include relevant information about your current project state and specific requirements.

2. **Incremental Development**: Use these prompts in a logical sequence, building upon previously generated components.

3. **Review & Refine**: Always review AI-generated code for best practices, security considerations, and alignment with your specific needs.

4. **Testing Focus**: Request test cases alongside implementation to ensure functionality works as expected.

5. **Documentation**: Ask for inline documentation and usage examples for complex components.

6. **Integration Guidance**: When implementing a new feature, ask for guidance on integrating it with existing systems.

7. **Performance Considerations**: Request performance optimization suggestions for critical components.

8. **Security Review**: Ask for security best practices specific to the component being developed.

9. **Accessibility**: Ensure UI components include proper accessibility attributes and keyboard navigation.

10. **Mobile Responsiveness**: Request responsive design considerations for all user-facing components. 