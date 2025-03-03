# Cosmic Setup Guide

This guide provides step-by-step instructions for setting up the Cosmic Next.js template on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:
- Node.js (version 18.17 or later)
- pnpm (version 8.0 or later)
- Git

## Installation Steps

### 1. Install Node.js
```powershell
# Download and install Node.js from https://nodejs.org/
# Verify installation
node --version
npm --version
```

### 2. Install pnpm
```powershell
# Install pnpm using npm
npm install -g pnpm

# Verify installation
pnpm --version

# Setup pnpm global configuration
pnpm setup
```
⚠️ After running `pnpm setup`, close and reopen your terminal for the changes to take effect.

### 3. Clone the Repository
```powershell
# Navigate to your desired directory
cd your-projects-directory

# Clone the repository
git clone https://github.com/bundui/cosmic.git

# Navigate to the project directory
cd cosmic
```

### 4. Install Dependencies
```powershell
# Clean install dependencies
pnpm install --force
```

### 5. Start Development Server
```powershell
# Start the development server
pnpm run dev
```

The application should now be running at `http://localhost:3000`

## Troubleshooting

If you encounter any issues:

1. **'next' is not recognized error**
   ```powershell
   # Try running with npx
   npx next dev
   ```

2. **Module not found errors**
   ```powershell
   # Remove existing modules and lock file
   Remove-Item -Recurse -Force node_modules
   Remove-Item pnpm-lock.yaml
   
   # Reinstall dependencies
   pnpm install --force
   ```

3. **Path issues**
   ```powershell
   # Verify Next.js installation
   Get-ChildItem node_modules\.bin\next*
   ```

## Project Structure

```
cosmic/
├── app/                    # Next.js App Router directory
├── components/            # React components
├── lib/                  # Utility functions
├── public/               # Static assets
└── @data/               # Data files
```

## Available Scripts

- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm start` - Start production server
- `pnpm lint` - Run ESLint

## Environment Setup

Make sure your environment meets these requirements:
- Node.js version: 18.17 or later
- pnpm version: 8.0 or later
- TypeScript version: 5.x
- Next.js version: 14.2.16

## Additional Configuration

### TypeScript Configuration
The project uses a strict TypeScript configuration. Review `tsconfig.json` for specific settings.

### Tailwind CSS
Tailwind CSS is preconfigured with custom animations and dark mode support. See `tailwind.config.ts` for customization.

### ESLint
ESLint is configured with Next.js recommended settings. See `.eslintrc.json` for rules.

## Common Issues and Solutions

1. **Global Dependencies**
   If you have issues with global dependencies, try installing them locally:
   ```powershell
   pnpm add -D next@14.2.16
   ```

2. **Path Resolution**
   If modules aren't being found, check your PATH environment variable:
   ```powershell
   $env:PATH
   ```

3. **PowerShell Execution Policy**
   If scripts won't run, you might need to adjust the execution policy:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Development Best Practices

1. Always use `pnpm` for consistency with the project's package management
2. Keep Node.js and pnpm versions up to date
3. Use the provided UI components from the components directory
4. Follow the TypeScript strict mode guidelines
5. Use the built-in form handling with React Hook Form and Zod

## Support and Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [React Hook Form Documentation](https://react-hook-form.com/) 