@echo off
title Script de droutage des IPs sniffeuses de Windows 10
color 0a
echo.
echo ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                                                      บ
echo บ Script de droutage des IPs sniffeuses de Windows 10 บ
echo บ                                                      บ
echo ศออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
echo ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ En attente de l'lvation des droits administrateur  บ
echo ศออออออออออออออออออออออออออออออออออออออออออออออออออออออผ


REM #######################################################
REM ##################### Param่tres ######################
REM #######################################################

set MASQUE_SOUS_RESEAU_IPv4=255.255.255.255
set PASSERELLE_BIDON_IPv4=192.168.32.1

REM Definir cette variable en mettant l'emplacement du fichier listeIPv4.txt (et par la suite listeIPv6.txt ^^)
REM   	      |
REM          \|/
REM	      *	
REM						 /
set CHEMIN=C:\Users\lucky\Desktop      & REM 	<-------
REM						 \
REM	      ^ 				 
REM	     /|\				 
REM           |

REM #######################################################
REM ############ Elevation de droits via l'UAC ############
REM #######################################################

REM V้rifie si l'instance est d้jเ en ้l้vation de droits
:elevation
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM Si l'errorlevel est diff้rent de 0, l'instance n'est pas ้lev้e : il faut le faire :-)
if '%errorlevel%' NEQ '0' (
  goto affichageDelUAC
) else (goto elevationReussie)

REM Lance la popup de l'UAC
:affichageDelUAC
echo Set popupUAC = CreateObject^("Shell.Application"^) > "%temp%\elevation.vbs"
echo popupUAC.ShellExecute "%~s0", "", "", "runas", 1  >> "%temp%\elevation.vbs"
"%temp%\elevation.vbs"
exit /B


:elevationReussie
REM J'en profite pour effacer "discr่tement" mes b๊tises (si je les ai faites...) :-D
if exist "%temp%\elevation.vbs" ( del "%temp%\elevation.vbs" )


:effacerTableRoutage
echo.
echo ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ Effacement de la table de routage prcdente         บ
echo ศออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
route -f


echo.
echo ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ Ajout d'adresses dans la table de routage permanente บ
echo ศออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.

cd %CHEMIN%

REM si le fichier n'existe pas, il y a une lev้e d'exception.
if not exist listeIPv4s.txt (goto erreurFichier)

REM Boucle for parcourant le fichier des IPv4. Chaque ligne du fichier
REM est envoy้e เ la m้thode deroutageIPv4.
for /f "delims=" %%i in ('type listeIPv4s.txt') do call :deroutageIPv4 %%i
goto :fin

REM M้thode permettant de cr้er une route correspondant เ l'IP en param่tre.
REM TODO : si l'ip est d้jเ d้rout้e, la mettre เ jour
:deroutageIPv4
SET ip=%1
echo  Adresse %ip%...
route add -p %ip% mask %MASQUE_SOUS_RESEAU_IPv4% %PASSERELLE_BIDON_IPv4%>nul 2>&1
goto :eof

REM Lev้e d'exception en cas d'erreur de lecture du fichier.
:erreurFichier
echo.
echo %cd%
echo.
echo Le fichier source des adresses IPs est introuvable. 
echo Vrifiez que la variable chemin a bien t dfinie.

:fin
echo.

echo ษออออออออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                                                      บ
echo บ  Appuyez sur une touche pour terminer le script...   บ
echo บ                                                      บ
echo ศออออออออออออออออออออออออออออออออออออออออออออออออออออออผ & pause>nul

exit

REM Enjoy !

REM ##########################################################
REM ##########################################################
REM ###################### EXPLICATIONS ######################
REM ##########################################################
REM ##########################################################

REM La commande route exige une ้l้vation de droits.

