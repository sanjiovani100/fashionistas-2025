# PowerShell Commands for Web Development

## Introduction

This document provides a reference for common PowerShell commands used in web development projects, particularly when working with Node.js, Next.js, and other JavaScript frameworks in a Windows environment.

## Basic Navigation and File Operations

### Directory Navigation

```powershell
# Change to a specific directory
Set-Location -Path .\template-solar
# or the shorter alias
cd .\template-solar

# Go up one directory level
cd ..

# Return to previous directory
cd -

# Go to home directory
cd ~
```

### Listing Files and Directories

```powershell
# List all items in current directory
Get-ChildItem
# or the shorter alias
dir
# or
ls

# List with details
Get-ChildItem -Force

# List only directories
Get-ChildItem -Directory

# List only files
Get-ChildItem -File

# List with specific pattern
Get-ChildItem -Filter "*.js"
```

### File Operations

```powershell
# Create a new file
New-Item -Path "filename.txt" -ItemType "file"
# or
ni filename.txt -type file

# Create a new directory
New-Item -Path "directoryname" -ItemType "directory"
# or
mkdir directoryname

# Copy a file
Copy-Item -Path "source.txt" -Destination "destination.txt"
# or
cp source.txt destination.txt

# Move a file
Move-Item -Path "source.txt" -Destination "destination.txt"
# or
mv source.txt destination.txt

# Delete a file
Remove-Item -Path "filename.txt"
# or
del filename.txt
# or
rm filename.txt
```

## Running Web Development Commands

### Node.js and NPM Commands

```powershell
# Install dependencies
npm install

# Run a script from package.json
npm run dev

# Install a package
npm install package-name

# Install a package as a dev dependency
npm install package-name --save-dev
```

### Running Multiple Commands

In PowerShell, the equivalent of Unix's `&&` operator is `;` or `|` (pipe) depending on the context:

```powershell
# INCORRECT (Unix style)
cd template-solar && npm run dev

# CORRECT (PowerShell style)
cd .\template-solar; npm run dev

# Alternative approach
Set-Location -Path .\template-solar
npm run dev
```

### Running Commands in Specific Directories

```powershell
# Run a command in a specific directory without changing your current location
Push-Location -Path .\template-solar
npm run dev
Pop-Location

# One-liner version
Push-Location -Path .\template-solar; npm run dev; Pop-Location
```

## Git Commands in PowerShell

```powershell
# Clone a repository
git clone https://github.com/username/repo.git

# Check status
git status

# Add files
git add .

# Commit changes
git commit -m "Commit message"

# Push changes
git push origin main
```

## Environment Variables

```powershell
# Set an environment variable for the current session
$env:VARIABLE_NAME = "value"

# Access an environment variable
$env:VARIABLE_NAME

# List all environment variables
Get-ChildItem env:
```

## PowerShell-Specific Tips

### Command History

```powershell
# View command history
Get-History
# or
history

# Run a command from history by its ID
Invoke-History 3
```

### Finding Help

```powershell
# Get help for a command
Get-Help Get-ChildItem
# or
help Get-ChildItem

# Get detailed help with examples
Get-Help Get-ChildItem -Detailed
```

### Aliases

PowerShell has many aliases to make the transition from other shells easier:

```powershell
# Common aliases
cd    -> Set-Location
ls    -> Get-ChildItem
dir   -> Get-ChildItem
rm    -> Remove-Item
cp    -> Copy-Item
mv    -> Move-Item
echo  -> Write-Output
```

## Best Practices

1. **Use proper PowerShell syntax**: Avoid using Unix-style commands and operators.
2. **Use tab completion**: PowerShell has excellent tab completion for commands and paths.
3. **Use proper quotes**: PowerShell uses both single and double quotes, but they behave differently.
4. **Use proper path separators**: Use backslashes (`\`) for paths, or use forward slashes (`/`) which PowerShell also understands.
5. **Use proper parameter syntax**: Use `-ParameterName Value` format for parameters.
6. **Use proper error handling**: Use `try/catch` blocks for error handling.
7. **Use proper pipeline syntax**: PowerShell is built around the concept of pipelines.

## Common Issues and Solutions

### Path Issues

If you encounter path issues, remember that PowerShell paths:
- Use backslashes (`\`) by default
- Can use forward slashes (`/`) in most contexts
- Should be quoted if they contain spaces
- Can use relative paths (`.\` for current directory, `..\` for parent)

### Permission Issues

If you encounter permission issues:
- Run PowerShell as Administrator for operations requiring elevated privileges
- Check execution policy with `Get-ExecutionPolicy`
- Set execution policy with `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned`

### Node.js and NPM Issues

If npm commands fail:
- Ensure Node.js is installed and in your PATH
- Check npm cache with `npm cache verify`
- Try clearing npm cache with `npm cache clean --force` 