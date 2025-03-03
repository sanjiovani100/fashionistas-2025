# Supabase MCP Server: The Simple Guide

## What Is It?
Supabase MCP is a tool that lets AI assistants (like Claude) talk directly to your Supabase database. Think of it as a translator between AI and your database.

## Why Use It?
- **No Coding Needed**: AI can get data without you writing code
- **Save Time**: Quickly add, update, or find information
- **Works Safely**: Uses your existing Supabase security rules

## Getting Started in 3 Steps

1. **Start the Server**
   - Windows: Double-click `start-mcp-server.bat` or run `.\start-mcp-server.ps1`
   - Look for: "Server will be available at http://localhost:3000"

2. **Ask Questions**
   Examples:
   - "Show me all upcoming fashion events"
   - "Add a new designer named Sarah Jones"
   - "How many tickets have been sold for the Paris show?"

3. **That's It!** The AI will handle the database work for you

## Troubleshooting

**Server Won't Start?**
- Make sure you have Node.js installed
- Check that you're in the right folder

**Getting Errors?**
- Verify your Supabase project is online
- Check that your API key is correct

## Security Tips
- The AI can only do what your API key allows
- For best security, use your "anon/public" key, not your admin key 