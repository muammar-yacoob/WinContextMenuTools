@echo off
setlocal enabledelayedexpansion

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires Administrator privileges.
    echo Please run this script as an Administrator.
    pause
    exit /b 1
)

:: Save current directory path
set "current_dir=%~dp0"

:: Set installation directory
set "install_dir=%ProgramFiles%\removebg"

:: Download and install removebg CLI
echo Downloading remove.bg CLI...
powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/remove-bg/remove-bg-cli/releases/download/2.1.0/removebg_cli_v2.1.0_windows.zip' -OutFile 'removebg_cli.zip'}"
if %errorlevel% neq 0 (
    echo Error: Failed to download remove.bg CLI.
    pause
    exit /b 1
)

:: Create target directory for removebg CLI
if not exist "%install_dir%" mkdir "%install_dir%"

:: Extract the CLI
echo Extracting remove.bg CLI...
powershell -Command "& {Expand-Archive -Path 'removebg_cli.zip' -DestinationPath '%install_dir%' -Force}"
if %errorlevel% neq 0 (
    echo Error: Failed to extract removebg CLI.
    pause
    exit /b 1
)

:: Add removebg to PATH
echo Adding removebg to PATH...
setx PATH "%PATH%;%install_dir%" /M

:: Create Registry Entries using relative path
echo Importing registry entries...
reg import "%current_dir%src\install.reg"
if %errorlevel% neq 0 (
    echo Error: Failed to import registry entries.
    pause
    exit /b 1
)

:: Check if apikey.txt exists in the relative src directory
if not exist "%current_dir%src\apikey.txt" (
    echo Please create an apikey.txt file in %current_dir%src\ containing your remove.bg API key.
    pause
    exit /b 1
)

echo Remove.bg CLI installed and context menu added!
pause

:: Clean up
del removebg_cli.zip

endlocal