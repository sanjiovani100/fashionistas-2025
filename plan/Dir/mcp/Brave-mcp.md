# Setting Up Brave Search MCP Server in Cursor IDE

This guide provides step-by-step instructions for setting up the Brave Search MCP server in Cursor IDE on Windows, following best practices.

## Prerequisites

- Node.js installed on your system
- Cursor IDE installed and running
- Brave Search API key: `BSAgtaYs86On2QBfN3hWx5y0PJyIMjC`

## Step 1: Install the Brave Search MCP Server Package Globally

Open a terminal (Command Prompt or PowerShell) and run the following command:

```bash
npm install -g @modelcontextprotocol/server-brave-search
```

This will install the package globally, making it accessible from any location on your system.

## Step 2: Configure the API Key

There are two methods to configure your Brave Search API key:

### Method 1: Edit the index.js File (Direct Approach)

1. Locate the index.js file at:
   ```
   C:/Users/[YourUsername]/AppData/Roaming/npm/node_modules/@modelcontextprotocol/server-brave-search/dist/index.js
   ```
   Replace `[YourUsername]` with your Windows username (e.g., `sanji`).

2. Open the file in a text editor and add the following line at the very beginning of the file:
   ```javascript
   process.env.BRAVE_API_KEY = 'BSAgtaYs86On2QBfN3hWx5y0PJyIMjC';
   ```

3. Save the file.

### Method 2: Create a Batch Script (Recommended for Maintainability)

1. Create a new file named `brave-search-mcp.bat` in a location of your choice (e.g., `C:/Scripts/`).

2. Add the following content to the file:
   ```batch
   @echo off
   set BRAVE_API_KEY=BSAgtaYs86On2QBfN3hWx5y0PJyIMjC
   node C:/Users/[YourUsername]/AppData/Roaming/npm/node_modules/@modelcontextprotocol/server-brave-search/dist/index.js
   ```
   Replace `[YourUsername]` with your Windows username (e.g., `sanji`).

3. Save the file.

## Step 3: Configure the MCP Server in Cursor IDE

1. Open Cursor IDE.

2. Navigate to `Settings` > `Features` > `MCP Servers`.

3. Click "Add New MCP Server" and provide the following details:
   - **Name**: Brave Search
   - **Type**: command
   - **Command**: 
     
     If using Method 1 (direct approach):
     ```
     cmd /c node C:/Users/sanji/AppData/Roaming/npm/node_modules/@modelcontextprotocol/server-brave-search/dist/index.js
     ```

     If using Method 2 (batch script):
     ```
     cmd /c C:/path/to/brave-search-mcp.bat
     ```
     Replace `C:/path/to/` with the actual path where you saved the batch file.

## Step 4: Verify the Setup

1. Save the MCP server configuration in Cursor.

2. Restart Cursor IDE to ensure the changes take effect.

3. Check if the Brave Search tool is available in your AI assistant's toolset.

## Troubleshooting

- **Flashing Terminal Window**: If you see a terminal window flash and close immediately, it indicates the server is crashing. Check that:
  - The API key is correctly set
  - The path to the index.js file is correct
  - Node.js is properly installed

- **"No Tools Found" Error**: If Cursor reports that no tools are found:
  - Ensure the server is running correctly
  - Check that the command path has forward slashes (/) instead of backslashes (\)
  - Verify there are no spaces in the path

- **API Key Issues**: If searches fail despite the server running:
  - Confirm the API key is correctly set
  - Check for any typos in the API key
  - Ensure the API key is active and has the necessary permissions

## Notes

- The Brave Search MCP server allows your Cursor AI assistant to perform web searches using the Brave Search API.
- Keep your API key secure and do not share it publicly.
- Using `cmd /c` may leave a command window open while the server is running. This is normal behavior on Windows.

For more general information about setting up MCP servers in Cursor IDE on Windows, refer to the [mcp-settings.md](./mcp-settings.md) file.