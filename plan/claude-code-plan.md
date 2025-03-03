# Beginner's Guide: Using Claude Code in WSL

This guide provides simple, step-by-step instructions for complete beginners to use Claude Code in the Windows Subsystem for Linux (WSL).

## Opening WSL Terminal

1. **Click on the Start Menu** in the bottom-left corner of your screen
   
   ![Start Menu](https://i.imgur.com/example-start.png)

2. **Type "Ubuntu"** in the search bar

3. **Click on the Ubuntu app** that appears in the search results
   
   ![Ubuntu App](https://i.imgur.com/example-ubuntu.png)

4. **Wait for the terminal to open** - you'll see a black window with text

## Basic Claude Code Commands

### Asking Questions

1. **Type the following command** (replace "your question" with what you want to ask):
   ```bash
   claude "your question"
   ```

2. **Examples:**
   ```bash
   claude "How do I create a function in JavaScript?"
   ```
   ```bash
   claude "What's the difference between let and const in JavaScript?"
   ```

3. **Press Enter** to send your question

4. **Wait for Claude** to think and respond with an answer

### Generating Code

1. **Type a command asking for code:**
   ```bash
   claude "Write code to create a button in HTML that changes color when clicked"
   ```

2. **Press Enter** and wait for Claude to generate the code

3. **Copy the code** Claude provides by:
   - Clicking and dragging to select the code
   - Right-clicking and selecting "Copy"
   - Or pressing Ctrl+Shift+C (WSL terminal uses different shortcuts than regular Windows)

4. **Paste the code** into your project file

### Getting Help with Your Existing Code

1. **Navigate to your project folder:**
   ```bash
   cd /mnt/c/Users/YourUsername/your-project-folder
   ```
   - Replace "YourUsername" with your actual Windows username
   - Replace "your-project-folder" with your actual project folder name

2. **Ask about your code:**
   ```bash
   claude "What does the code in index.js do?"
   ```
   ```bash
   claude "How can I improve this function in app.js?"
   ```

3. **Ask for specific file help:**
   ```bash
   claude "Help me understand the function on line 25 of app.js"
   ```

## Creating Project Memory

Claude Code can remember information about your project, making future questions more relevant.

1. **Initialize project memory** (do this once per project):
   ```bash
   claude init
   ```
   This creates a CLAUDE.md file that stores important project information.

2. **Add information about your project:**
   ```bash
   claude remember "This is a React website for a coffee shop"
   ```
   ```bash
   claude remember "The database is MongoDB and authentication uses JWT"
   ```

3. **View what Claude remembers:**
   ```bash
   cat CLAUDE.md
   ```

## Tips for Beginners

1. **If you get stuck,** ask for help:
   ```bash
   claude "I'm stuck with this error message: [paste error message]"
   ```

2. **For longer code samples,** ask Claude to break it down:
   ```bash
   claude "Can you explain this code step by step?"
   ```

3. **If you don't understand something,** ask for simpler explanations:
   ```bash
   claude "Can you explain that in simpler terms?"
   ```

4. **Create a shortcut** for easier access:
   ```bash
   echo 'alias cc="claude"' >> ~/.bashrc
   source ~/.bashrc
   ```
   After creating this shortcut, you can type `cc` instead of `claude`:
   ```bash
   cc "How do I create a function in Python?"
   ```

## Troubleshooting

1. **If Claude Code isn't working,** make sure it's installed:
   ```bash
   claude --version
   ```

2. **If you see "command not found",** try reinstalling:
   ```bash
   sudo npm install -g @anthropic-ai/claude-code
   ```

3. **If you see API key errors,** set your API key:
   ```bash
   claude config set api_key YOUR_API_KEY
   ```
   (Replace YOUR_API_KEY with your actual Anthropic API key)

Remember, Claude Code is a tool that gets better with practice. Don't hesitate to ask questions and explore its capabilities!
