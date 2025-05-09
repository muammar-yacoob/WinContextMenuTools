@echo off
setlocal enabledelayedexpansion

echo ===========================================
echo MedLet - Uninstallation
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

echo Removing registry entries...
echo.

:: Registry keys to remove
echo Removing Piclet entries...
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletConvertToIcon" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletRemoveBackground" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletResizeImage" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\Shell\PicletResizeImage" /f >nul 2>&1

echo Removing VidLet entries...
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\shell\CompressVideo" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.webm\shell\CompressVideo" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\shell\ConvertToMP4" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\shell\VidLetMenu" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\shell\VidLetMenu" /f >nul 2>&1

echo.
echo Uninstallation completed!
echo.
echo MedLet registry entries have been removed.
echo You may need to restart Windows Explorer for changes to take effect.
echo.
echo Note: To completely remove MedLet, you may want to delete the installation folder:
echo %ProgramFiles%\MedLet
echo.

pause
endlocal 