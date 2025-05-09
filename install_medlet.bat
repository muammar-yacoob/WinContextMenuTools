@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo MedLet - Media Tools for Windows
echo ===========================================
echo.

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires Administrator privileges.
    echo Please run this script as an Administrator.
    pause
    exit /b 1
)

:: Get current directory
set "current_dir=%~dp0"

:: Install Piclet
echo Installing Piclet (image tools)...
cd /d "%current_dir%Piclet"
call install_piclet.bat
cd /d "%current_dir%"

:: Install VidLet
echo Installing VidLet (video tools)...
cd /d "%current_dir%VidLet"
call install_vidlet.bat
cd /d "%current_dir%"

echo.
echo ===========================================
echo MedLet installation complete!
echo ===========================================
echo.
echo You may need to restart Windows Explorer for all changes to take effect.
echo.
pause
endlocal 