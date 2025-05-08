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
set "icons_dir=%INSTALL_DIR%\res\icons"

:: Create directories if needed
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%piclet_dir%" mkdir "%piclet_dir%"
if not exist "%piclet_dir%\src" mkdir "%piclet_dir%\src"
if not exist "%libs_dir%" mkdir "%libs_dir%"
if not exist "%icons_dir%" mkdir "%icons_dir%"

:: Copy files to installation directory
echo Copying files to %INSTALL_DIR%...
xcopy /y /i "%current_dir%src\*.bat" "%piclet_dir%\src\"
xcopy /y /i "%current_dir%install_piclet.reg" "%piclet_dir%\"

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

:: Copy icons to the central location
if exist "%current_dir%src\icon.ico" (
    copy "%current_dir%src\icon.ico" "%icons_dir%\"
)
if exist "%current_dir%src\removebg.ico" (
    copy "%current_dir%src\removebg.ico" "%icons_dir%\"
)
if exist "%current_dir%src\resize.ico" (
    copy "%current_dir%src\resize.ico" "%icons_dir%\"
)
if exist "%current_dir%src\piclet.ico" (
    copy "%current_dir%src\piclet.ico" "%icons_dir%\"
)

:: Create temporary registry file with proper paths
echo Creating registry entries...
set "temp_reg=%TEMP%\piclet_install.reg"
type "%current_dir%install_piclet.reg" > "%temp_reg%"

:: Replace hardcoded paths with actual path
set "escaped_path=%INSTALL_DIR:\=\\%"
powershell -Command "(Get-Content '%temp_reg%') -replace 'D:\\\\WinContextMenu', '%escaped_path%' | Set-Content '%temp_reg%'"

:: Import the registry file
echo Installing context menu integration...
reg import "%temp_reg%"
if %errorlevel% neq 0 (
    echo Error: Failed to import registry entries.
    pause
    exit /b 1
)

:: Clean up temporary file
del "%temp_reg%" 2>nul

echo.
echo Piclet has been successfully installed to %INSTALL_DIR%!
echo.
echo You can now right-click on:
echo  - PNG files: Convert to Icon, Remove Background, or Resize
echo  - JPG files: Resize
echo.
echo You may need to restart Windows Explorer for changes to take effect.
pause
endlocal 