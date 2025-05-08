@echo off
setlocal enabledelayedexpansion

echo VidLet Video Tools - Installation

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
set "vidlet_dir=%INSTALL_DIR%\VidLet"
set "libs_dir=%INSTALL_DIR%\libs"
set "ffmpeg_dir=%libs_dir%\FFmpeg"
set "ffmpeg_bin=%ffmpeg_dir%\bin"
set "icons_dir=%INSTALL_DIR%\res\icons"

:: Create directories if needed
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%vidlet_dir%" mkdir "%vidlet_dir%"
if not exist "%vidlet_dir%\src" mkdir "%vidlet_dir%\src"
if not exist "%vidlet_dir%\src\mkv2mp4" mkdir "%vidlet_dir%\src\mkv2mp4"
if not exist "%ffmpeg_bin%" mkdir "%ffmpeg_bin%"
if not exist "%icons_dir%" mkdir "%icons_dir%"

:: Copy files to installation directory
echo Copying files to %INSTALL_DIR%...
xcopy /y /i "%current_dir%src\*.bat" "%vidlet_dir%\src\"
xcopy /y /i "%current_dir%src\mkv2mp4\*.bat" "%vidlet_dir%\src\mkv2mp4\"
xcopy /y /i "%current_dir%install_vidlet.reg" "%vidlet_dir%\"

:: Check if we need to extract FFmpeg components
if not exist "%ffmpeg_bin%\ffmpeg.exe" (
    echo Checking for FFmpeg installation to copy required files...
    
    :: Try to locate installed FFmpeg
    if exist "%ProgramFiles%\FFmpeg\bin\ffmpeg.exe" (
        echo Found FFmpeg installation, copying necessary files...
        copy "%ProgramFiles%\FFmpeg\bin\ffmpeg.exe" "%ffmpeg_bin%\"
        copy "%ProgramFiles%\FFmpeg\bin\*.dll" "%ffmpeg_bin%\"
    ) else (
        echo FFmpeg not found. Please download portable FFmpeg and extract to:
        echo %ffmpeg_dir%
        echo.
        echo Alternatively, install FFmpeg through K-Lite Codec Pack:
        echo https://codecguide.com/download_k-lite_codec_pack_basic.htm
        echo.
        choice /c YN /m "Open K-Lite download page now?"
        if %errorlevel% equ 1 start https://codecguide.com/download_k-lite_codec_pack_basic.htm
        pause
        exit /b 1
    )
)

:: Copy icons to the central location
if exist "%current_dir%src\compress.ico" (
    copy "%current_dir%src\compress.ico" "%icons_dir%\"
)
if exist "%current_dir%src\convert.ico" (
    copy "%current_dir%src\convert.ico" "%icons_dir%\"
)
if exist "%current_dir%src\vidlet.ico" (
    copy "%current_dir%src\vidlet.ico" "%icons_dir%\"
)

:: Create temporary registry file with proper paths
echo Creating registry entries...
set "temp_reg=%TEMP%\vidlet_install.reg"
type "%current_dir%install_vidlet.reg" > "%temp_reg%"

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
echo VidLet has been successfully installed to %INSTALL_DIR%!
echo.
echo You can now right-click on:
echo  - MP4 files: Compress Video
echo  - MKV files: Convert to MP4 or Compress Video
echo.
echo You may need to restart Windows Explorer for changes to take effect.
pause
endlocal 