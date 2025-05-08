@echo off
setlocal enabledelayedexpansion

set "input_file=%~1"
set "default_bitrate=1500"
set "default_preset=medium"
set "ffmpeg_exe=%ProgramFiles%\MedLet\libs\FFmpeg\bin\ffmpeg.exe"

:: Create a simple GUI to get compression settings
echo Set oShell = CreateObject("WScript.Shell") > "%temp%\compress_prompt.vbs"
echo Set oExec = oShell.Exec("mshta.exe ""about:<html><head><title>Compress Video</title></head><body><script>moveTo(screen.width/2-150,screen.height/2-100);resizeTo(330,220);document.title='Compress Video';</script><div style='font-family:Segoe UI;padding:20px;'><div style='margin-bottom:10px;'>Compression Settings:</div><div style='margin-bottom:10px;'>Bitrate (kb/s): <input type='text' id='bitrate' value='%default_bitrate%' style='width:100px;'></div><div style='margin-bottom:10px;'>Preset: <select id='preset' style='width:100px;'><option value='ultrafast'>Ultrafast</option><option value='superfast'>Superfast</option><option value='veryfast'>Very Fast</option><option value='faster'>Faster</option><option value='fast'>Fast</option><option selected value='medium'>Medium</option><option value='slow'>Slow</option><option value='slower'>Slower</option><option value='veryslow'>Very Slow</option></select></div><button onclick='window.returnValue = document.getElementById(""bitrate"").value + ""|"" + document.getElementById(""preset"").value; window.close();' style='margin-top:10px;'>Compress</button></div></body></html>""") >> "%temp%\compress_prompt.vbs"
echo Do While oExec.Status = 0 >> "%temp%\compress_prompt.vbs"
echo     WScript.Sleep 100 >> "%temp%\compress_prompt.vbs"
echo Loop >> "%temp%\compress_prompt.vbs"
echo strOutput = oExec.StdOut.ReadAll >> "%temp%\compress_prompt.vbs"
echo Wscript.Echo strOutput >> "%temp%\compress_prompt.vbs"

for /f "delims=" %%i in ('cscript //nologo "%temp%\compress_prompt.vbs"') do (
    set "result=%%i"
)

if "!result!" NEQ "" (
    for /f "tokens=1,2 delims=|" %%a in ("!result!") do (
        set "bitrate=%%a"
        set "preset=%%b"
    )
) else (
    echo Compression canceled by user.
    goto :EOF
)

del "%temp%\compress_prompt.vbs" >nul 2>&1

:: Create output filename
set "output_file=%~d1%~p1%~n1_compressed.mp4"

:: Compress the video
echo Compressing video...
"%ffmpeg_exe%" -i "%input_file%" -c:v libx264 -preset %preset% -b:v %bitrate%k -pass 1 -f mp4 NUL && ^
"%ffmpeg_exe%" -i "%input_file%" -c:v libx264 -preset %preset% -b:v %bitrate%k -pass 2 -c:a aac -b:a 128k "%output_file%"

:: Show completion message
echo Set oShell = CreateObject("WScript.Shell") > "%temp%\done_msg.vbs"
echo oShell.Popup "Video compressed successfully! Saved as: %~n1_compressed.mp4", 5, "Compression Complete", 64 >> "%temp%\done_msg.vbs"
cscript //nologo "%temp%\done_msg.vbs"
del "%temp%\done_msg.vbs" >nul 2>&1

endlocal 