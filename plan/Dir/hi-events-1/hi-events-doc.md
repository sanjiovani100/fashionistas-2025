# Hi.Events Installation and Setup Guide

This document provides comprehensive instructions for installing and setting up Hi.Events, an open-source event management and ticketing platform.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation Options](#installation-options)
- [Option 1: Docker All-in-One Setup](#option-1-docker-all-in-one-setup)
- [Option 2: Local Development Environment](#option-2-local-development-environment)
- [Option 3: Manual Installation](#option-3-manual-installation)
- [Post-Installation Configuration](#post-installation-configuration)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

## Prerequisites

Before installing Hi.Events, ensure your system meets the following requirements:

- **Operating System**: Windows, macOS, or Linux
- **Software Requirements**:
  - Git
  - Docker and Docker Compose (for Docker installation methods)
  - PHP 8.1+ with required extensions (for manual installation)
  - Composer (for manual installation)
  - Node.js 16+ and npm/yarn (for manual installation)
  - PostgreSQL 13+ (for manual installation)

## Installation Options

Hi.Events can be installed using several methods. Choose the one that best fits your needs:


2. **Local Development Environment**: For developers who want to contribute or customize
3. **Manual Installation**: For complete control over the installation process

## Option 1: Docker All-in-One Setup

This method uses a single Docker container that includes both frontend and backend services.

### Step 1: Create a Dedicated Directory

```bash
# Create a new directory for Hi.Events
mkdir hi-events
cd hi-events
```

### Step 2: Clone the Repository

```bash
git clone https://github.com/HiEventsDev/Hi.Events.git .
```

### Step 3: Navigate to the Docker Directory

```bash
cd docker/all-in-one
```

### Step 4: Generate Security Keys

#### For Unix/Linux/MacOS:
```bash
echo base64:$(openssl rand -base64 32)  # For APP_KEY
openssl rand -base64 32                 # For JWT_SECRET
```

#### For Windows (PowerShell):
```powershell
# For APP_KEY
$randomBytes = New-Object byte[] 32
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($randomBytes)
$base64String = [Convert]::ToBase64String($randomBytes)
Write-Output "APP_KEY=base64:$base64String"

# For JWT_SECRET
$randomBytes = New-Object byte[] 32
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($randomBytes)
$base64String = [Convert]::ToBase64String($randomBytes)
Write-Output "JWT_SECRET=$base64String"
```

### Step 5: Update the .env File

Edit the `.env` file in the `docker/all-in-one` directory and add the generated keys:

```
APP_KEY=your_generated_app_key
JWT_SECRET=your_generated_jwt_secret
```

### Step 6: Start the Docker Containers

```bash
docker-compose up -d
```

### Step 7: Access Hi.Events

Open your browser and navigate to:
- http://localhost:8123/auth/register

Create an account to start using Hi.Events.

## Option 2: Local Development Environment

This setup is ideal for developers who want to contribute to Hi.Events or make customizations.

### Step 1: Create a Dedicated Directory

```bash
# Create a new directory for Hi.Events development
mkdir hi-events-dev
cd hi-events-dev
```

### Step 2: Clone the Repository

```bash
git clone https://github.com/HiEventsDev/Hi.Events.git .
```

### Step 3: Navigate to the Development Docker Directory

```bash
cd docker/development
```

### Step 4: Start the Development Environment

#### For Unix/Linux/MacOS:
```bash
./start-dev.sh
```

#### For Windows:
If using WSL or Git Bash:
```bash
./start-dev.sh
```

If using PowerShell or Command Prompt, you may need to adapt the script or run the commands manually.

### Step 5: Access the Development Environment

After the setup completes, access:
- Frontend: https://localhost:8443
- Backend/API: https://localhost:8443/api
- Mail Service (Mailpit): http://localhost:8025

## Option 3: Manual Installation

For complete control over the installation process, follow these steps:

### Step 1: Create a Dedicated Directory

```bash
# Create a new directory for Hi.Events
mkdir hi-events-manual
cd hi-events-manual
```

### Step 2: Clone the Repository

```bash
git clone https://github.com/HiEventsDev/Hi.Events.git .
```

### Step 3: Set Up the Backend

```bash
cd backend

# Copy the environment file
cp .env.example .env

# Install dependencies
composer install

# Generate application key
php artisan key:generate

# Set up the database
php artisan migrate

# Seed the database with initial data
php artisan db:seed

# Create a symbolic link for storage
php artisan storage:link
```

### Step 4: Set Up the Frontend

```bash
cd ../frontend

# Copy the environment file
cp .env.example .env

# Install dependencies
npm install
# or
yarn install

# Build the frontend
npm run build
# or
yarn build
```

### Step 5: Configure Web Server

Configure your web server (Apache, Nginx, etc.) to point to the appropriate directories:
- Backend: `backend/public`
- Frontend: `frontend/dist`

## Post-Installation Configuration

After installation, consider configuring the following:

### Email Settings

Update the email settings in the `.env` file to use your preferred email provider:

```
MAIL_MAILER=smtp
MAIL_HOST=your-smtp-host
MAIL_PORT=587
MAIL_USERNAME=your-username
MAIL_PASSWORD=your-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@yourdomain.com
MAIL_FROM_NAME="Hi Events"
```

### Stripe Integration

To enable payments, set up Stripe integration:

1. Create a Stripe account at https://stripe.com
2. Get your API keys from the Stripe dashboard
3. Update the `.env` file with your Stripe keys:

```
STRIPE_PUBLIC_KEY=pk_test_your_public_key
STRIPE_SECRET_KEY=sk_test_your_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
```

4. Set up Stripe webhooks to point to your Hi.Events instance:
   - For local development: Use the Stripe CLI to forward webhooks
   - For production: Configure a webhook endpoint in the Stripe dashboard

## Troubleshooting

### Common Issues

1. **Docker Containers Not Starting**
   - Check Docker logs: `docker logs container_name`
   - Ensure ports are not already in use
   - Verify Docker and Docker Compose are up to date

2. **Database Connection Issues**
   - Verify database credentials in the `.env` file
   - Ensure the database server is running
   - Check network connectivity between services

3. **Email Not Working**
   - Verify email credentials in the `.env` file
   - Test email connectivity using the mail service
   - Check firewall settings for outgoing SMTP connections

### Getting Help

If you encounter issues not covered here:
- Check the [official documentation](https://hi.events/docs)
- Search for issues on the [GitHub repository](https://github.com/HiEventsDev/Hi.Events/issues)
- Join the community on [Slack or Discord] (if available)

## Additional Resources

- [Official Hi.Events Documentation](https://hi.events/docs)
- [GitHub Repository](https://github.com/HiEventsDev/Hi.Events)
- [Contributing Guidelines](https://github.com/HiEventsDev/Hi.Events/blob/develop/CONTRIBUTING.md)
- [License Information](https://hi.events/licensing) 