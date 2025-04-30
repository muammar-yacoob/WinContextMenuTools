@echo off
setlocal enabledelayedexpansion

cd /d %~dp0

set "INPUT=%~1"
set "OUTPUT=%~dpn1.mp4"

:: Delete existing output file if it exists
if exist "!OUTPUT!" del "!OUTPUT!"

:: Convert MKV to MP4 without changing quality
ffmpeg.exe -i "!INPUT!" -c:v copy -c:a copy "!OUTPUT!"

pause