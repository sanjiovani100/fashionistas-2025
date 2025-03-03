# Claude Code Setup Guide

Claude Code is an agentic coding tool from Anthropic that lives in your terminal, understands your codebase, and helps you code faster through natural language commands.

## Installation

### Prerequisites

- **Operating Systems**: macOS 10.15+, Ubuntu 20.04+/Debian 10+, or Windows via WSL
- **Hardware**: 4GB RAM minimum
- **Software**:  
   - Node.js 18+  
   - git 2.23+ (optional)  
   - GitHub or GitLab CLI for PR workflows (optional)  
   - ripgrep (rg) for enhanced file search (optional)
- **Network**: Internet connection required for authentication and AI processing

### Installation Steps

1. Install Claude Code using npm:

```bash
npm install -g @anthropic-ai/claude-code
```

2. Navigate to your project:

```bash
cd your-project-directory
```

3. Start Claude Code:

```bash
claude
```

4. Complete authentication:
   - Follow the one-time OAuth process with your Console account
   - You'll need active billing at console.anthropic.com

## Basic Usage

Start Claude Code in your project directory:

```bash
cd /path/to/your/project
claude
```

### Common Commands

- Get an overview of your codebase:
  ```
  > give me an overview of this codebase
  ```

- Find specific files:
  ```
  > find the files that handle user authentication
  ```

- Fix errors:
  ```
  > I'm seeing this error: [error message]. How can I fix it?
  ```

- Generate code:
  ```
  > create a function that [description]
  ```

- Working with git:
  ```
  > create a PR for the changes I've made
  ```

## Setting Up MCP (Model Context Protocol)

Claude Code can be enhanced with MCP servers that provide specialized capabilities.

### Configure MCP Servers

```bash
# Basic syntax
claude mcp add <name> <command> [args...]

# Example: Adding a local server
claude mcp add my-server -e API_KEY=123 -- /path/to/server arg1 arg2
```

### Manage MCP Servers

```bash
# List all configured servers
claude mcp list

# Get details for a specific server
claude mcp get my-server

# Remove a server
claude mcp remove my-server
```

### Example: Connect to a Postgres Database

```bash
claude mcp add postgres-server /path/to/postgres-mcp-server --connection-string "postgresql://user:pass@localhost:5432/mydb"
```

## Creating Project Memory

You can set up a CLAUDE.md file to store important project information:

```bash
claude
> /init
```

This will create a CLAUDE.md file that Claude Code automatically reads when running in your project.

## Best Practices

1. Start with broad questions, then narrow down to specific areas
2. Use domain language from your project when asking questions
3. Include screenshots or error messages when troubleshooting
4. Store commonly used commands in your CLAUDE.md file
5. Use Claude Code for code reviews before submitting PRs

## Data Privacy and Security

- Anthropic collects feedback and usage data but does not train generative models on your code
- User feedback transcripts are stored for only 30 days
- Consider data privacy when sharing sensitive code with Claude Code

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
- [GitHub Repository](https://github.com/anthropics/claude-code)
- [Anthropic Developer Portal](https://www.anthropic.com/developers) 