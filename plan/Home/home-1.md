# Home Page Content

## Overview

This document outlines the content for building the Fashionistas homepage using shadcn components. The implementation is based on the existing design but adapted for our fashion events platform.

## Homepage Structure

The homepage will consist of the following sections:

1. Hero Section - Main banner with fashion imagery and primary CTA
2. Brand/Partner Logos - Display of fashion brands and partners
3. Event Highlights - Featured fashion events in a grid layout
4. Featured Content - Upcoming events and designer spotlights
5. Fashion Team/Models - Showcase of team members or featured models
6. Statistics/Achievements - Numeric highlights of platform success
7. Testimonials - Customer/attendee reviews
8. FAQ Section - Common questions about fashion events
9. Call-to-Action - Final conversion element

## Homepage Component Tree

Below is a visual representation of the homepage component structure:

```
HomePage (app/(landing)/page.tsx)
│
├── HeroSection
│   ├── Title & Subtitle
│   ├── CTA Buttons
│   └── Background Elements
│
├── Brands (Partner Logos)
│   ├── Section Title
│   ├── Description
│   └── Logo Grid
│
├── FeatureSectionWithGrid (Event Highlights)
│   ├── Section Title
│   ├── Description
│   └── Feature Grid Items
│      ├── Grand Fashion Showcase
│      ├── Fashion Night Life
│      ├── VIP Experience
│      └── Designer Spotlights
│
├── Gallery6 (Upcoming Events)
│   ├── Section Title
│   ├── Description
│   └── Image Grid
│      ├── Event 1
│      ├── Event 2
│      └── ...more events
│
├── ShadcnblocksComFeature108 (Featured Designers)
│   ├── Section Title
│   ├── Description
│   └── Designer Profiles
│      ├── Designer 1
│      ├── Designer 2
│      └── ...more designers
│
├── Statistics Section
│   ├── Section Title
│   ├── Description
│   └── Stat Grid
│      ├── Fashion Events Hosted
│      ├── Happy Attendees
│      ├── Designer Showcases
│      └── Countries Represented
│
├── FAQ Section
│   ├── Section Title
│   ├── Description
│   └── Accordion Items
│      ├── Question 1
│      ├── Question 2
│      └── ...more questions
│
├── ShadcnblocksComCta11 (Mid-page CTA)
│   ├── Heading
│   ├── Description
│   └── Action Buttons
│
├── TestimonialsSection
│   ├── Section Title
│   └── Testimonial Cards
│      ├── Testimonial 1
│      ├── Testimonial 2
│      └── ...more testimonials
│
├── ShadcnblocksComCta10 (Final CTA)
│   ├── Heading
│   ├── Description
│   └── Email Input & Button
│
└── FooterSection
    ├── Company Info
    ├── Navigation Links
    └── Social Media Links
```

## Content Details

### 1. Hero Section
Title: Fashionistas Fashion Events
Subtitle: Join us for exclusive celebrations of fashion, a great party and VIP Experience 
CTA Button: Explore Events

### 2. Brand/Partner Logos
Title: Partnered with Top Fashion Houses
Description: Our platform features events from the world's leading fashion brands and designers

### 3. Event Highlights Section
Title: Discover Our Signature Experiences
Subtitle: unforgettable fashion moments

#### Fashion Show
- Title: Grand Fashion Showcase
- Description: Experience the epitome of fashion with our professional runway shows
- Features:
  - designer collections
  - Professional models
  - State-of-the-art production
  - Front-row experiences
- CTA: View Runway Events

#### Party 
- Title: Fashion Night Life
- Description: Celebrate in style at our exclusive fashion parties
- Features:
  - Themed celebrations
  - Live entertainment
  - Networking opportunities
  - Premium beverages
- CTA: Explore Parties

#### VIP Experience
- Title: Ultimate Luxury Access
- Description: Indulge in our most exclusive fashion experiences
- Features:
  - Private viewing areas
  - Personal concierge
  - Designer meet & greets
  - Luxury amenities
- CTA: Discover VIP Packages

### 4. Featured Events
Title: Upcoming Fashion Events
Description: Mark your calendar for these highly anticipated fashion moments

