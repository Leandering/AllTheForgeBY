@echo off

cd %Temp%

:: Download and install Git
curl -L -o Git-2.51.0-64-bit.exe https://github.com/git-for-windows/git/releases/download/v2.51.0.windows.1/Git-2.51.0-64-bit.exe
Git-2.51.0-64-bit.exe /SILENT
del Git-2.51.0-64-bit.exe

:: Wait for Git installation to complete
timeout /t 30 /nobreak

:: Create directories
md C:\Games 2>nul
md C:\Games\PolyMC 2>nul
cd /d C:\Games\PolyMC

:: Download and extract JDK
curl -L -o jdk-21.0.7_windows-x64_bin.zip https://download.oracle.com/java/21/archive/jdk-21.0.7_windows-x64_bin.zip
tar -xf jdk-21.0.7_windows-x64_bin.zip
del jdk-21.0.7_windows-x64_bin.zip

:: Download and extract PolyMC
curl -L -o PolyMC-Windows-Portable-7.0.zip https://github.com/PolyMC/PolyMC/releases/download/7.0/PolyMC-Windows-Portable-7.0.zip
tar -xf PolyMC-Windows-Portable-7.0.zip
del PolyMC-Windows-Portable-7.0.zip

:: Clone repository
md temp
git clone https://github.com/Leandering/AllTheForgeBY.git temp
move /Y temp\* .
rd /S /Q temp

:: Download additional PolyMC files
curl -L -o PolyMC.zip https://cloud.hexotella.space/f/d/nM6H8/PolyMC.zip
tar -xf PolyMC.zip
del PolyMC.zip

:: Move PolyMC to AppData
move PolyMC "%AppData%" 2>nul

echo Installation completed!
pause