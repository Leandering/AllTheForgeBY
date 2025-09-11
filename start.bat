@echo off
setlocal enabledelayedexpansion

for /f "delims=" %%i in ('powershell -command "$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/Leandering/AllTheForgeBY/releases/latest'; Write-Output ('Version: ' + $release.tag_name + '|Name: ' + $release.name + '|Date: ' + $release.published_at)"') do set RELEASE_INFO=%%i

for /f "tokens=1,2,3 delims=|" %%a in ("!RELEASE_INFO!") do (
    set VERSION=%%a
)

set "LATEST_VERSION=!VERSION:Version: =!"

if exist "version.txt" (
    for /f "tokens=2 delims=: " %%i in ('findstr /C:"Version:" version.txt') do set CURRENT_VERSION=%%i
    echo Current version: !CURRENT_VERSION!
    
    if "!CURRENT_VERSION!"=="!LATEST_VERSION!" (
    ) else (
      echo Starting update process...
      update.bat
    )
)

start polymc.exe