@echo off
setlocal enabledelayedexpansion

set "input_file=%~1"
set "width=800"
set "height=0"
set "quality=90"
set "magick_exe=%ProgramFiles%\MedLet\libs\magick.exe"

:: Create a simple GUI to get dimensions
echo Set oShell = CreateObject("WScript.Shell") > "%temp%\resize_prompt.vbs"
echo Set oExec = oShell.Exec("mshta.exe ""about:<html><head><title>Resize Image</title></head><body><script>moveTo(screen.width/2-150,screen.height/2-100);resizeTo(330,200);document.title='Resize Image';</script><div style='font-family:Segoe UI;padding:20px;'><div style='margin-bottom:10px;'>Enter new dimensions (0 for auto):</div><div style='margin-bottom:10px;'>Width: <input type='text' id='width' value='%width%' style='width:100px;'></div><div style='margin-bottom:10px;'>Height: <input type='text' id='height' value='%height%' style='width:100px;'></div><div style='margin-bottom:10px;'>Quality (1-100): <input type='text' id='quality' value='%quality%' style='width:100px;'></div><button onclick='window.returnValue = document.getElementById(""width"").value + ""|"" + document.getElementById(""height"").value + ""|"" + document.getElementById(""quality"").value; window.close();' style='margin-top:10px;'>Resize</button></div></body></html>""") >> "%temp%\resize_prompt.vbs"
echo Do While oExec.Status = 0 >> "%temp%\resize_prompt.vbs"
echo     WScript.Sleep 100 >> "%temp%\resize_prompt.vbs"
echo Loop >> "%temp%\resize_prompt.vbs"
echo strOutput = oExec.StdOut.ReadAll >> "%temp%\resize_prompt.vbs"
echo Wscript.Echo strOutput >> "%temp%\resize_prompt.vbs"

for /f "delims=" %%i in ('cscript //nologo "%temp%\resize_prompt.vbs"') do (
    set "result=%%i"
)

if "!result!" NEQ "" (
    for /f "tokens=1,2,3 delims=|" %%a in ("!result!") do (
        set "width=%%a"
        set "height=%%b"
        set "quality=%%c"
    )
) else (
    echo Resize canceled by user.
    goto :EOF
)

del "%temp%\resize_prompt.vbs" >nul 2>&1

:: Create output filename with dimensions
set "output_file=%~d1%~p1%~n1_%width%x%height%%~x1"

:: Skip empty dimensions with -
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

:: Resize the image
"%magick_exe%" convert "%input_file%" -resize "%resize_param%" -quality %quality% "%output_file%"

:: Show completion message
echo Set oShell = CreateObject("WScript.Shell") > "%temp%\done_msg.vbs"
echo oShell.Popup "Image resized successfully! Saved as: %~n1_%width%x%height%%~x1", 5, "Resize Complete", 64 >> "%temp%\done_msg.vbs"
cscript //nologo "%temp%\done_msg.vbs"
del "%temp%\done_msg.vbs" >nul 2>&1

endlocal 