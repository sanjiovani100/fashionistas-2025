# Cosmic - Modern Next.js Template

A modern, feature-rich Next.js template designed for building scalable web applications with a focus on developer experience and performance.

## 🚀 Tech Stack

- **Framework:** Next.js 14.2.16 (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **UI Components:** 
  - Radix UI (Accessible primitives)
  - Framer Motion (Animations)
  - Embla Carousel
  - Custom UI components
- **Form Handling:** React Hook Form with Zod validation
- **Package Manager:** pnpm
- **Development Tools:**
  - ESLint
  - PostCSS
  - TypeScript

## 📁 Project Structure

```
cosmic/
├── app/                    # Next.js App Router directory
│   ├── layout.tsx         # Root layout component
│   ├── page.tsx           # Home page
│   ├── globals.css        # Global styles
│   └── fonts/             # Font configurations
├── components/            # React components
│   ├── ui/               # Reusable UI components
│   ├── layout/           # Layout components
│   └── icons/            # Icon components
├── lib/                  # Utility functions and shared logic
├── public/               # Static assets
└── @data/               # Data files and configurations
```

## ⚡ Features

1. **Modern Stack**
   - Built with Next.js 14 App Router
   - TypeScript for type safety
   - Tailwind CSS for styling

2. **UI Components**
   - Radix UI integration for accessible components:
     - Accordion
     - Avatar
     - Collapsible
     - Dialog
     - Label
     - Navigation Menu
     - Scroll Area
     - Select
     - Separator
     - Slot

3. **Enhanced UI/UX**
   - Framer Motion animations
   - Embla Carousel for smooth carousels
   - Custom Marquee component
   - Dark mode support via next-themes

4. **Form Management**
   - React Hook Form integration
   - Zod validation
   - Form resolvers for type-safe forms

5. **Developer Experience**
   - ESLint configuration
   - TypeScript strict mode
   - Tailwind CSS configuration with animations
   - Class variance authority for component variants

## 🛠️ Setup and Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/bundui/cosmic.git
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Run development server**
   ```bash
   pnpm dev
   ```

4. **Build for production**
   ```bash
   pnpm build
   ```

## 📦 Dependencies

### Core Dependencies
- next: 14.2.16
- react: ^18
- react-dom: ^18
- typescript: ^5

### UI and Animation
- @radix-ui/* components
- framer-motion: ^11.11.10
- embla-carousel-react: ^8.3.0
- @devnomic/marquee: ^1.0.2
- lucide-react: ^0.453.0

### Styling and Utilities
- tailwindcss: ^3.4.1
- class-variance-authority: ^0.7.0
- clsx: ^2.1.1
- tailwind-merge: ^2.5.4
- tailwindcss-animate: ^1.0.7

### Form Handling
- react-hook-form: ^7.53.1
- @hookform/resolvers: ^3.9.0
- zod: 3.24.0-canary.20241016T212913

## 🎨 Styling and Theming

The template uses Tailwind CSS with additional configurations:
- Custom animations through tailwindcss-animate
- Dark mode support
- Class variance authority for component variants
- Utility classes for common patterns

## 🔒 TypeScript Configuration

The project uses strict TypeScript configuration with:
- Strict mode enabled
- ESNext module system
- Path aliases configured
- Type checking for all components and utilities

## 📱 Responsive Design

Built with a mobile-first approach using Tailwind CSS breakpoints:
- sm: 640px
- md: 768px
- lg: 1024px
- xl: 1280px
- 2xl: 1536px

## 🚀 Deployment

Ready for deployment on Vercel or any other hosting platform that supports Next.js applications.

## 📄 License

MIT License - feel free to use this template for your projects.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 