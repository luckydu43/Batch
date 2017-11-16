@echo off
color 0a
title Kill the process

echo.
set /p processus=Dis-moi qui et je le tuerai... -^> 

cls
echo.
echo Genocide de plein de %processus% en cours... please wait
echo (tu es libre d'arrˆter le carnage quand tu veux en tapant simplement CTRL+C)
echo.

set compteurDeKills=0

:1
for /f "tokens=1 delims=," %%a in ('tasklist /fo csv ^|FINDSTR /I /C:"%processus%"') do call :headshot %%a
goto 1


:headshot
set vraiProcess=%1
set nomDuProcessus=.,;%processus%;,.

taskkill /f /im %vraiProcess%>nul 2>&1

set codeerreur=%errorlevel%

set etat=Ja voll, nous zafons tape %vraiProcess% ach

if not %codeerreur%==0 echo Nope. Code d'erreur: %codeerreur%

if %codeerreur%==128 echo %vraiProcess% est juste introuvable.

set /a compteurDeKills=%compteurDeKills%+1
title Kill %processus% : %compteurDeKills%
goto 1