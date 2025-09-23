@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

title AllTheForgeBY Launcher

:: Проверка обновлений
echo Проверка обновлений...
for /f "delims=" %%i in ('powershell -command "$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/Leandering/AllTheForgeBY/releases/latest'; Write-Output ('Version: ' + $release.tag_name + '|Name: ' + $release.name + '|Date: ' + $release.published_at)"') do set RELEASE_INFO=%%i

for /f "tokens=1,2,3 delims=|" %%a in ("!RELEASE_INFO!") do (
    set VERSION_LINE=%%a
    set NAME_LINE=%%b
    set DATE_LINE=%%c
)

set "LATEST_VERSION=!VERSION_LINE:Version: =!"
set "RELEASE_NAME=!NAME_LINE:Name: =!"
set "RELEASE_DATE=!DATE_LINE:Date: =!"

echo.
echo ================================
echo    AllTheForgeBY Launcher
echo ================================
echo Последняя версия: !LATEST_VERSION!
echo Название: !RELEASE_NAME!
echo Дата выпуска: !RELEASE_DATE!
echo.

if exist "version.txt" (
    for /f "tokens=2 delims=: " %%i in ('findstr /C:"Version:" version.txt') do set CURRENT_VERSION=%%i
    echo Текущая версия: !CURRENT_VERSION!
    
    if "!CURRENT_VERSION!"=="!LATEST_VERSION!" (
        echo У вас установлена последняя версия!
    ) else (
        echo Обнаружена новая версия!
        echo Запуск процесса обновления...
        timeout /t 3 /nobreak >nul
        update.bat
        goto :EOF
    )
) else (
    echo Файл версии не найден. Создание нового...
    echo Version: !LATEST_VERSION! > version.txt
    set CURRENT_VERSION=!LATEST_VERSION!
)

:: Меню запуска
:MENU
echo.
echo ================================
echo          МЕНЮ ЗАПУСКА
echo ================================
echo 1. Запустить лаунчер
echo 2. Открыть папку лаунчера
echo 3. Проверить обновления
echo 4. Переустановить
echo 5. Выход
echo.
set /p CHOICE="Выберите опцию (1-5): "

if "%CHOICE%"=="1" goto START_LAUNCHER
if "%CHOICE%"=="2" goto OPEN_FOLDER
if "%CHOICE%"=="3" goto CHECK_UPDATE
if "%CHOICE%"=="4" goto REINSTALL
if "%CHOICE%"=="5" goto EXIT

echo Неверный выбор! Пожалуйста, введите число от 1 до 5.
goto MENU

:START_LAUNCHER
echo Запуск лаунчера...
if exist "PolyMC.exe" (
    start PolyMC.exe
) else if exist "MultiMC.exe" (
    start MultiMC.exe
) else if exist "polymc.exe" (
    start polymc.exe
) else if exist "multimc.exe" (
    start multimc.exe
) else (
    echo Файл лаунчера не найден!
    pause
)
goto MENU

:OPEN_FOLDER
echo Открытие папки...
explorer .
goto MENU

:CHECK_UPDATE
echo Принудительная проверка обновлений...
update.bat
goto :EOF

:REINSTALL
echo Переустановка...
echo Удаление текущей установки...
cd ..
if exist "PolyMC" rd /S /Q PolyMC
if exist "MultiMC" rd /S /Q MultiMC
echo Запуск установщика...
start main_installer.bat
goto :EOF

:EXIT
echo Выход...
timeout /t 2 /nobreak >nul
exit