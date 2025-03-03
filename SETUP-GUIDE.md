# Supabase MCP Server Setup Guide

This guide will walk you through setting up and running the Supabase MCP server to allow AI assistants to interact with your Supabase database.

## Prerequisites

- Docker Desktop installed
- Your Supabase project URL and anon/public API key

## Quick Start (Recommended)

Run the all-in-one setup script:

```powershell
.\start-all.ps1
```

This script will:
1. Check if Docker Desktop is running and start it if needed
2. Prompt you to enter your Supabase credentials if not configured
3. Start the Supabase MCP server

## Manual Setup

If you prefer to set up each component manually, follow these steps:

### Step 1: Start Docker Desktop

Ensure Docker Desktop is running on your system.

### Step 2: Update Your Supabase Credentials

Run the following PowerShell command, replacing the placeholders with your actual Supabase information:

```powershell
.\update-supabase-credentials.ps1 -ProjectUrl "YOUR_PROJECT_ID_OR_URL" -ApiKey "YOUR_SUPABASE_ANON_KEY"
```

Examples:
- Using project ID: `.\update-supabase-credentials.ps1 -ProjectUrl "abcdefghijklm" -ApiKey "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."`
- Using full URL: `.\update-supabase-credentials.ps1 -ProjectUrl "https://abcdefghijklm.supabase.co" -ApiKey "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."`

### Step 3: Start the Supabase MCP Server

Run the following command to start the server:

```powershell
.\start-supabase-mcp.ps1
```

This will:
1. Check if Docker is installed
2. Verify the docker-compose file exists
3. Start the Supabase MCP server using Docker

The server will run in the foreground. Keep this window open while you're using the MCP server.

## Testing the Connection

In a new PowerShell window, run:

```powershell
.\test-supabase-mcp.ps1
```

This will check if the server is running correctly and responding to health checks.

## Configure Cursor

1. Open Cursor settings
2. Add a new MCP server with:
   - Name: `supabase`
   - Type: `http`
   - URL: `http://localhost:3000`

## Try It Out

Ask Cursor AI to interact with your Supabase database. For example:

- "Show me the tables in my Supabase database"
- "Query the users table and show me the first 5 records"
- "Count the number of records in the events table"

## Troubleshooting

### Server Won't Start

- Make sure Docker Desktop is running
- Check if port 3000 is already in use by another application
- Verify your Supabase credentials are correct

### Connection Issues

- Ensure the server is running (check the Docker Desktop dashboard)
- Verify the server is listening on port 3000
- Check if there are any firewall issues blocking the connection

### Database Query Errors

- Confirm your API key has the necessary permissions
- Verify the schema name is correct (usually "public")
- Check if the tables you're trying to access exist in your database

## Stopping the Server

To stop the server, press `Ctrl+C` in the PowerShell window where the server is running, or stop the container from Docker Desktop. 