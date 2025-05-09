@echo off
setlocal enabledelayedexpansion

echo Piclet Image Tools - Installation

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
set "libs_dir=%INSTALL_DIR%\libs"
set "icons_dir=%piclet_dir%\src\icons"

:: Create directories if needed
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%piclet_dir%" mkdir "%piclet_dir%"
if not exist "%piclet_dir%\src" mkdir "%piclet_dir%\src"
if not exist "%piclet_dir%\src\icons" mkdir "%piclet_dir%\src\icons"
if not exist "%libs_dir%" mkdir "%libs_dir%"

:: Copy files to installation directory
echo Copying files to %INSTALL_DIR%...
xcopy /y /i "%current_dir%src\*.bat" "%piclet_dir%\src\"
xcopy /y /i "%current_dir%src\*.html" "%piclet_dir%\src\"
xcopy /y /i "%current_dir%installation\*.reg" "%piclet_dir%\"

:: Check if we need to extract ImageMagick components
if not exist "%libs_dir%\magick.exe" (
    echo Checking for ImageMagick executable...
    
    :: Try to locate installed ImageMagick
    if exist "%ProgramFiles%\ImageMagick-7.1.1-Q16-HDRI\magick.exe" (
        echo Found ImageMagick installation, copying necessary files...
        copy "%ProgramFiles%\ImageMagick-7.1.1-Q16-HDRI\magick.exe" "%libs_dir%\"
    ) else if exist "%current_dir%libs\magick.exe" (
        echo Found local ImageMagick executable, copying to installation...
        copy "%current_dir%libs\magick.exe" "%libs_dir%\"
    ) else (
        echo ImageMagick not found. Please download portable ImageMagick and extract to:
        echo %libs_dir%
        echo.
        choice /c YN /m "Open ImageMagick download page now?"
        if %errorlevel% equ 1 start https://imagemagick.org/script/download.php
        pause
        exit /b 1
    )
)

:: Copy icons to the Piclet src icons folder
echo Copying icons...
if exist "%current_dir%src\icons\piclet.ico" (
    copy "%current_dir%src\icons\piclet.ico" "%icons_dir%\"
)
if exist "%current_dir%src\icons\removebg.ico" (
    copy "%current_dir%src\icons\removebg.ico" "%icons_dir%\"
)
if exist "%current_dir%src\icons\resize.ico" (
    copy "%current_dir%src\icons\resize.ico" "%icons_dir%\"
)
if exist "%current_dir%src\icons\png2icon.ico" (
    copy "%current_dir%src\icons\png2icon.ico" "%icons_dir%\"
)

:: Import the registry file directly
echo Installing context menu integration...
reg import "%current_dir%installation\install_piclet.reg"
if %errorlevel% neq 0 (
    echo Error: Failed to import registry entries.
    pause
    exit /b 1
)

:: Restart Windows Explorer to refresh context menus
echo Refreshing Windows Explorer to apply changes...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo Piclet has been successfully installed to %INSTALL_DIR%!
echo.
echo You can now right-click on:
echo  - PNG files: Convert to Icon, Remove Background, or Resize
echo  - JPG files: Resize
echo.
echo If the context menu doesn't appear, right-click on a PNG file and select "Piclet Diagnostic"
echo to run the diagnostic tool.
pause
endlocal 