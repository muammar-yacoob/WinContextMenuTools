@echo off
setlocal enabledelayedexpansion

cd /d %~dp0

set "INPUT=%~1"
set "OUTPUT=%~dpn1_compressed.mp4"

:: Delete existing compressed file if it exists
:: if exist "!OUTPUT!" del "!OUTPUT!"

:: Compress the video with 500k bitrate
ffmpeg.exe -i "!INPUT!" -b:v 1500k "!OUTPUT!"

pause