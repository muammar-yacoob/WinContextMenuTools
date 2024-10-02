# Get the directory of the script
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Read the API key from apikey.txt
$apiKeyPath = Join-Path $scriptPath "apikey.txt"
if (Test-Path $apiKeyPath) {
    $REMOVE_BG_API_KEY = Get-Content $apiKeyPath -Raw
    $REMOVE_BG_API_KEY = $REMOVE_BG_API_KEY.Trim()
} else {
    Write-Host "apikey.txt not found in the script directory."
    Write-Host "Current directory: $scriptPath"
    Pause
    exit 1
}

# Check if the API key exists
if ([string]::IsNullOrWhiteSpace($REMOVE_BG_API_KEY)) {
    Write-Host "API key not found or empty in apikey.txt!"
    Pause
    exit 1
}

# Check if removebg is in PATH
if (!(Get-Command "removebg" -ErrorAction SilentlyContinue)) {
    Write-Host "removebg command not found. Make sure it's installed and in your PATH."
    Write-Host "Current PATH: $env:PATH"
    Pause
    exit 1
}

# Get the input file path
$inputFile = $args[0]

# Run remove.bg CLI with the selected file
Write-Host "Attempting to remove background from: $inputFile"
try {
    & removebg --api-key $REMOVE_BG_API_KEY $inputFile
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Background removed successfully for file: $inputFile"
    } else {
        Write-Host "Failed to remove background for file: $inputFile"
        Write-Host "Error code: $LASTEXITCODE"
    }
} catch {
    Write-Host "An error occurred while running removebg:"
    Write-Host $_.Exception.Message
}

Pause