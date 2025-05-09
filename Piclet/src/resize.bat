@echo off
setlocal enabledelayedexpansion

:: Set up directories and logging
set "current_dir=%~dp0"
set "log_file=%current_dir%resize_log.txt"

:: IMMEDIATE LOGGING
echo ====================================== > "%log_file%"
echo Piclet Resize Log - %date% %time% >> "%log_file%"
echo ====================================== >> "%log_file%"
echo. >> "%log_file%"

echo Starting resize process... >> "%log_file%"

:: Get input file from parameter
set "input_file=%~1"
echo Input parameter: "%input_file%" >> "%log_file%"

if "%input_file%"=="" (
    echo ERROR: No input file specified. >> "%log_file%"
    notepad "%log_file%"
    exit /b 1
)

:: Check if input file exists
if not exist "%input_file%" (
    echo ERROR: Input file does not exist: "%input_file%" >> "%log_file%"
    notepad "%log_file%"
    exit /b 1
)

:: Default values
set "width=800"
set "height=0"
set "quality=90"
set "magick_exe=%ProgramFiles%\ImageMagick-7.1.1-Q16-HDRI\magick.exe"

echo Using magick_exe: "%magick_exe%" >> "%log_file%"

:: Verify ImageMagick exists
if not exist "%magick_exe%" (
    echo ERROR: ImageMagick not found at: "%magick_exe%" >> "%log_file%"    
    echo No ImageMagick found. >> "%log_file%"
    echo Please install ImageMagick from https://imagemagick.org/script/download.php >> "%log_file%"
    
    :: Show error message using CMD window to ensure visibility
    echo ImageMagick not found at: %magick_exe%
    echo Check log file: %log_file%
    notepad "%log_file%"
    pause
    exit /b 1
)

echo Creating dialog from template... >> "%log_file%"

:: Create a temporary copy of the dialog with the correct values
set "temp_dialog=%temp%\resize_dialog.hta"
set "dialog_template=%current_dir%resize_dialog.html"

if not exist "%dialog_template%" (
    echo ERROR: Dialog template not found at: "%dialog_template%" >> "%log_file%"
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

:: Run the HTA dialog
echo Attempting to run dialog: mshta.exe "%temp_dialog%" >> "%log_file%"
start /wait mshta.exe "%temp_dialog%"
set "dialog_result=%errorlevel%"
echo Dialog returned with exit code: %dialog_result% >> "%log_file%"

:: Check if the user completed the dialog
if not exist "%temp%\resize_result.txt" (
    echo Result file not found, user likely canceled >> "%log_file%"
    del "%temp_dialog%" >nul 2>&1
    echo Operation canceled by user.
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

:: Resize the image
echo Running ImageMagick command: "%magick_exe%" convert "%input_file%" -resize "%resize_param%" -quality %quality% "%output_file%" >> "%log_file%"
"%magick_exe%" convert "%input_file%" -resize "%resize_param%" -quality %quality% "%output_file%" >> "%log_file%" 2>&1
set "magick_result=%errorlevel%"
echo ImageMagick returned with exit code: %magick_result% >> "%log_file%"

:: Check if the output file was created
if not exist "%output_file%" (
    echo ERROR: Failed to create output file. >> "%log_file%"
    echo Check log file for errors: %log_file%
    notepad "%log_file%"
    pause
    exit /b 1
)

echo Output file created successfully: "%output_file%" >> "%log_file%"

:: Show completion message
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\done_msg.vbs"
echo objShell.Popup "Image resized successfully!" ^& vbCrLf ^& "Saved as: %~n1_%width%x%height%%~x1", 10, "Resize Complete", 64 >> "%temp%\done_msg.vbs"
start /wait cscript //nologo "%temp%\done_msg.vbs"
del "%temp%\done_msg.vbs" >nul 2>&1

:: Open the output folder
explorer /select,"%output_file%"

endlocal 