@echo off
setlocal enabledelayedexpansion

rd /S /Q C:\Games\PolyMC 2>nul
rd /S /Q "%Appdata%\PolyMC" 2>nul

md C:\Games\PolyMC 2>nul
cd /d C:\Games\PolyMC

curl -L -o jdk-21.0.7_windows-x64_bin.zip https://download.oracle.com/java/21/archive/jdk-21.0.7_windows-x64_bin.zip
tar -xf jdk-21.0.7_windows-x64_bin.zip
del jdk-21.0.7_windows-x64_bin.zip

curl -L -o PolyMC-Windows-Portable-7.0.zip https://github.com/PolyMC/PolyMC/releases/download/7.0/PolyMC-Windows-Portable-7.0.zip
tar -xf PolyMC-Windows-Portable-7.0.zip
del PolyMC-Windows-Portable-7.0.zip

md temp
git clone https://github.com/Leandering/AllTheForgeBY.git temp
move /Y temp\* . 2>nul
rd /S /Q temp

set /p LINK=<dwlink.txt
curl -L -o PolyMC.zip "!LINK!"
tar -xf PolyMC.zip
del PolyMC.zip

move PolyMC "%AppData%" 2>nul
echo Update completed!