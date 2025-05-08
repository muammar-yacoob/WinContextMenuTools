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

:: Installation paths
set "INSTALL_DIR=%ProgramFiles%\MedLet"
set "current_dir=%~dp0"
set "libs_dir=%INSTALL_DIR%\libs"
set "icons_dir=%INSTALL_DIR%\res\icons"

echo Setting up resources...
echo.

:: Create necessary directories
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%libs_dir%" mkdir "%libs_dir%"
if not exist "%libs_dir%\FFmpeg\bin" mkdir "%libs_dir%\FFmpeg\bin"
if not exist "%icons_dir%" mkdir "%icons_dir%"
if not exist "%INSTALL_DIR%\res\imgs" mkdir "%INSTALL_DIR%\res\imgs"

:: Check if we have icons, if not, generate them
if not exist "%icons_dir%\piclet.ico" (
    echo Creating icons...
    call "%current_dir%generate_logos.bat" "%INSTALL_DIR%"
)

:: Now install components
echo ===========================================
echo Installing MedLet components...
echo ===========================================
echo.

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
echo Right-click on media files to access MedLet tools:
echo  - PNG/JPG files: Piclet menu
echo  - MP4/MKV files: VidLet menu
echo.
echo You may need to restart Windows Explorer for all changes to take effect.
echo.
pause
endlocal 