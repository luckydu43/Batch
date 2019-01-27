@echo off & mode con: cols=30 lines=30
color 0a
title Lancement admin

REM #######################################################
REM ############ Elevation de droits via l'UAC ############
REM #######################################################

:elevation
REM Vérifie si l'instance est déjà en élévation de droits
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM Si l'errorlevel est différent de 0, l'instance n'est pas élevée : il faut le faire :-)
if '%errorlevel%' NEQ '0' (
  goto affichageDelUAC
) else (goto elevationReussie)

:affichageDelUAC
echo Set popupUAC = CreateObject^("Shell.Application"^) > "%temp%\elevation.vbs"
echo popupUAC.ShellExecute "%~s0", "", "", "runas", 1  >> "%temp%\elevation.vbs"
"%temp%\elevation.vbs"
exit /B

:elevationReussie
if exist "%temp%\elevation.vbs" ( del "%temp%\elevation.vbs" )

:lancement

cd "C:\Program Files (x86)\ASUS\GPU TweakII\"
start "asusgpu" "C:\Program Files (x86)\ASUS\GPU TweakII\GPUTweakII.exe"

cd "C:\Program Files (x86)\MSI Afterburner"
start "aft" "C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe"

cd "C:\Program Files (x86)\MSI\Command Center"
start "msi" "C:\Program Files (x86)\MSI\Command Center\CC_LoadingPage.exe"

start "taskmgr" taskmgr
start "resmon" resmon
start

:menuPrincipal
cls
echo.
echo ### Selection : ###
echo.
echo 1. Asus GPU Tweak
echo 2. Aura RGB
echo 3. GRID 2
echo 4. Discord
echo 5. MSI Command Center
echo 6. CMD.exe
echo 7. Afterburner
echo 8. Uplay
echo 9. Autre (selection manuelle)
echo 10. 3DMark 11
echo 11. MSI Eco Center
echo 12. Watch Dogs
echo 13. Gestionnaire de tâches
echo 14. Moniteur de ressources
echo 15. Tout relancer
echo 0. Quitter
echo.

set saisie=yolo
set /p saisie="? : "
if %saisie% EQU 1 goto asusgpu
if %saisie% EQU 2 goto aurargb
if %saisie% EQU 3 goto grd
if %saisie% EQU 4 goto discord
if %saisie% EQU 5 goto msi
if %saisie% EQU 6 goto cmd
if %saisie% EQU 7 goto aft
if %saisie% EQU 8 goto upy
if %saisie% EQU 9 goto atr
if %saisie% EQU 10 goto 3dm
if %saisie% EQU 11 goto eco
if %saisie% EQU 12 goto wtd
if %saisie% EQU 13 goto tsk
if %saisie% EQU 14 goto rsm
if %saisie% EQU 15 goto lancement

if %saisie% EQU 0 goto ext
goto menuPrincipal

:asusgpu
cd "C:\Program Files (x86)\ASUS\GPU TweakII\"
start "asusgpu" "C:\Program Files (x86)\ASUS\GPU TweakII\GPUTweakII.exe"
goto menuPrincipal

:aurargb
cd "C:\Program Files (x86)\ASUS\AURA(GRAPHICS CARD)\"
start "aurargb" "C:\Program Files (x86)\ASUS\AURA(GRAPHICS CARD)\AURA(GRAPHICS CARD).exe"
goto menuPrincipal

:grd
cd "C:\Program Files (x86)\GRID 2"
start "grd" "C:\Program Files (x86)\GRID 2\grid2.exe"
goto menuPrincipal

:discord
cd "C:\Users\luc\AppData\Local\Discord\app-0.0.301"
start "discord" "C:\Users\luc\AppData\Local\Discord\Update.exe" --processStart Discord.exe
goto menuPrincipal

:msi
cd "C:\Program Files (x86)\MSI\Command Center"
start "msi" "C:\Program Files (x86)\MSI\Command Center\CC_LoadingPage.exe"
goto menuPrincipal

:cmd
start
goto menuPrincipal

:aft
cd "C:\Program Files (x86)\MSI Afterburner"
start "aft" "C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe"
goto menuPrincipal

:upy
cd "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher"
start "upy" "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\Uplay.exe"
goto menuPrincipal

:3dm
cd "C:\Program Files\Futuremark\3DMark 11\bin\x64\"
start "3dm" "C:\Program Files\Futuremark\3DMark 11\bin\x64\3DMark11.exe"
goto menuPrincipal

:eco
cd "C:\Program Files (x86)\MSI\ECO Center"
start "eco" "C:\Program Files (x86)\MSI\ECO Center\ECO Center.exe"
goto menuPrincipal

:wtd
start "wtd" uplay://launch/274
goto menuPrincipal

:rsm
start "resmon" resmon
goto menuPrincipal

:tsk
start "taskmgr" taskmgr
goto menuPrincipal

:atr
set /p saisie="Chemin : "
cd %saisie%
pause
set /p saisie="Programme : "
start "css" %saisie%
pause
goto menuPrincipal

:ext
cls 
exit

