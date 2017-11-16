@echo off
echo.
echo En attente de l'‚l‚vation des droits admin...
echo.
net file 1>NUL 2>NUL & if errorlevel 1 (goto affichageDelUAC) else (goto elevationReussie)
:affichageDelUAC
echo Set popupUAC = CreateObject^("Shell.Application"^) > "%temp%\elevation.vbs"
echo popupUAC.ShellExecute "%~s0", "", "", "runas", 1  >> "%temp%\elevation.vbs"
"%temp%\elevation.vbs"
exit /B
:elevationReussie
if exist "%temp%\elevation.vbs" (del "%temp%\elevation.vbs")
cls
echo.
echo Full access granted :-)
echo.
taskkill /im SearchUI.exe /f

@CHOICE /T:10 /d /N
cd..
cd Systemapps
ren Microsoft.Windows.Cortana_cw5n1h2txyewy Microsoft.Windows.Cortana_cw5n1h2txyewy.bak421
pause