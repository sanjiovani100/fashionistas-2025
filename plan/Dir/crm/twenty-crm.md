# Twenty CRM - Installation and Setup Guide

Twenty is an open-source CRM (Customer Relationship Management) system that positions itself as a modern alternative to Salesforce. It's built with a modern tech stack including TypeScript, React, NestJS, PostgreSQL, and Redis.

## Repository
https://github.com/twentyhq/twenty.git

## Official Website
https://twenty.com/developers

## Installation Options

There are two main ways to install Twenty CRM:

1. **Local Setup** - For development and testing
2. **Self-Hosting** - For production deployment

## Local Setup Instructions

Follow these steps to set up Twenty CRM locally for development:

1. **Prerequisites**:
   - Node.js (check .nvmrc for the recommended version)
   - Docker and Docker Compose
   - Git

2. **Clone the repository**:
   ```bash
   git clone https://github.com/twentyhq/twenty.git
   cd twenty
   ```

3. **Install dependencies**:
   ```bash
   yarn install
   ```

4. **Start the development environment**:
   ```bash
   yarn dx
   ```
   This command will set up the necessary Docker containers and start the development server.

5. **Access the application**:
   Once the setup is complete, you can access Twenty CRM at http://localhost:3000

## Self-Hosting Instructions

For deploying Twenty CRM on your own server:

1. **Prepare Your Environment**:
   - Ensure your server has at least 2GB RAM
   - Install Docker and Docker Compose
   - Choose one of the following installation methods:

   **Quick Start (One Command)**:
   ```bash
   bash <(curl -sL https://git.new/20)
   ```

   **Manual Setup**:
   - Generate secure tokens:
     ```bash
     openssl rand -base64 32
     ```

2. **Download Configuration Files**:
   ```bash
   curl -O https://raw.githubusercontent.com/twentyhq/twenty/main/packages/twenty-docker/docker-compose.yml
   ```

3. **Configure Environment Variables**:
   - Create and configure the `.env` file with database passwords, server URLs, and the tokens generated earlier
   - Set `SERVER_URL` to your domain or IP address if you're setting up for external access

4. **Launch the Application**:
   ```bash
   docker-compose up -d
   ```

5. **Verify Container Status**:
   ```bash
   docker-compose ps
   ```
   
   If you encounter issues, check the logs:
   ```bash
   docker-compose logs
   ```

6. **Access and Configure**:
   - Access the CRM interface via `http://localhost:3000` or your configured domain
   - For external access, ensure port 3000 is open in your firewall

## Troubleshooting Tips

- **Login Issues**: If you can't log in, you may need to reset the database
- **Reverse Proxy Configuration**: Ensure headers like `X-Forwarded-For` and `X-Forwarded-Proto` are properly set
- **Server URL Conflicts**: Verify that the `SERVER_URL` in `.env` matches your access URL, especially if using SSL

## Features

Twenty CRM offers a range of features:

- Add, filter, sort, edit, and track customers
- Create opportunities for companies
- View rich notes displayed in a timeline
- Create tasks on records
- Navigate quickly using keyboard shortcuts and search
- Connect to other tools through APIs and webhooks
- Customize your data model to meet business needs

## Tech Stack

- TypeScript
- Nx (Monorepo)
- NestJS with BullMQ, PostgreSQL, Redis
- React with Recoil and Emotion
- GraphQL APIs
- REST APIs

For more detailed information, visit the [official documentation](https://docs.twenty.com).