REM La boucle for est en charge de la lecture des IPv4 ligne par
REM ligne dans le fichier listeIPv4s.txt qui doit ๊tre pr้sent 
REM เ la racine du fichier .bat
REM A chaque parcours, la chaine est renvoy้e vers la m้thode
REM pr้sente au label nomm้ deroutage.
REM La m้thode deroutage ajoute เ la table de routage la passerelle
REM bidon pour chaque ip rencontr้e dans le fichier
REM //et si la ligne est pr้sente, elle est mise เ jour ;-)// J'avais essay้, mais la commande route ne permet pas
REM de g้rer les exceptions avec l'errorlevel. Ce sera peut-๊tre l'objet d'une future version de ce fichier, 
REM okazou crosoft se mettait เ faire du "route add -p IP 255.255.255.255 IP" pour emp๊cher l'ajout de futures routes ;-)
REM Point info pour les bidouilleurs : remplacer 'add' par 'change' permet de mettre เ jour une route d้jเ existante... *sifflote
REM Les constantes sont d้finies en haut de ce fichier, dans la partie 'param่tres'.

REM... symbole ้ en batch : Alt + 0130
REM symbole ๊ en batch : Alt + 0136

REM TODO : g้rer les adresses IPv6 (liste totalement
REM non exhaustive) que je n'arrives pas encore เ bloquer :
REM e000:fc:ffff:ffff:0:0
REM e000:fc:0:0:300::
REM e000:fc::800:0:100:0
REM ff02::1:3
REM ff02::1:2
REM abc:1:4468:6370:4c65:6173:6549:7041
REM abc:1:6900:6e00:6700:2d00:7600:6600

REM ##########################################################
REM ##########################################################
REM ################## GROSSES EXPLICATIONS ##################
REM ##########################################################
REM ##########################################################

REM Explication de la commande route utilis้e de la sorte :
REM route permet de d้finir une passerelle pour une adresse
REM IPv4 (IPv6 ? A voir...) donn้e.
REM add -p permet d'ajouter cette route de mani่re permanente.
REM XXX.XXX.XXX.XXX est l'IP condamn้e.
REM mask 255.255.255.255 est le masque de sous-r้seau de 
REM la passerelle.
REM 192.168.32.1 est, chez moi, une ip bidon et inutilis้e.
REM Ce sera donc la passerelle associ้e เ l'IP.
REM Utilis้e ainsi, cette commande dit :
REM "toi qui veux aller เ XXX.XXX.XXX.XXX, passes donc par
REM 192.168.32.1, l'herbe y est plus verte" ^^

REM OneDrive.exe, explorer.exe, svchost.exe et System sont
REM les processus utilisant les IPs list้es dans le fichier.
REM Si vous utilisez OneDrive... bon courage pour retirer les
REM IPs qui ne vous int้ressent pas dans la liste !
REM Pensez aussi เ retirer les IPs que vous utilisez et qui
REM sont dans la liste (serveur, NAS, pc, box, wifi...)

REM Notez que certaines IPs tapent quand m๊me... mais m๊me
REM si elles tapent : leur connexion est tr่s r้duite.

REM Je pr้cise que cette solution n'est pas efficace เ 100%,
REM m๊me si 98% est pour moi un tr่s bon r้sultat
REM (็a, c'est la faute aux IPv6 et aux quelques IPv4 non 
REM encore d้rout้es... เ vot' bon coeur :-D)
REM Donc si vous mettez ce fichier เ jour, si vous l'am้liorez,
REM ou si vous trouvez une autre astuce : je suis int้ress้ !
REM "Si tu ne sais pas : demande... si tu sais : partage" ;-)

REM #########################################################
REM #########################################################
REM ###################### REVISIONS ########################
REM #########################################################
REM #########################################################

REM - V1 : simple listing de 15 adresses IPv4.
REM Il fallait copier coller les commandes dans une invite... de commandes. C'est bien, vous suivez ^^
REM - V1.1: 30 IPv4 list้es
REM - V2 : Ex้cutable เ lancer เ chaque d้marrage du pc.
REM - V2.1 : D้but de la documentation. 58 IPv4 d้rout้es. Modification d้sormais permanente.
REM - V2.2 : Doc compl่te. 71 IPv4 d้rout้es. Quelques IPv6 ajout้es en commentaire TODO.
REM - V3 : Modifs majeures. La liste est d้port้e dans un fichier txt parcouru par une boucle.
REM 117 IPv4 d้rout้es. Oui, ็a en fait des serveurs. J'esp่re pour crosoft que certains serveurs
REM disposent de plusieurs points d'entr้e (je pense aux IPs qui se suivent...)
REM Ajout de l'UAC et embellissement de l'interface. Doc plus que compl่te.
REM - V10.0 : Gestion des IPv6 ? ^^