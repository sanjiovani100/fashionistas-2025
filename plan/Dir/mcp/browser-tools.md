# MCP Browser Tools: Installation & Usage Guide

Browser Tools MCP enables your AI assistant (Claude) to interact with your web browser, providing it with the ability to see console logs, network activity, and take screenshots of your browser.

## Repository
- **GitHub**: https://github.com/AgentDeskAI/browser-tools-mcp
- **Documentation**: https://browsertools.agentdesk.ai/installation

## Installation Guide

### Prerequisites
- NodeJS installed on your machine
- Google Chrome or a Chromium-based Browser
- MCP-compatible client (Cursor, Windsurf, Claude Desktop, etc.)

### Step 1: Install Browser Tools
Run these commands in your terminal to install both packages globally:

```bash
npm i -g @agentdeskai/browser-tools-mcp
npm i -g @agentdeskai/browser-tools-server
```

### Step 2: Download and Install the Chrome Extension
1. Download the Chrome extension from the official website or GitHub repository
2. Open Chrome's "Manage Extensions" window
3. Enable "Developer Mode"
4. Click "Load unpacked" 
5. Navigate to the downloaded extension folder and select it

### Step 3: Configure MCP Server in Cursor

#### For Windows Users
Due to compatibility issues with Windows, use this specific command:

```
node C:\Users\[Your_Username]\AppData\Roaming\npm\node_modules\@agentdeskai\browser-tools-mcp\dist\mcp-server.js
```

Replace `[Your_Username]` with your Windows username. You can find your username by running:
```
npm config get prefix
```
and looking at the path.

#### For Mac/Linux Users
Use the standard command:

```
npx @agentdeskai/browser-tools-mcp
```

### Step 4: Setup in Cursor
1. Open Cursor Settings
2. Go to Features → MCP Servers
3. Click "Add new MCP server"
4. Configure as follows:
   - Name: browser-tools
   - Type: command
   - Command: Use the appropriate command based on your OS (from Step 3)
5. Wait for the connection to show as active (green circle)

### Step 5: Run the Browser Tools Server
Open a new terminal and run:

```
npx @agentdeskai/browser-tools-server
```
Keep this terminal window open while using Browser Tools.

## Usage

### Opening Browser Developer Tools
Right-click on any web page and select "Inspect" to open Chrome's developer tools. Once open, logs will be accessible to the MCP client.

### Available Browser Tools Capabilities

#### Analyzing Logs for Debugging & Validation
Browser Tools MCP provides access to various logging capabilities to help with debugging:

* **Get Console Logs:** Returns the most recent console logs from the browser
* **Get Console Errors:** Returns the most recent error messages from the console
* **Get Network Success Logs:** Returns all recent XHR requests with HTTP success response codes (200, 300)
* **Get Network Error Logs:** Returns all recent XHR requests that returned error response codes (400, 500)
* **Wipe Logs:** Clears all logs stored on the server for a fresh debugging session

Simply ask Claude: "Can you check console and network logs to see what went wrong?" and it will automatically use these tools to analyze your browser state.

#### Updating & Debugging UI Components

* **Take Screenshot:** Captures the current browser view and saves it to your specified directory
  - By default, screenshots are saved to: `/user/Downloads/mcp-screenshots`
  - You can set a custom path in the BrowserTools DevTools panel
  - Ask Claude: "Can you take a screenshot of what I'm seeing?"

* **Get Selected Element:** Returns information about the currently selected DOM element
  - Use Chrome DevTools Element Selector tool to select a UI component
  - Then ask Claude: "Can you help me edit this element to fix the alignment?"
  - This feature makes traversing through a codebase and making UI changes much easier

### What Claude Can Access
- **Console Logs**: Debug messages and errors
- **Network Activity**: HTTP requests and responses
- **DOM Elements**: HTML structure and content
- **Screenshots**: Visual capture of the browser window

### Common Commands to Ask Claude
- "Can you check console and network logs to see what went wrong?"
- "Take a screenshot of the current page"
- "What errors are showing in the console?"
- "Check the network activity for failed requests"
- "Can you edit the currently selected element to [specific change]?"
- "Are there any 404 errors in the network logs?"
- "Wipe the logs so we can start fresh"

## Troubleshooting

### Common Issues
- **Command Not Working**: For Windows users, make sure to use the node path command instead of npx
- **Screenshots Not Working**: Use version 1.0.11 or later (`@agentdeskai/browser-tools-mcp@1.0.11`)
- **MCP Connection Issues**: Refresh or restart Cursor if the MCP server doesn't connect
- **No Logs Appearing**: Make sure Chrome DevTools is open in the tab you want to monitor

### Finding Screenshots
Screenshots are saved to your Downloads folder in an "mcp-screenshots" directory by default. You can change this path in the BrowserTools panel in Chrome DevTools.

## Note for Windows Users
When using the Windows setup with the node command, a command prompt window will open automatically whenever Cursor starts. This is normal and required for the MCP server to function correctly. 