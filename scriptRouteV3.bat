@echo off
title Script de d�routage des IPs sniffeuses de Windows 10
color 0a
echo.
echo ������������������������������������������������������ͻ
echo �                                                      �
echo � Script de d�routage des IPs sniffeuses de Windows 10 �
echo �                                                      �
echo ������������������������������������������������������ͼ
echo.
echo ������������������������������������������������������ͻ
echo � En attente de l'�l�vation des droits administrateur  �
echo ������������������������������������������������������ͼ


REM #######################################################
REM ##################### Param�tres ######################
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

REM V�rifie si l'instance est d�j� en �l�vation de droits
:elevation
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM Si l'errorlevel est diff�rent de 0, l'instance n'est pas �lev�e : il faut le faire :-)
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
REM J'en profite pour effacer "discr�tement" mes b�tises (si je les ai faites...) :-D
if exist "%temp%\elevation.vbs" ( del "%temp%\elevation.vbs" )


:effacerTableRoutage
echo.
echo ������������������������������������������������������ͻ
echo � Effacement de la table de routage pr�c�dente         �
echo ������������������������������������������������������ͼ
echo.
route -f


echo.
echo ������������������������������������������������������ͻ
echo � Ajout d'adresses dans la table de routage permanente �
echo ������������������������������������������������������ͼ
echo.

cd %CHEMIN%

REM si le fichier n'existe pas, il y a une lev�e d'exception.
if not exist listeIPv4s.txt (goto erreurFichier)

REM Boucle for parcourant le fichier des IPv4. Chaque ligne du fichier
REM est envoy�e � la m�thode deroutageIPv4.
for /f "delims=" %%i in ('type listeIPv4s.txt') do call :deroutageIPv4 %%i
goto :fin

REM M�thode permettant de cr�er une route correspondant � l'IP en param�tre.
REM TODO : si l'ip est d�j� d�rout�e, la mettre � jour
:deroutageIPv4
SET ip=%1
echo  Adresse %ip%...
route add -p %ip% mask %MASQUE_SOUS_RESEAU_IPv4% %PASSERELLE_BIDON_IPv4%>nul 2>&1
goto :eof

REM Lev�e d'exception en cas d'erreur de lecture du fichier.
:erreurFichier
echo.
echo %cd%
echo.
echo Le fichier source des adresses IPs est introuvable. 
echo V�rifiez que la variable chemin a bien �t� d�finie.

:fin
echo.

echo ������������������������������������������������������ͻ
echo �                                                      �
echo �  Appuyez sur une touche pour terminer le script...   �
echo �                                                      �
echo ������������������������������������������������������ͼ & pause>nul

exit

REM Enjoy !

REM ##########################################################
REM ##########################################################
REM ###################### EXPLICATIONS ######################
REM ##########################################################
REM ##########################################################

REM La commande route exige une �l�vation de droits.

REM La boucle for est en charge de la lecture des IPv4 ligne par
REM ligne dans le fichier listeIPv4s.txt qui doit �tre pr�sent 
REM � la racine du fichier .bat
REM A chaque parcours, la chaine est renvoy�e vers la m�thode
REM pr�sente au label nomm� deroutage.
REM La m�thode deroutage ajoute � la table de routage la passerelle
REM bidon pour chaque ip rencontr�e dans le fichier
REM //et si la ligne est pr�sente, elle est mise � jour ;-)// J'avais essay�, mais la commande route ne permet pas
REM de g�rer les exceptions avec l'errorlevel. Ce sera peut-�tre l'objet d'une future version de ce fichier, 
REM okazou crosoft se mettait � faire du "route add -p IP 255.255.255.255 IP" pour emp�cher l'ajout de futures routes ;-)
REM Point info pour les bidouilleurs : remplacer 'add' par 'change' permet de mettre � jour une route d�j� existante... *sifflote
REM Les constantes sont d�finies en haut de ce fichier, dans la partie 'param�tres'.

REM... symbole � en batch : Alt + 0130
REM symbole � en batch : Alt + 0136

REM TODO : g�rer les adresses IPv6 (liste totalement
REM non exhaustive) que je n'arrives pas encore � bloquer :
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

REM Explication de la commande route utilis�e de la sorte :
REM route permet de d�finir une passerelle pour une adresse
REM IPv4 (IPv6 ? A voir...) donn�e.
REM add -p permet d'ajouter cette route de mani�re permanente.
REM XXX.XXX.XXX.XXX est l'IP condamn�e.
REM mask 255.255.255.255 est le masque de sous-r�seau de 
REM la passerelle.
REM 192.168.32.1 est, chez moi, une ip bidon et inutilis�e.
REM Ce sera donc la passerelle associ�e � l'IP.
REM Utilis�e ainsi, cette commande dit :
REM "toi qui veux aller � XXX.XXX.XXX.XXX, passes donc par
REM 192.168.32.1, l'herbe y est plus verte" ^^

REM OneDrive.exe, explorer.exe, svchost.exe et System sont
REM les processus utilisant les IPs list�es dans le fichier.
REM Si vous utilisez OneDrive... bon courage pour retirer les
REM IPs qui ne vous int�ressent pas dans la liste !
REM Pensez aussi � retirer les IPs que vous utilisez et qui
REM sont dans la liste (serveur, NAS, pc, box, wifi...)

REM Notez que certaines IPs tapent quand m�me... mais m�me
REM si elles tapent : leur connexion est tr�s r�duite.

REM Je pr�cise que cette solution n'est pas efficace � 100%,
REM m�me si 98% est pour moi un tr�s bon r�sultat
REM (�a, c'est la faute aux IPv6 et aux quelques IPv4 non 
REM encore d�rout�es... � vot' bon coeur :-D)
REM Donc si vous mettez ce fichier � jour, si vous l'am�liorez,
REM ou si vous trouvez une autre astuce : je suis int�ress� !
REM "Si tu ne sais pas : demande... si tu sais : partage" ;-)

REM #########################################################
REM #########################################################
REM ###################### REVISIONS ########################
REM #########################################################
REM #########################################################

REM - V1 : simple listing de 15 adresses IPv4.
REM Il fallait copier coller les commandes dans une invite... de commandes. C'est bien, vous suivez ^^
REM - V1.1: 30 IPv4 list�es
REM - V2 : Ex�cutable � lancer � chaque d�marrage du pc.
REM - V2.1 : D�but de la documentation. 58 IPv4 d�rout�es. Modification d�sormais permanente.
REM - V2.2 : Doc compl�te. 71 IPv4 d�rout�es. Quelques IPv6 ajout�es en commentaire TODO.
REM - V3 : Modifs majeures. La liste est d�port�e dans un fichier txt parcouru par une boucle.
REM 117 IPv4 d�rout�es. Oui, �a en fait des serveurs. J'esp�re pour crosoft que certains serveurs
REM disposent de plusieurs points d'entr�e (je pense aux IPs qui se suivent...)
REM Ajout de l'UAC et embellissement de l'interface. Doc plus que compl�te.
REM - V10.0 : Gestion des IPv6 ? ^^