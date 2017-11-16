@echo off
SETLOCAL ENABLEdelayedExpansion
title Script de Copie r‚siliente
color 0a
echo.
echo ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo º                            º
echo º Script de Copie r‚siliente º
echo º                            º
echo ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
echo.

REM #######################################################
REM ##################### Paramètres ######################
REM #######################################################

REM Definir ces variables !!!
REM   	      |
REM          \|/
REM	      *
REM
if not exist W:\ net use w: \\169.254.171.123\volume1 >nul
set REPERTOIRE_SOURCE=W:\
set REPERTOIRE_CIBLE=C:\HDD
REM
REM	      ^
REM	     /|\
REM           |

set libelleLog= Copie lancée le %Date% à %Time%
set ligneLog=----------------------------------
set dateDossier=%date:~6,4%%date:~3,2%%date:~0,2%

REM ########################################
REM ############ Tests initiaux ############
REM ########################################

cd %REPERTOIRE_SOURCE%
if errorlevel 1 (echo. & goto erreurRepertoireSource)

if not exist %REPERTOIRE_CIBLE% (echo. & goto erreurRepertoireCible)
:retourCreationRepertoire
set REPERTOIRE_CIBLE=%REPERTOIRE_CIBLE%\
if not exist %REPERTOIRE_CIBLE% (md %REPERTOIRE_CIBLE%)
if errorlevel 1 (echo. & goto erreurRepertoireCible)

set CHEMIN_LOG=%REPERTOIRE_CIBLE%\log.txt

if /i %COMPUTERNAME% NEQ LapTop (
 if /i %COMPUTERNAME% NEQ DESKTOP-TQEQRJF (
  if /i %COMPUTERNAME% NEQ desktop-00bfln2 (
  echo Ce script n'est pas prevu pour tourner sur le PC : %COMPUTERNAME%
  goto fin
  )
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
robocopy %REPERTOIRE_SOURCE% %REPERTOIRE_CIBLE% /E /NP /R:2 /W:0 >> %CHEMIN_LOG%
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
 echo V‚rifiez :
 echo 1. les variables du fichier bat
 echo 2. si le r‚pertoire source est bien accessible en lecture
 echo.
goto fin

:erreurRepertoireCible
 echo Attention : le r‚pertoire cible n'existe pas encore !
 echo.
 echo Chemin attendu = %REPERTOIRE_CIBLE%
 echo.
 echo Si vous voulez continuer,
 pause
goto retourCreationRepertoire

:fin
echo.
echo ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo º                                                      º
echo º  Appuyez sur une touche pour terminer le script...   º
echo º                                                      º
echo ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ & pause>nul

REM ######## Luckydu43, développeur ########