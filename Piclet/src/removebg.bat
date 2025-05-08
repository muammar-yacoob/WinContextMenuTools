@echo off
setlocal enabledelayedexpansion

set "input_file=%~1"
set "output_file=%~d1%~p1%~n1_nobg%~x1"
set "magick_exe=%ProgramFiles%\MedLet\libs\magick.exe"

:: Remove the background (white becomes transparent)
"%magick_exe%" convert "%input_file%" -transparent white "%output_file%"

:: Show completion message
echo Set oShell = CreateObject("WScript.Shell") > "%temp%\done_msg.vbs"
echo oShell.Popup "Background removed successfully! Saved as: %~n1_nobg%~x1", 5, "Background Removal Complete", 64 >> "%temp%\done_msg.vbs"
cscript //nologo "%temp%\done_msg.vbs"
del "%temp%\done_msg.vbs" >nul 2>&1

endlocal 