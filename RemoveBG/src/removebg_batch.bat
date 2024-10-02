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

:: Get the directory of the batch file
set "script_dir=%~dp0"

:: Read the API key from apikey.txt using a relative path
if exist "%script_dir%apikey.txt" (
    set /p REMOVE_BG_API_KEY=<"%script_dir%apikey.txt"
) else (
    echo apikey.txt not found in the script directory.
    echo Current directory: %script_dir%
    pause
    exit /b 1
)

:: Check if the API key exists
if "!REMOVE_BG_API_KEY!"=="" (
    echo API key not found or empty in apikey.txt!
    pause
    exit /b 1
)

:: Check if removebg is in PATH
where removebg >nul 2>&1
if %errorlevel% neq 0 (
    echo removebg command not found. Make sure it's installed and in your PATH.
    echo Current PATH: %PATH%
    pause
    exit /b 1
)

:: Run remove.bg CLI with the selected file
echo Attempting to remove background from: %~1
removebg --api-key "!REMOVE_BG_API_KEY!" "%~1"

:: Show message if successful or failed
if %errorlevel%==0 (
    echo Background removed successfully for file: %~1
) else (
    echo Failed to remove background for file: %~1
    echo Error code: %errorlevel%
)

pause
endlocal