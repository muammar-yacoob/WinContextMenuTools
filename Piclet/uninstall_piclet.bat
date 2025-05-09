@echo off
setlocal enabledelayedexpansion

echo Piclet Image Tools - Uninstallation

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires Administrator privileges.
    echo Please run this script as an Administrator.
    pause
    exit /b 1
)

:: Set installation paths
set "INSTALL_DIR=%ProgramFiles%\MedLet"
set "current_dir=%~dp0"
set "piclet_dir=%INSTALL_DIR%\Piclet"

echo Removing registry entries...

:: Create temporary registry file with proper paths
set "temp_reg=%TEMP%\piclet_uninstall.reg"
type "%current_dir%installation\uninstall_piclet.reg" > "%temp_reg%"

:: Import the registry file to remove entries
reg import "%temp_reg%"
if %errorlevel% neq 0 (
    echo Error: Failed to remove registry entries.
    pause
    exit /b 1
)

:: Clean up temporary file
del "%temp_reg%" 2>nul

echo.
echo Registry entries removed successfully.

:: Ask if user wants to remove installed files
echo.
choice /c YN /m "Do you want to remove Piclet files from %piclet_dir%"
if %errorlevel% equ 1 (
    echo.
    echo Removing Piclet files...
    if exist "%piclet_dir%" (
        rmdir /s /q "%piclet_dir%"
        echo Piclet files removed.
    ) else (
        echo No Piclet files found at %piclet_dir%.
    )
)

echo.
echo Piclet has been uninstalled.
echo.
echo You may need to restart Windows Explorer for changes to take effect.
pause
endlocal 