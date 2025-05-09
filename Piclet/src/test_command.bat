@echo off
setlocal enabledelayedexpansion

:: Set up directories and logging
set "current_dir=%~dp0"
set "log_file=%current_dir%test_command_log.txt"

:: IMMEDIATE LOGGING
echo ====================================== > "%log_file%"
echo Piclet Command Test - %date% %time% >> "%log_file%"
echo ====================================== >> "%log_file%"
echo. >> "%log_file%"

:: Log detailed environment information
echo ENVIRONMENT DETAILS: >> "%log_file%"
echo Current directory: %CD% >> "%log_file%"
echo Script directory: %~dp0 >> "%log_file%"
echo. >> "%log_file%"

echo USER INFORMATION: >> "%log_file%"
echo Username: %USERNAME% >> "%log_file%"
whoami >> "%log_file%" 2>&1
echo. >> "%log_file%"

echo SYSTEM PATHS: >> "%log_file%"
echo ProgramFiles: %ProgramFiles% >> "%log_file%"
echo CommonProgramFiles: %CommonProgramFiles% >> "%log_file%"
echo. >> "%log_file%"

echo COMMAND LINE: >> "%log_file%"
echo Command: %0 %* >> "%log_file%"
echo Parameter: %1 >> "%log_file%"
echo. >> "%log_file%"

:: Test if we can access the input file
if "%~1"=="" (
    echo ERROR: No input file specified. >> "%log_file%"
) else (
    echo Analyzing input file: %~1 >> "%log_file%"
    echo Full path: %~f1 >> "%log_file%"
    echo Directory: %~dp1 >> "%log_file%"
    echo Filename: %~nx1 >> "%log_file%"
    echo File exists: >> "%log_file%"
    if exist "%~1" (
        echo YES - File exists and is accessible >> "%log_file%"
    ) else (
        echo NO - File does not exist or cannot be accessed >> "%log_file%"
    )
)

echo. >> "%log_file%"
echo FILE PERMISSIONS: >> "%log_file%"
echo Checking if script can write to its own directory: >> "%log_file%"
set "test_file=%current_dir%write_test.tmp"
echo This is a test > "%test_file%" 2>> "%log_file%"
if exist "%test_file%" (
    echo SUCCESS - Can write to script directory >> "%log_file%"
    del "%test_file%" >nul 2>&1
) else (
    echo FAILURE - Cannot write to script directory >> "%log_file%"
)

echo. >> "%log_file%"
echo REGISTRY CHECK: >> "%log_file%"
reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletResizeImage\command" /ve >> "%log_file%" 2>&1

echo. >> "%log_file%"
echo DIAGNOSTICS COMPLETE. Opening log file... >> "%log_file%"

:: Open the log file
start notepad "%log_file%"

:: Message box
echo Set objShell = CreateObject("WScript.Shell") > "%temp%\test_msg.vbs"
echo objShell.Popup "Piclet command test complete!" ^& vbCrLf ^& "Log file created at:" ^& vbCrLf ^& "%log_file%", 10, "Test Complete", 64 >> "%temp%\test_msg.vbs"
start /wait cscript //nologo "%temp%\test_msg.vbs"
del "%temp%\test_msg.vbs" >nul 2>&1

endlocal 