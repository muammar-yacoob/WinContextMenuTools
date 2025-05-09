@echo off
setlocal enabledelayedexpansion

:: Set up directories and logging
set "current_dir=%~dp0"
set "log_file=%current_dir%converttopng_log.txt"
set "debug_file=%current_dir%debug_convert.log"

:: IMMEDIATE LOGGING - write to a file as soon as the script starts
echo START: converttopng.bat was called at %date% %time% > "%debug_file%"
echo Command line: %0 %* >> "%debug_file%"
echo Working directory: %CD% >> "%debug_file%"
echo. >> "%debug_file%"

:: Set up main log file
echo ====================================== > "%log_file%"
echo Piclet Convert to Icon Log - %date% %time% >> "%log_file%"
echo ====================================== >> "%log_file%"
echo. >> "%log_file%"

echo Starting PNG to Icon conversion process... >> "%log_file%"

:: Get input file from parameter
set "input_file=%~1"
echo Input parameter: "%input_file%" >> "%log_file%"
echo Input parameter: "%input_file%" >> "%debug_file%"

if "%input_file%"=="" (
    echo ERROR: No input file specified. >> "%log_file%"
    echo ERROR: No input file specified. >> "%debug_file%"
    notepad "%log_file%"
    exit /b 1
)

:: Check if input file exists
if not exist "%input_file%" (
    echo ERROR: Input file does not exist: "%input_file%" >> "%log_file%"
    echo ERROR: Input file does not exist: "%input_file%" >> "%debug_file%"
    notepad "%log_file%"
    exit /b 1
)

:: Set output and paths
set "output_file=%~d1%~p1%~n1.ico"
set "magick_exe=%ProgramFiles%\MedLet\libs\magick.exe"

echo Output file will be: "%output_file%" >> "%log_file%"
echo Using magick_exe: "%magick_exe%" >> "%log_file%"

:: Verify ImageMagick exists
if not exist "%magick_exe%" (
    echo ERROR: ImageMagick not found at: "%magick_exe%" >> "%log_file%"
    echo ERROR: ImageMagick not found at: "%magick_exe%" >> "%debug_file%"
    
    :: Try to find magick.exe elsewhere
    echo Searching for alternative magick.exe locations... >> "%log_file%"
    if exist "%ProgramFiles%\ImageMagick-7.1.1-Q16-HDRI\magick.exe" (
        set "magick_exe=%ProgramFiles%\ImageMagick-7.1.1-Q16-HDRI\magick.exe"
        echo Found alternative: "%magick_exe%" >> "%log_file%"
    ) else (
        echo No alternative ImageMagick found. >> "%log_file%"
        echo Please reinstall MedLet or verify ImageMagick installation. >> "%log_file%"
        
        :: Show error message using CMD window to ensure visibility
        echo ImageMagick not found at: %magick_exe%
        echo Check log file: %log_file%
        notepad "%log_file%"
        pause
        exit /b 1
    )
)

echo.
echo Converting PNG to icon: %~nx1
echo Creating multi-resolution icon with sizes: 256, 128, 64, 48, 32, 16
echo Please wait...

:: Convert PNG to ICO with multiple resolutions
echo Running ImageMagick command: "%magick_exe%" convert "%input_file%" -define icon:auto-resize=256,128,64,48,32,16 "%output_file%" >> "%log_file%"
"%magick_exe%" convert "%input_file%" -define icon:auto-resize=256,128,64,48,32,16 "%output_file%" >> "%log_file%" 2>&1
set "magick_result=%errorlevel%"
echo ImageMagick returned with exit code: %magick_result% >> "%log_file%"

:: Check if the output file was created
if not exist "%output_file%" (
    echo ERROR: Failed to create icon file. >> "%log_file%"
    echo ERROR: Failed to create icon file. >> "%debug_file%"
    echo Check log file for errors: %log_file%
    notepad "%log_file%"
    pause
    exit /b 1
)

echo Output file created successfully: "%output_file%" >> "%log_file%"

:: Show completion message
echo Creating completion message >> "%log_file%"
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\done_msg.vbs"
echo objShell.Popup "PNG converted to icon successfully!" ^& vbCrLf ^& "Saved as: %~n1.ico" ^& vbCrLf ^& "Log file: %log_file%", 10, "Conversion Complete", 64 >> "%temp%\done_msg.vbs"
start /wait cscript //nologo "%temp%\done_msg.vbs"
del "%temp%\done_msg.vbs" >nul 2>&1

:: Open the output folder
echo Opening output folder >> "%log_file%"
explorer /select,"%output_file%"

:: Open log file
echo Conversion completed successfully >> "%log_file%"
echo Conversion completed successfully >> "%debug_file%"
start notepad "%log_file%"

endlocal 