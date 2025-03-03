# PowerShell Reference Script for Cursor AI
# This file demonstrates proper PowerShell syntax and command patterns

#region Command Chaining
# CORRECT: Use semicolons to chain commands
Write-Host "Starting first command"; Write-Host "Starting second command"

# INCORRECT: Do not use && or || (bash-style operators)
# Write-Host "First command" && Write-Host "Second command"  # WRONG!

# For conditional execution, use PowerShell operators
$success = $true
if ($success) { Write-Host "Command succeeded" } else { Write-Host "Command failed" }

# Or use the PowerShell logical operators
$firstCommand = $true
$firstCommand -and (Write-Host "This runs if first command is true")
$firstCommand -or (Write-Host "This runs if first command is false")
#endregion

#region Environment Variables
# Setting environment variables
$env:PORT = 5000

# Reading environment variables
Write-Host "The port is: $($env:PORT)"
#endregion

#region Running Applications
# Starting Next.js development server
npm run dev  # Basic execution

# Starting with specific port
$env:PORT = 5000; npm run dev

# Running npx commands
npx next dev -p 5000

# Starting a process and opening a browser
Start-Process "http://localhost:5000"
#endregion

#region File Operations
# Creating directories
New-Item -ItemType Directory -Path "./scripts" -Force

# Creating files
New-Item -ItemType File -Path "./config.json" -Force

# Writing to files
Set-Content -Path "./config.json" -Value '{"port": 5000}'

# Reading files
$config = Get-Content -Path "./config.json" | ConvertFrom-Json
Write-Host "Port from config: $($config.port)"
#endregion

#region Functions
# Define a function to start Next.js on a specific port
function Start-NextApp {
    param (
        [Parameter(Mandatory=$false)]
        [int]$Port = 3000
    )
    
    $env:PORT = $Port
    Write-Host "Starting Next.js on port $Port..." -ForegroundColor Green
    npm run dev
}

# Usage
# Start-NextApp -Port 5000
#endregion

#region Error Handling
# Try-Catch blocks for error handling
try {
    $result = 10 / 0  # This will cause an error
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
#endregion
