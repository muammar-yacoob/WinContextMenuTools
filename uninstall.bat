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

echo.
echo ********************************************
echo * MedLet - Registry Cleanup Tool           *
echo ********************************************
echo.
echo This tool will remove registry entries created by:
echo  - install png to ico.reg
echo  - install.reg
echo  - InstallVideoCompresser.reg
echo.
echo Press any key to continue or CTRL+C to cancel...
pause > nul

echo.
echo Removing registry entries...

:: Remove PNG to Icon registry entries (from install png to ico.reg)
echo Removing PNG to Icon converter entries...
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\ConvertToIcon" /f >nul 2>&1
if %errorlevel% equ 0 (
    echo - PNG to Icon entries removed successfully.
) else (
    echo - No PNG to Icon entries found or unable to remove.
)

:: Remove Remove Background registry entries (from install.reg)
echo Removing Background Remover entries...
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\RemoveBackground" /f >nul 2>&1
if %errorlevel% equ 0 (
    echo - Background Remover entries removed successfully.
) else (
    echo - No Background Remover entries found or unable to remove.
)

:: Remove Video Compressor registry entries (from InstallVideoCompresser.reg)
echo Removing Video Compressor entries...
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\shell\CompressVideo" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.webm\shell\CompressVideo" /f >nul 2>&1
if %errorlevel% equ 0 (
    echo - Video Compressor entries removed successfully.
) else (
    echo - No Video Compressor entries found or unable to remove.
)

echo.
echo Registry cleanup completed!
echo.
echo All registry entries from the specified .reg files have been removed.
echo.

pause
endlocal 