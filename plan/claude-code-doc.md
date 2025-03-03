# Claude Code Documentation for Cursor IDE Integration

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Standard Installation](#standard-installation)
  - [Windows Installation (Using WSL)](#windows-installation-using-wsl)
  - [Next Steps After WSL Installation](#next-steps-after-wsl-installation)
- [Integrating with Cursor IDE](#integrating-with-cursor-ide)
  - [Keyboard Shortcuts](#keyboard-shortcuts-in-cursor-ide)
- [Using Claude Code](#using-claude-code-with-cursor)
  - [Basic Commands](#basic-commands)
  - [Project Memory](#project-memory)
- [MCP Server Integration](#mcp-server-integration)
  - [Managing MCP Servers](#managing-mcp-servers)
  - [Common MCP Servers](#common-mcp-servers)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
- [Resources](#resources)

## Overview

[Claude Code](https://github.com/anthropics/claude-code) is a command-line tool that enhances your coding experience by connecting Anthropic's Claude AI capabilities with your development environment. This document provides instructions for setting up and using Claude Code with Cursor IDE.

## Installation

### Prerequisites
- A modern operating system (Windows, macOS, or Linux)
- Node.js 16 or higher
- npm or yarn package manager
- Cursor IDE installed
- An Anthropic API key

### Standard Installation

1. Install Claude Code globally using npm:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

   Or using yarn:
   ```bash
   yarn global add @anthropic-ai/claude-code
   ```

2. Configure your Anthropic API key:
   ```bash
   claude config set api_key YOUR_API_KEY
   ```

   You can obtain an API key from the [Anthropic Console](https://console.anthropic.com/).

3. Verify installation:
   ```bash
   claude --version
   ```

### Windows Installation (Using WSL)

Claude Code is not officially supported on Windows and requires macOS or Linux. Windows users should use Windows Subsystem for Linux (WSL):

1. **Install WSL**:
   - Open PowerShell as Administrator:
     - Search for "PowerShell" in the Start menu
     - Right-click and select "Run as administrator"
   - Install WSL with Ubuntu:
     ```powershell
     # Run in PowerShell as Administrator
     wsl --install
     ```
   - This command installs WSL along with the default Ubuntu distribution
   - Restart your computer after installation
   - After restart, Ubuntu will open automatically to complete setup
   - Create a username and password when prompted

   > **Troubleshooting**: If you encounter errors, ensure Windows is updated to the latest version. For manual installation, try `wsl --install -d Ubuntu-20.04`

2. **Install NVM (Node Version Manager) in WSL**:
   - Open Ubuntu from the Start menu
   - Update package lists and install curl:
     ```bash
     sudo apt-get update
     sudo apt-get install curl
     ```
   - Install NVM:
     ```bash
     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
     ```

3. **Activate NVM**:
   ```bash
   source ~/.bashrc
   ```

4. **Install Node.js using NVM**:
   ```bash
   nvm install node
   ```

5. **Verify Node.js is installed in the Linux environment**:
   ```bash
   which npm
   ```
   Should show: `/home/username/.nvm/versions/node/vX.X.X/bin/npm`

6. **Configure npm to detect the environment as Linux**:
   ```bash
   npm config set os linux
   ```

7. **Install Claude Code**:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

8. **Verify installation**:
   ```bash
   claude --version
   ```

### Next Steps After WSL Installation

After installing Claude Code in WSL, follow these steps to start using it:

1. **Open WSL Terminal**:
   ```powershell
   wsl
   ```

2. **Navigate to Your Project**:
   ```bash
   # Access Windows files
   cd /mnt/c/Users/yourusername/your-project
   ```

3. **Initialize Claude Code**:
   ```bash
   # Start Claude and authenticate
   claude
   
   # Create project memory file (optional)
   claude init
   ```

4. **Test Basic Commands**:
   ```bash
   # Ask a question
   claude "What does this code do?"
   
   # Generate code
   claude "Create a function that sorts an array"
   ```

5. **Set Up MCP Servers (Optional)**:
   ```bash
   # Install and add Sequential Thinking MCP
   npm install -g @modelcontextprotocol/server-sequential-thinking
   claude mcp add sequential-thinking $(which mcp-sequential-thinking)
   ```

6. **Create Shortcut (Optional)**:
   ```bash
   # Add alias for easier access
   echo 'alias cc="claude"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Integrating with Cursor IDE

Cursor IDE provides native integration with Claude AI. To connect Claude Code:

1. Open Cursor IDE
2. Go to Settings > AI Settings
3. Select Claude as your AI provider
4. Enter your Anthropic API key
5. (Optional) Configure advanced settings like model version and temperature

### Keyboard Shortcuts in Cursor IDE

When using Claude with Cursor IDE, these shortcuts are helpful:

- `Ctrl+Shift+L` (Windows/Linux) or `Cmd+Shift+L` (macOS): Ask Claude a question
- `Ctrl+Enter` (Windows/Linux) or `Cmd+Enter` (macOS): Submit prompt to Claude
- `Ctrl+Shift+/` (Windows/Linux) or `Cmd+Shift+/` (macOS): Get code explanation
- `Ctrl+Shift+G` (Windows/Linux) or `Cmd+Shift+G` (macOS): Generate code

## Using Claude Code with Cursor

### Basic Commands

Once installed, you can use the following commands:

```bash
# Get help
claude --help

# Initialize a new project
claude init

# Ask a question about your code
claude "How do I optimize this function?"

# Generate code based on a description
claude "Create a React component for a navigation bar"
```

### Project Memory

Claude Code can maintain context about your project:

1. Initialize project memory:
   ```bash
   claude init
   ```
   This creates a `CLAUDE.md` file that stores important project information.

2. Update project memory:
   ```bash
   claude remember "The authentication system uses JWT tokens with a 24-hour expiry"
   ```

## MCP Server Integration

Claude Code supports Model Context Protocol (MCP) for advanced features:

### Managing MCP Servers

```bash
# List all configured MCP servers
claude mcp list

# Add a new MCP server
claude mcp add server-name /path/to/server

# Get details about a specific server
claude mcp get server-name

# Remove an MCP server
claude mcp remove server-name
```

### Common MCP Servers

Claude Code works with various MCP servers:

1. **Sequential Thinking MCP**
   ```bash
   claude mcp add sequential-thinking /path/to/sequential-thinking-mcp
   ```

2. **Database MCP**
   ```bash
   claude mcp add postgres-server /path/to/postgres-mcp --connection-string "postgresql://user:pass@localhost:5432/mydb"
   ```

3. **Browser Tools MCP**
   ```bash
   claude mcp add browser-tools /path/to/browser-tools-mcp
   ```

## Best Practices

1. Start with broad questions, then narrow down to specific coding tasks
2. Include error messages and context when troubleshooting
3. Use descriptive comments when asking for code generation
4. Store commonly used commands in your CLAUDE.md file
5. Use Claude Code for code reviews before submitting PRs

## Troubleshooting

### Common Issues

1. **API Key Issues**
   ```bash
   claude config reset api_key
   claude config set api_key YOUR_NEW_API_KEY
   ```

2. **MCP Server Connection Problems**
   ```bash
   claude mcp test server-name
   ```

3. **Reinstalling Claude Code**
   ```bash
   npm uninstall -g @anthropic-ai/claude-code
   npm install -g @anthropic-ai/claude-code
   ```

4. **Windows Environment Detection Issues**
   If Claude Code is detecting your WSL environment as Windows:
   ```bash
   npm config set os linux
   npm uninstall -g @anthropic-ai/claude-code
   npm install -g @anthropic-ai/claude-code
   ```

5. **WSL Installation Issues**
   - If `wsl --install` fails, try installing components individually:
     ```powershell
     # Enable WSL feature
     dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
     
     # Enable Virtual Machine Platform
     dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
     
     # Restart your computer, then install Ubuntu from Microsoft Store
     ```
   - For "WSL 2 requires an update to its kernel component" error:
     - Download and install the WSL2 Linux kernel update from [Microsoft's website](https://aka.ms/wsl2kernel)

## Resources

- [Claude Code GitHub Repository](https://github.com/anthropics/claude-code)
- [Anthropic Developer Portal](https://www.anthropic.com/developers)
- [Cursor IDE Documentation](https://cursor.sh/docs)
- [Model Context Protocol Specification](https://github.com/anthropics/model-context-protocol)
- [WSL Installation Guide](https://learn.microsoft.com/en-us/windows/wsl/install)