1. Spring Swim 2025 (March)
   - Title: Spring Swim Spectacular
   - Date: March 14th, 2025
   - Time: 3:00 PM - 10:00 PM
   - Location: Medellín Botanical Gardens
   - Description: Welcome spring in style with our exclusive swimwear showcase
   - Highlights:
     - International swimwear collections
     - Sustainable beachwear showcase
     - Designer meet & greets
     - Poolside networking
   - Price Range: $125 - $599
   - Status: Early Bird Registration

2. April Fashion Forward 2025
   - Title: Future of Fashion Summit
   - Date: April 20th, 2025
   - Time: 2:00 PM - 9:00 PM
   - Location: Innovation Center Medellín
   - Description: Experience the intersection of technology and fashion
   - Highlights:
     - Tech-integrated fashion shows
     - Smart fabric demonstrations
     - Virtual reality experiences
     - Digital fashion marketplace
   - Price Range: $150 - $699
   - Status: Coming Soon

3. May Gala 2025
   - Title: Spring Elegance Gala
   - Date: May 15th, 2025
   - Time: 6:00 PM - 1:00 AM
   - Location: Grand Plaza Hotel
   - Description: A night of haute couture and refined elegance
   - Highlights:
     - Evening wear collections
     - Luxury accessories showcase
     - Gourmet dining experience
     - Live orchestral performance
   - Price Range: $200 - $899
   - Status: Register Interest

### 5. Featured Designers Section
Title: Meet Our Visionary Designers
Subtitle: Discover the creative minds shaping fashion's future

#### Designer Spotlights
1. Elena Martinez
   - Award-winning haute couture designer
   - Known for: Sustainable luxury fashion
   - Featuring: Spring/Summer 2024 Collection

2. James Chen
   - Contemporary streetwear innovator
   - Known for: Urban-luxury fusion
   - Featuring: Limited edition Valentine's capsule

3. Sofia Patel
   - Emerging designer of the year
   - Known for: Modern romantic aesthetics
   - Featuring: Evening wear collection

### 6. Statistics/Achievements Section
Title: Fashion Impact
Description: Our platform's reach and influence in numbers

- Fashion Events Hosted: 250+
- Happy Attendees: 120K
- Designer Showcases: 75+
- Countries Represented: 30

### 7. FAQ Section
Title: Frequently Asked Questions
Description: Answers to common questions about our fashion events

#### Common Questions
1. How do I purchase tickets for events?
2. What is the refund policy for events?
3. How can designers showcase their work on Fashionistas?
4. Are there VIP packages available?
5. How can I stay updated on new events?

### 8. Testimonials Section
Title: What Attendees Say
Description: Hear from fashion enthusiasts who have attended our events

### 9. Mid-page Call-to-Action Section
Title: Be Part of Fashion's Next Chapter
Description: Join our community of fashion enthusiasts for exclusive event access and special offers
Primary Button: Sign Up Now
Secondary Button: Learn More

### 10. Ticket Section
Title: Secure Your Fashion Experience
Subtitle: Choose the perfect ticket package for your style

#### Ticket Packages
1. VIP Elite Package
   - Price: $800,000
   - Front row seating
   - Exclusive lounge access
   - Designer meet & greets
   - Luxury gift bag
   - Complimentary valet parking

2. Premium Experience
   - Price: $250,000
   - Priority seating
   - VIP lounge access
   - Welcome champagne
   - Event gift bag
   - Reserved parking

3. General Admission
   - Price: $100,000
   - Standard seating
   - Event access
   - Complimentary drinks
   - Digital program

### 11. Partners Section
Title: Join Our Fashion Community
Subtitle: Connect with industry leaders and fashion innovators

#### Models - Join Our Model Community
Title: Showcase your talent and build your portfolio

#### Designers - Showcase Your Designs
Title: Present your collection to fashion industry leaders

#### Sponsors - Partner With Us
Title: Connect your brand with fashion-forward audiences

### 12. Final Call-to-Action Section
Title: Ready to Experience Fashion Events?
Description: Find and book your tickets to the most exclusive fashion shows and experiences
Input Placeholder: Enter your email
Button Text: Get Started
Checkbox Label: Send me updates about new events and special offers

### 13. Footer Section
Company Name: Fashionistas
Description: Your gateway to exclusive fashion events worldwide
Links Categories:
- Events
- About
- Support
Social Media:
- Instagram
- Twitter
- Facebook
- LinkedIn
