@echo off
setlocal enabledelayedexpansion

:: Set up directories and logging
set "current_dir=%~dp0"
set "log_file=%current_dir%resize_log.txt"
set "debug_file=%current_dir%debug_resize.log"

:: IMMEDIATE LOGGING - write to a file as soon as the script starts
echo START: resize.bat was called at %date% %time% > "%debug_file%"
echo Command line: %0 %* >> "%debug_file%"
echo Working directory: %CD% >> "%debug_file%"
echo. >> "%debug_file%"

:: Set up main log file
echo ====================================== > "%log_file%"
echo Piclet Resize Log - %date% %time% >> "%log_file%"
echo ====================================== >> "%log_file%"
echo. >> "%log_file%"

echo Starting resize process... >> "%log_file%"

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

:: Default values
set "width=800"
set "height=0"
set "quality=90"
set "magick_exe=%ProgramFiles%\MedLet\libs\magick.exe"

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

echo Creating dialog from template... >> "%log_file%"

:: Create a temporary copy of the dialog with the correct values
set "temp_dialog=%temp%\resize_dialog.hta"
set "dialog_template=%current_dir%resize_dialog.html"

if not exist "%dialog_template%" (
    echo ERROR: Dialog template not found at: "%dialog_template%" >> "%log_file%"
    echo ERROR: Dialog template not found at: "%dialog_template%" >> "%debug_file%"
    notepad "%log_file%"
    exit /b 1
)

:: Copy the template and replace placeholders
type "%dialog_template%" > "%temp_dialog%"

:: Replace placeholders with actual values
powershell -Command "(Get-Content '%temp_dialog%') -replace 'PLACEHOLDER_WIDTH', '%width%' | Set-Content '%temp_dialog%'"
powershell -Command "(Get-Content '%temp_dialog%') -replace 'PLACEHOLDER_HEIGHT', '%height%' | Set-Content '%temp_dialog%'"
powershell -Command "(Get-Content '%temp_dialog%') -replace 'PLACEHOLDER_QUALITY', '%quality%' | Set-Content '%temp_dialog%'"
powershell -Command "(Get-Content '%temp_dialog%') -replace 'PLACEHOLDER_BASENAME_', '%~n1_' | Set-Content '%temp_dialog%'"
powershell -Command "(Get-Content '%temp_dialog%') -replace 'PLACEHOLDER_EXTENSION', '%~x1' | Set-Content '%temp_dialog%'"
powershell -Command "(Get-Content '%temp_dialog%') -replace 'PLACEHOLDER_FILENAME', '%~n1_800x0%~x1' | Set-Content '%temp_dialog%'"
powershell -Command "(Get-Content '%temp_dialog%') -replace 'PLACEHOLDER_RESULT_PATH', '%temp%\\resize_result.txt' | Set-Content '%temp_dialog%'"

:: Log the HTA file path
echo Dialog created at: "%temp_dialog%" >> "%log_file%"

:: Run the HTA dialog - this is where it might fail
echo Attempting to run dialog: mshta.exe "%temp_dialog%" >> "%log_file%"
start /wait mshta.exe "%temp_dialog%"
set "dialog_result=%errorlevel%"
echo Dialog returned with exit code: %dialog_result% >> "%log_file%"
echo Dialog returned with exit code: %dialog_result% >> "%debug_file%"

:: Check if the user completed the dialog
if not exist "%temp%\resize_result.txt" (
    echo Result file not found, user likely canceled >> "%log_file%"
    echo Result file not found, user likely canceled >> "%debug_file%"
    del "%temp_dialog%" >nul 2>&1
    echo Operation canceled by user.
    notepad "%log_file%"
    exit /b 0
)

:: Get the results
echo Reading results from: "%temp%\resize_result.txt" >> "%log_file%"
for /f "tokens=1,2,3 delims=|" %%a in ('type "%temp%\resize_result.txt"') do (
    set "width=%%a"
    set "height=%%b"
    set "quality=%%c"
)

echo Parameters - Width: %width%, Height: %height%, Quality: %quality% >> "%log_file%"
echo Parameters - Width: %width%, Height: %height%, Quality: %quality% >> "%debug_file%"

:: Clean up temporary files
echo Cleaning up temp files >> "%log_file%"
del "%temp_dialog%" >nul 2>&1
del "%temp%\resize_result.txt" >nul 2>&1

:: Create output filename with dimensions
set "output_file=%~d1%~p1%~n1_%width%x%height%%~x1"
echo Output file will be: "%output_file%" >> "%log_file%"

:: Build resize parameter string
set "resize_param="
if %width% GTR 0 set "resize_param=%width%"
if %height% GTR 0 (
    if defined resize_param (
        set "resize_param=!resize_param!x%height%"
    ) else (
        set "resize_param=x%height%"
    )
) else (
    if defined resize_param set "resize_param=!resize_param!x"
)

echo Resize parameter: "%resize_param%" >> "%log_file%"
echo Quality parameter: "%quality%" >> "%log_file%"

echo.
echo Resizing image: %~nx1
echo New dimensions: %resize_param%
echo Quality: %quality%%%
echo Please wait...

:: Resize the image - this is where ImageMagick might fail
echo Running ImageMagick command: "%magick_exe%" convert "%input_file%" -resize "%resize_param%" -quality %quality% "%output_file%" >> "%log_file%"
"%magick_exe%" convert "%input_file%" -resize "%resize_param%" -quality %quality% "%output_file%" >> "%log_file%" 2>&1
set "magick_result=%errorlevel%"
echo ImageMagick returned with exit code: %magick_result% >> "%log_file%"
echo ImageMagick returned with exit code: %magick_result% >> "%debug_file%"

:: Check if the output file was created
if not exist "%output_file%" (
    echo ERROR: Failed to create output file. >> "%log_file%"
    echo ERROR: Failed to create output file. >> "%debug_file%"
    echo Check log file for errors: %log_file%
    notepad "%log_file%"
    pause
    exit /b 1
)

echo Output file created successfully: "%output_file%" >> "%log_file%"

:: Show completion message
echo Creating completion message >> "%log_file%"
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\done_msg.vbs"
echo objShell.Popup "Image resized successfully!" ^& vbCrLf ^& "Saved as: %~n1_%width%x%height%%~x1" ^& vbCrLf ^& "Log file: %log_file%", 10, "Resize Complete", 64 >> "%temp%\done_msg.vbs"
start /wait cscript //nologo "%temp%\done_msg.vbs"
del "%temp%\done_msg.vbs" >nul 2>&1

:: Open the output folder
echo Opening output folder >> "%log_file%"
explorer /select,"%output_file%"

:: Open log file
echo Resize operation completed successfully >> "%log_file%"
echo Resize operation completed successfully >> "%debug_file%"
start notepad "%log_file%"

endlocal 