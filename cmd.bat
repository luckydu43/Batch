@echo off
for /f "delims=" %%i in ('ver') do Set VrTemp=%%i
echo %VrTemp%
echo (c) 2017 Luckydu43 Corporation. Tous droits r‚serv‚s.
:1
echo.
set /p command=%CD%^>
%command%
goto 1