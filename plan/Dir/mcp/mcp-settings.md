# Setting Up Model Context Protocol (MCP) Servers in Cursor IDE on Windows

Setting up Model Context Protocol (MCP) servers within Cursor IDE on Windows can present challenges, but following these steps can help ensure a smooth integration:

## 1. Install Necessary Packages Globally

- **Node.js**: Ensure you have Node.js installed. You can download it from the [official website](https://nodejs.org/).
- **MCP Server Packages**: Install the required MCP server packages globally using npm. For example:
  ```bash
  npm install -g @modelcontextprotocol/server-sequential-thinking
  npm install -g @modelcontextprotocol/server-brave-search
  ```
  Global installation helps avoid pathing issues during execution.

## 2. Configure MCP Servers in Cursor IDE

- **Access MCP Settings**: Open Cursor IDE, navigate to `Settings` > `Features` > `MCP Servers`.
- **Add New MCP Server**: Click "Add New MCP Server" and provide the following details:
  - **Name**: Descriptive name for the server (e.g., "Sequential Thinking Server").
  - **Type**: Select "command".
  - **Command**: Use the following format to ensure compatibility on Windows:
    ```bash
    cmd /c node C:/Users/[YourUsername]/AppData/Roaming/npm/node_modules/@modelcontextprotocol/server-sequential-thinking/dist/index.js
    ```
    Replace `[YourUsername]` with your actual Windows username.
- **Important Notes**:
  - **Use Forward Slashes**: In paths, use forward slashes (`/`) instead of backslashes (`\`) to avoid escape character issues.
  - **Avoid Spaces in Paths**: Ensure that the installation paths do not contain spaces, as they can cause execution problems. For instance, avoid paths like `C:/My Projects/` and prefer `C:/Projects/`.
  - **No Quotes Around Paths**: Do not enclose paths in quotes.

## 3. Handling Environment Variables

- If the MCP server requires environment variables (e.g., API keys), it's advisable to create a startup script that sets these variables before launching the server.
- **Example (Batch Script for Windows)**:
  ```batch
  @echo off
  set BRAVE_API_KEY=your_api_key_here
  node C:/Users/[YourUsername]/AppData/Roaming/npm/node_modules/@modelcontextprotocol/server-brave-search/dist/index.js
  ```
- Save this script with a `.bat` extension and configure Cursor to execute this script for the corresponding MCP server.

## 4. Verify Node.js Installation Path

- Ensure that Cursor IDE recognizes the correct path to `node.exe`. You can verify the path by running:
  ```bash
  where node
  ```
- If you have multiple versions of Node.js or are using a version manager like `nvm`, ensure that the path points to the correct version.

## 5. Common Issues and Troubleshooting

- **Flashing Terminal Windows**: If a terminal window flashes and closes immediately upon starting an MCP server, it indicates a crash. Check for missing environment variables or incorrect paths.
- **Persistent Terminal Windows**: Using `cmd /c` may leave an external command window open. This behavior is due to how Windows handles command execution. While it ensures the server runs correctly, the open window is a side effect.
- **"No Tools Found" Error**: This can occur if the MCP server isn't running correctly or if Cursor cannot communicate with it. Ensure the server command is correct, all necessary packages are installed, and there are no path issues.

By adhering to these guidelines, you can effectively set up and manage MCP servers within Cursor IDE on a Windows system, enhancing your development workflow with integrated AI capabilities.

> **Note**: For additional settings and configuration notes, see the [MCP-settings-notes](./MCP-settings-notes) file. 