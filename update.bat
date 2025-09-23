@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

title Обновление AllTheForgeBY

echo ================================
echo    ПРОЦЕСС ОБНОВЛЕНИЯ
echo ================================

:: Определение типа лаунчера
set LAUNCHER_TYPE=Unknown
if exist "PolyMC.exe" set LAUNCHER_TYPE=PolyMC
if exist "polymc.exe" set LAUNCHER_TYPE=PolyMC
if exist "MultiMC.exe" set LAUNCHER_TYPE=MultiMC
if exist "multimc.exe" set LAUNCHER_TYPE=MultiMC

echo Тип лаунчера: !LAUNCHER_TYPE!

:: Получение информации о последней версии
echo Получение информации о последней версии...
for /f "delims=" %%i in ('powershell -command "$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/Leandering/AllTheForgeBY/releases/latest'; Write-Output ('Version: ' + $release.tag_name + '|Name: ' + $release.name + '|Date: ' + $release.published_at)"') do set RELEASE_INFO=%%i

for /f "tokens=1 delims=|" %%a in ("!RELEASE_INFO!") do (
    set "LATEST_VERSION=%%a"
    set "LATEST_VERSION=!LATEST_VERSION:Version: =!"
)

echo Последняя версия: !LATEST_VERSION!

:: Создание временной папки для обновления
md temp_update 2>nul
cd temp_update

echo Скачивание обновления...
git clone https://github.com/Leandering/AllTheForgeBY.git .

echo Копирование новых файлов...
move /Y * .. 2>nul
cd ..
rd /S /Q temp_update

:: Обновление файла версии
echo Version: !LATEST_VERSION! > version.txt
echo Версия обновлена до: !LATEST_VERSION!

echo.
echo Обновление завершено!
echo Запуск лаунчера...
timeout /t 3 /nobreak >nul

:: Запуск лаунчера после обновления
if "!LAUNCHER_TYPE!"=="PolyMC" (
    if exist "PolyMC.exe" start PolyMC.exe
    if exist "polymc.exe" start polymc.exe
) else if "!LAUNCHER_TYPE!"=="MultiMC" (
    if exist "MultiMC.exe" start MultiMC.exe
    if exist "multimc.exe" start multimc.exe
)

start.bat