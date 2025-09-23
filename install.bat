@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

cd %Temp%

:: Скачивание и установка Git
echo Установка Git...
curl -L -o Git-2.51.0-64-bit.exe https://github.com/git-for-windows/git/releases/download/v2.51.0.windows.1/Git-2.51.0-64-bit.exe
Git-2.51.0-64-bit.exe /SILENT
del Git-2.51.0-64-bit.exe

:: Создание директорий
md C:\Games 2>nul

:: Скачивание JDK
echo Скачивание JDK...
curl -L -o jdk-21.0.7_windows-x64_bin.zip https://download.oracle.com/java/21/archive/jdk-21.0.7_windows-x64_bin.zip

:: Выбор пользователя
:CHOICE_MENU
echo.
echo ================================
echo    Выбор лаунчера для установки
echo ================================
echo 1. PolyMC
echo 2. MultiMC
echo.
set /p CHOICE="Введите ваш выбор (1-2): "

if "%CHOICE%"=="1" goto INSTALL_POLYMC
if "%CHOICE%"=="2" goto INSTALL_MULTIMC
echo Неверный выбор! Пожалуйста, введите 1 или 2.
goto CHOICE_MENU

:INSTALL_POLYMC
echo Вы выбрали: PolyMC
set INSTALL_POLYMC=1
set INSTALL_MULTIMC=0
md C:\Games\PolyMC 2>nul
goto EXTRACT_JDK

:INSTALL_MULTIMC
echo Вы выбрали: MultiMC
set INSTALL_POLYMC=0
set INSTALL_MULTIMC=1
md C:\Games\MultiMC 2>nul
goto EXTRACT_JDK

:EXTRACT_JDK
echo Распаковка JDK...
tar -xf jdk-21.0.7_windows-x64_bin.zip
del jdk-21.0.7_windows-x64_bin.zip

:: Установка PolyMC если выбран
if "%INSTALL_POLYMC%"=="1" (
    echo.
    echo Установка PolyMC...
    cd /d C:\Games\PolyMC
    
    :: Скачивание и распаковка PolyMC
    echo Скачивание PolyMC...
    curl -L -o PolyMC.zip https://github.com/PolyMC/PolyMC/releases/download/7.0/PolyMC-Windows-Portable-7.0.zip
    tar -xf PolyMC.zip
    del PolyMC.zip
    
    :: Скачивание дополнительных файлов PolyMC
    echo Скачивание дополнительных файлов...
    curl -L -o PolyMC_extra.zip https://cloud.hexotella.space/f/d/nM6H8/PolyMC.zip
    tar -xf PolyMC_extra.zip
    del PolyMC_extra.zip
    
    :: Клонирование репозитория для PolyMC
    echo Клонирование репозитория...
    md temp_poly
    git clone https://github.com/Leandering/AllTheForgeBY.git temp_poly
    move /Y temp_poly\* . 2>nul
    rd /S /Q temp_poly
    
    :: Перемещение PolyMC в AppData
    echo Копирование файлов...
    xcopy PolyMC "%AppData%\PolyMC" /E /H /I /Y 2>nul
    xcopy PolyMC "C:\Games\PolyMC" /E /H /I /Y 2>nul
    rd /S /Q PolyMC
    
    :: Создание файла версии
    echo Создание информации о версии...
    for /f "delims=" %%i in ('powershell -command "$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/Leandering/AllTheForgeBY/releases/latest'; Write-Output ('Version: ' + $release.tag_name + '|Name: ' + $release.name + '|Date: ' + $release.published_at)"') do set RELEASE_INFO=%%i
    
    for /f "tokens=1 delims=|" %%a in ("!RELEASE_INFO!") do (
        echo %%a > version.txt
        echo Установленная версия: %%a
    )
    
    echo Установка PolyMC завершена!
)

:: Установка MultiMC если выбран
if "%INSTALL_MULTIMC%"=="1" (
    echo.
    echo Установка MultiMC...
    cd /d C:\Games\MultiMC
    
    :: Скачивание и распаковка MultiMC
    echo Скачивание MultiMC...
    curl -L -o MultiMC.zip https://files.multimc.org/downloads/mmc-develop-win32.zip
    tar -xf MultiMC.zip
    del MultiMC.zip
    
    :: Скачивание дополнительных файлов MultiMC
    echo Скачивание дополнительных файлов...
    curl -L -o MultiMC_extra.zip https://cloud.hexotella.space/f/d/a9KCO/MultiMC.zip
    tar -xf MultiMC_extra.zip
    del MultiMC_extra.zip
    
    :: Клонирование репозитория для MultiMC
    echo Клонирование репозитория...
    md temp_multi
    git clone https://github.com/Leandering/AllTheForgeBY.git temp_multi
    move /Y temp_multi\* . 2>nul
    rd /S /Q temp_multi
    
    :: Перемещение MultiMC в AppData
    echo Копирование файлов...
    xcopy MultiMC "%AppData%\MultiMC" /E /H /I /Y 2>nul
    xcopy MultiMC "C:\Games\MultiMC" /E /H /I /Y 2>nul
    rd /S /Q MultiMC
    
    :: Создание файла версии
    echo Создание информации о версии...
    for /f "delims=" %%i in ('powershell -command "$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/Leandering/AllTheForgeBY/releases/latest'; Write-Output ('Version: ' + $release.tag_name + '|Name: ' + $release.name + '|Date: ' + $release.published_at)"') do set RELEASE_INFO=%%i
    
    for /f "tokens=1 delims=|" %%a in ("!RELEASE_INFO!") do (
        echo %%a > version.txt
        echo Установленная версия: %%a
    )
    
    echo Установка MultiMC завершена!
)

:: Запуск основного скрипта
echo.
echo Запуск основного скрипта...
if "%INSTALL_POLYMC%"=="1" (
    cd /d C:\Games\PolyMC
) else (
    cd /d C:\Games\MultiMC
)
start.bat