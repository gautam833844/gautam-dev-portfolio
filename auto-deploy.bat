@echo off
title Portfolio Auto-Deploy Monitor
color 0A
chcp 65001 >nul

cd /d d:\poatfolio

echo.
echo ========================================
echo  🚀 Portfolio Auto-Deploy Started
echo ========================================
echo.
echo Watching for changes to index.html
echo Press Ctrl+C to stop
echo.

REM Configure git (one time)
git config user.email "gautamreddy833@gmail.com"
git config user.name "Gautam Reddy"

REM Simple file monitor - check every 3 seconds
setlocal enabledelayedexpansion
set "LASTMOD="

:monitor
for /f %%A in ('powershell -NoProfile -command "Get-Item index.html | Select-Object -ExpandProperty LastWriteTime"') do set "CURRENTMOD=%%A"

if not "!LASTMOD!"=="!CURRENTMOD!" (
    if not "!LASTMOD!"=="" (
        echo.
        echo [%date% %time%] 📝 Change detected in index.html
        echo [%date% %time%] ⏳ Auto-committing...
        
        git add .
        git commit -m "Auto-update: %date% %time%"
        
        echo [%date% %time%] ⏳ Pushing to GitHub...
        git push origin main
        
        echo [%date% %time%] ✅ Successfully deployed!
        echo [%date% %time%] 🔗 Your live site is updating...
        echo.
    )
    set "LASTMOD=!CURRENTMOD!"
)

timeout /t 2 /nobreak >nul
goto monitor
