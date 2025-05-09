@echo off
setlocal enabledelayedexpansion

:: Create a log file in current directory
set "current_dir=%~dp0"
set "log_file=%current_dir%registry_test_log.txt"
echo ====================================== > "%log_file%"
echo Piclet Registry Test - %date% %time% >> "%log_file%"
echo ====================================== >> "%log_file%"
echo. >> "%log_file%"

echo Testing registry entries and file paths... 

:: Test if the registry entries exist
echo Testing registry entries: >> "%log_file%"
echo. >> "%log_file%"

echo Checking PicletConvertToIcon...
reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletConvertToIcon" /v "Icon" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] PicletConvertToIcon registry key found. >> "%log_file%"
    
    :: Get the command value
    for /f "tokens=3*" %%a in ('reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletConvertToIcon\command" /ve 2^>nul ^| find "REG_SZ"') do (
        set "command=%%a %%b"
        echo Command: !command! >> "%log_file%"
        
        :: Extract the batch file path
        set "command=!command:"=!"
        echo Raw command: !command! >> "%log_file%"
        
        for /f "tokens=* delims= " %%c in ("!command!") do (
            set "cmd_exe=%%c"
        )
        echo CMD.EXE path: !cmd_exe! >> "%log_file%"
    )
) else (
    echo [FAIL] PicletConvertToIcon registry key not found. >> "%log_file%"
)

echo Checking PicletRemoveBackground...
reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletRemoveBackground" /v "Icon" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] PicletRemoveBackground registry key found. >> "%log_file%"
    
    :: Get the command value
    for /f "tokens=3*" %%a in ('reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletRemoveBackground\command" /ve 2^>nul ^| find "REG_SZ"') do (
        set "command=%%a %%b"
        echo Command: !command! >> "%log_file%"
    )
) else (
    echo [FAIL] PicletRemoveBackground registry key not found. >> "%log_file%"
)

echo Checking PicletResizeImage...
reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletResizeImage" /v "Icon" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] PicletResizeImage registry key found. >> "%log_file%"
    
    :: Get the command value
    for /f "tokens=3*" %%a in ('reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.png\Shell\PicletResizeImage\command" /ve 2^>nul ^| find "REG_SZ"') do (
        set "command=%%a %%b"
        echo Command: !command! >> "%log_file%"
    )
) else (
    echo [FAIL] PicletResizeImage registry key not found. >> "%log_file%"
)

:: Test if the batch files exist
echo. >> "%log_file%"
echo Testing batch files: >> "%log_file%"

echo Checking converttopng.bat...
if exist "%ProgramFiles%\MedLet\Piclet\src\converttopng.bat" (
    echo [OK] converttopng.bat found at %ProgramFiles%\MedLet\Piclet\src\converttopng.bat >> "%log_file%"
) else (
    echo [FAIL] converttopng.bat not found at %ProgramFiles%\MedLet\Piclet\src\converttopng.bat >> "%log_file%"
)

echo Checking removebg.bat...
if exist "%ProgramFiles%\MedLet\Piclet\src\removebg.bat" (
    echo [OK] removebg.bat found at %ProgramFiles%\MedLet\Piclet\src\removebg.bat >> "%log_file%"
) else (
    echo [FAIL] removebg.bat not found at %ProgramFiles%\MedLet\Piclet\src\removebg.bat >> "%log_file%"
)

echo Checking resize.bat...
if exist "%ProgramFiles%\MedLet\Piclet\src\resize.bat" (
    echo [OK] resize.bat found at %ProgramFiles%\MedLet\Piclet\src\resize.bat >> "%log_file%"
) else (
    echo [FAIL] resize.bat not found at %ProgramFiles%\MedLet\Piclet\src\resize.bat >> "%log_file%"
)

:: Test if ImageMagick exists
echo. >> "%log_file%"
echo Testing ImageMagick: >> "%log_file%"

echo Checking magick.exe...
if exist "%ProgramFiles%\MedLet\libs\magick.exe" (
    echo [OK] magick.exe found at %ProgramFiles%\MedLet\libs\magick.exe >> "%log_file%"
) else (
    echo [FAIL] magick.exe not found at %ProgramFiles%\MedLet\libs\magick.exe >> "%log_file%"
    
    if exist "%ProgramFiles%\ImageMagick-7.1.1-Q16-HDRI\magick.exe" (
        echo [INFO] magick.exe found at alternative location: %ProgramFiles%\ImageMagick-7.1.1-Q16-HDRI\magick.exe >> "%log_file%"
    ) else (
        echo [INFO] magick.exe not found in common locations >> "%log_file%"
    )
)

:: Test if icons exist
echo. >> "%log_file%"
echo Testing icons: >> "%log_file%"

echo Checking png2icon.ico...
if exist "%ProgramFiles%\MedLet\Piclet\src\icons\png2icon.ico" (
    echo [OK] png2icon.ico found >> "%log_file%"
) else (
    echo [FAIL] png2icon.ico not found >> "%log_file%"
)

echo Checking removebg.ico...
if exist "%ProgramFiles%\MedLet\Piclet\src\icons\removebg.ico" (
    echo [OK] removebg.ico found >> "%log_file%"
) else (
    echo [FAIL] removebg.ico not found >> "%log_file%"
)

echo Checking resize.ico...
if exist "%ProgramFiles%\MedLet\Piclet\src\icons\resize.ico" (
    echo [OK] resize.ico found >> "%log_file%"
) else (
    echo [FAIL] resize.ico not found >> "%log_file%"
)

echo.
echo Diagnostic test completed! Results saved to:
echo %log_file%
echo.
echo Opening log file...
start notepad "%log_file%"

endlocal 