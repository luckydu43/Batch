@echo off
SETLOCAL ENABLEdelayedExpansion
title Script de sauvegarde incr‚mentale
color 0a
echo.
echo ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo º                                   º
echo º Script de sauvegarde incr‚mentale º
echo º                                   º
echo ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
echo.

REM #######################################################
REM ##################### Paramètres ######################
REM #######################################################

REM Definir ces variables !!!
REM   	      |
REM          \|/
REM	      *
REM
net use w: \\169.254.171.123\volume1
set REPERTOIRE_SOURCE=W:\
set REPERTOIRE_CIBLE=C:\HDD
REM
REM	      ^
REM	     /|\
REM           |

set libelleLog= Copie lancée le %Date% à %Time%
set ligneLog=----------------------------------
set dateDossier=%date:~6,4%%date:~3,2%%date:~0,2%

REM #################################
REM ####### Gestion des dates #######
REM #################################

set /a N=((1461 * (%A% + 4800 + (%M% - 14) / 12)) / 4 + (367 * (%M% - 2 - 12 * ((%M% - 14) / 12))) / 12 - (3 * ((%A% + 4900 + (%M% - 14) / 12) / 100)) / 4 + %J% - 32075) %% 7
if %N%==4 (
set maxage=3
) else (
set maxage=1 )

REM ########################################
REM ############ Tests initiaux ############
REM ########################################

cd %REPERTOIRE_SOURCE%
if errorlevel 1 (echo. & goto erreurRepertoireSource)

if not exist %REPERTOIRE_CIBLE% (echo. & goto erreurRepertoireCible)

set REPERTOIRE_CIBLE=%REPERTOIRE_CIBLE%\%dateDossier%
if not exist %REPERTOIRE_CIBLE% (md %REPERTOIRE_CIBLE%)
if errorlevel 1 (echo. & goto erreurRepertoireCible)

set CHEMIN_LOG=%REPERTOIRE_CIBLE%\log.txt

if /i %COMPUTERNAME% NEQ LapTop (
 if /i %COMPUTERNAME% NEQ DESKTOP-TQEQRJF (
  echo Ce script n'est pas prevu pour tourner sur le PC : %COMPUTERNAME%
  goto fin
 )
)

REM ################################
REM ############ Copie. ############
REM ################################

echo. >> %CHEMIN_LOG%
echo %ligneLog% >> %CHEMIN_LOG%
echo %libelleLog% >> %CHEMIN_LOG%
echo %ligneLog% >> %CHEMIN_LOG%
echo. >> %CHEMIN_LOG%
echo. >> %CHEMIN_LOG%
echo Copie en cours...
robocopy %REPERTOIRE_SOURCE% %REPERTOIRE_CIBLE% /E /MAXAGE:%maxage% /NP /R:2 /W:0 >> %CHEMIN_LOG%
echo.
echo Copie termin‚e ;-)
echo.
goto fin

REM ################################################
REM ############ Gestion des exceptions ############
REM ################################################

:erreurRepertoireSource
 echo Erreur d'acces au r‚pertoire source
 echo.
 echo Chemin attendu = %REPERTOIRE_SOURCE%
 echo.
 echo
 echo 1. les variables du fichier bat
 echo 2. si le r‚pertoire source est bien accessible en lecture
 echo.
goto fin

:erreurRepertoireCible
 echo Erreur d'acces au r‚pertoire cible
 echo.
 echo Chemin attendu = %REPERTOIRE_CIBLE%
 echo. 
 echo V‚rifiez :
 echo 1. les variables du fichier bat
 echo 2. si le r‚pertoire cible est bien accessible en ‚criture
 echo. 
goto fin

:fin
echo.
echo ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo º                                                      º
echo º  Appuyez sur une touche pour terminer le script...   º
echo º                                                      º
echo ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ & pause>nul

rem Luckydu43, développeur