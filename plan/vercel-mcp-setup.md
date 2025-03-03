# Vercel MCP Server Setup Guide

This guide provides instructions for setting up the Vercel MCP server for use with Cursor IDE.

## Available MCP Servers

### 1. Quegenx Vercel MCP Server
Repository: [https://github.com/Quegenx/vercel-mcp-server](https://github.com/Quegenx/vercel-mcp-server)

### 2. Glama.ai MCP Server
URL: [https://glama.ai/mcp/servers/a2zu61kut4](https://glama.ai/mcp/servers/a2zu61kut4)

The Glama.ai MCP server provides a managed solution with:
- Pre-configured settings
- Automatic updates
- Built-in security
- Integrated monitoring
- Team collaboration features

## Prerequisites

- Node.js >= 16.x
- npm >= 8.x
- Vercel account with:
  - Access Token
  - Team ID (optional)
  - Project ID (optional)
- Cursor IDE

## Installation Steps

1. Clone the repository:
```bash
git clone https://github.com/Quegenx/vercel-mcp-server.git
cd vercel-mcp-server
```

2. Install dependencies and build:
```bash
npm install
npm run build
```

3. Configure Vercel Access Token:
   - Go to [Vercel Tokens](https://vercel.com/account/tokens) to generate your access token
   - Update the token in these files:
     - `src/config/constants.ts`:
       ```typescript
       export const DEFAULT_ACCESS_TOKEN = "YOUR_ACCESS_TOKEN";
       ```
     - `src/index.ts`:
       ```typescript
       export const DEFAULT_ACCESS_TOKEN = "YOUR_ACCESS_TOKEN";
       ```

## Cursor IDE Configuration

### Setting up the MCP Server

Add the server in Cursor's MCP settings using the appropriate command for your operating system:

#### macOS
```bash
# Default installation
/usr/local/bin/node /path/to/vercel-mcp/dist/index.js

# Homebrew installation
/opt/homebrew/bin/node /path/to/vercel-mcp/dist/index.js

# NVM installation
~/.nvm/versions/node/v18.x.x/bin/node /path/to/vercel-mcp/dist/index.js
```

#### Windows
```bash
# Default installation
C:\Program Files\nodejs\node.exe C:\path\to\vercel-mcp\dist\index.js

# NVM for Windows
C:\nvm4w\nodejs\node.exe C:\path\to\vercel-mcp\dist\index.js

# Scoop installation
C:\Users\username\scoop\apps\nodejs\current\node.exe C:\path\to\vercel-mcp\dist\index.js
```

#### Linux
```bash
# Default installation
/usr/bin/node /path/to/vercel-mcp/dist/index.js

# NVM installation
~/.nvm/versions/node/v18.x.x/bin/node /path/to/vercel-mcp/dist/index.js
```

Replace `/path/to/vercel-mcp` or `C:\path\to\vercel-mcp` with your actual installation path.

To find your Node.js path:
```bash
# macOS/Linux
which node

# Windows
where node
```

## Troubleshooting

### Debug Mode
To enable detailed logging, add `DEBUG=true` before your command:

```bash
# macOS/Linux
DEBUG=true /usr/local/bin/node /path/to/vercel-mcp/dist/index.js

# Windows
set DEBUG=true && "C:\Program Files\nodejs\node.exe" "C:\path\to\vercel-mcp\dist\index.js"
```

### Common Issues

1. **Node.js Path Issues**
   - Verify correct Node.js path using `which node` (Mac/Linux) or `where node` (Windows)
   - Ensure Node.js version is >= 16.x

2. **Access Token Issues**
   - Verify Vercel access token is valid
   - Check token permissions
   - Ensure token hasn't expired

3. **MCP Not Detecting Tools**
   - Refresh Cursor's MCP settings
   - Verify server is running without errors
   - Check Vercel credentials

## Security Notes

- Keep your Vercel access token secure
- Never commit sensitive credentials to version control
- Use appropriate access controls and permissions
- Follow Vercel's security best practices

## Available Features

The MCP server provides comprehensive tools for managing your Vercel deployments:

- Team Management
- Project Management
- Deployment Management
- Domain & DNS Management
- Environment & Configuration
- Access Control & Security
- Monitoring & Logging
- User Management
- Marketplace & Integration
- Environments & Secrets
- Artifacts & Aliases

For detailed usage of these features, refer to the [Vercel MCP Server documentation](https://github.com/Quegenx/vercel-mcp-server).

## Glama.ai MCP Server Setup

1. Visit [https://glama.ai/mcp/servers/a2zu61kut4](https://glama.ai/mcp/servers/a2zu61kut4)
2. Sign up or log in to your Glama.ai account
3. Follow the guided setup process:
   - Connect your Vercel account
   - Configure team access (if needed)
   - Set up monitoring preferences
   - Configure deployment settings

### Integration with Cursor

1. Open Cursor IDE
2. Go to Settings > MCP Servers
3. Add New Server
4. Enter the Glama.ai MCP server URL:
   ```
   https://glama.ai/mcp/servers/a2zu61kut4
   ```
5. Add your Glama.ai API key when prompted
6. Test the connection

### Glama.ai Features

- One-click setup
- Automatic server management
- Real-time monitoring
- Team collaboration tools
- Integrated security
- Automatic updates
- Deployment tracking
- Performance analytics
