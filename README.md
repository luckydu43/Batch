# Batch

Ces fichiers sont des fichiers .bat, tournant donc sur un environnement Windows.
Les accès distants ont été testés sur du NTFS. Vu ce que j'utilise, ça devrait marcher aussi avec FAT/FAT32, à voir.
Ils n'ont pas été testés pour taper sur du UNIX distant. Ni sur du FTP
Enfin... le FTP c'est en cours, la personne qui m'a demandé de l'aide et à qui j'ai fait HardCopy bûche sur ce problème de connexion FTP à l'heure où j'écris ces mots... un commit dans pas longtemps ?

- Sauvegarde incrémentale est un outil batch qu'il est préférable de joindre à une tâche programmée (journalière de par sa configuration actuelle) pour sauvegarder un répertoire placé en local ou sur le réseau (cf la conf utilisée dans HardCopy.bat pour cela) de manière incrémentale : seuls les fichiers modifiés depuis le dernier jour ouvrable (cf %MAXAGE% dans le fichier .bat) sont placés dans un répertoire daté du jour de la copie.
Cela m'avait été demandé par un webmaster, pour sauvegarder les données de son site web sans tout copier.

- Hard Copy.bat est un outil de copie qui a pour but pour copier des données depuis un serveur distant (ou un répertoire local, ça marche aussi) alors que la ressource distante est capricieuse.
Il est donc capable (après relance) de ne copier que ce qui manque.
J'y ai intégré de la sécurité (le nom de l'ordinateur distant doit être dans la "liste" intégrée au fichier. Si vous avez besoin d'une liste blanche plus grande, cf ScriptRoute.bat (V3 à l'heure où j'écris ces mots) qui ne devrait pas tarder à arriver), une gestion d'exceptions, du logging (log.txt)
En clair... si ça plante vous le saurez parce que c'est logué dans le log.txt. Et si ça marche vous le saurez aussi ;-)
En attente d'intégrer une automatisation de la relance (robocopy  n'a pas l'air de renvoyer un code erreur via errorlevel...)

- ScriptRouteV3.bat... IL FAUT TÉLÉCHARGER listeIPv4s.txt AVEC !

ET... attention, y a du pavay de texte ;-)

ScriptRouteV3 est un utilitaire .bat me permettant d'exclure, via la modification de la table de routage Windows, des IP que j'ai identifiées comme étant des serveurs Microsoft ayant, entre autres je pense, pour but de récupérer l'ensemble des informations "liées à l'amélioration de l'expérience utilisateur" au détriment de sa vie privée. Parce que vu la quantité de données qui partaient, me faites pas croire que c'était que des logs tranquillou :-D

La liste date. Elle a au moins un an. Faudrait voir si elle est encore juste.
De plus, les nouvelles itérations de Windows ont allégé grandement ce sniffage de données ; la pertinence de ce fichier n'est peut-être plus d'actualité.

################## PETITES EXPLICATIONS

La commande route exige une élévation de droits.

La boucle for est en charge de la lecture des IPv4 ligne par
ligne dans le fichier listeIPv4s.txt qui doit être présent dans le répertoire défini à la variable %CHEMIN%
A chaque parcours, la chaine est renvoyée vers la méthode présente au label nommé deroutage.
La méthode deroutage ajoute à la table de routage la passerelle bidon pour chaque ip rencontrée dans le fichier
J'avais essayé de seulement mettre à jour les lignes déjà présentes, mais la commande route ne permet pas
de gérer les exceptions avec l'errorlevel. Ce sera peut-être l'objet d'une future version de ce fichier, okazou crosoft se mettait à faire du "route add -p IP 255.255.255.255 IP" pour empêcher l'ajout de futures routes ;-)
Point info pour les bidouilleurs : placer 'add' par 'change' permet de mettre à jour une route déjà existante... *sifflote
Les constantes sont définies en haut de ce fichier, dans la partie 'paramètres'.

... symbole é en batch : Alt + 0130
symbole ê en batch : Alt + 0136

TODO : gérer les adresses IPv6 (liste totalement
non exhaustive) que je n'arrives pas encore à bloquer :
e000:fc:ffff:ffff:0:0
e000:fc:0:0:300::
e000:fc::800:0💯0
ff02::1:3
ff02::1:2
abc:1:4468:6370:4c65:6173:6549:7041
abc:1:6900:6e00:6700:2d00:7600:6600

################## GROSSES EXPLICATIONS

Explication de la commande route utilisée de la sorte :
route permet de définir une passerelle pour une adresse
IPv4 (IPv6 ? A voir...) donnée.
add -p permet d'ajouter cette route de manière permanente.
XXX.XXX.XXX.XXX est l'IP condamnée.
mask 255.255.255.255 est le masque de sous-réseau de la passerelle.
192.168.32.1 est, chez moi, une ip bidon et inutilisée.
Ce sera donc la passerelle associée à l'IP.
Utilisée ainsi, cette commande dit : "toi qui veux aller à XXX.XXX.XXX.XXX, passes donc par 192.168.32.1, l'herbe y est plus verte" ^^

OneDrive.exe, explorer.exe, svchost.exe et System sont les processus utilisant les IPs listées dans le fichier. Si vous utilisez OneDrive... bon courage pour retirer les IPs qui ne vous intéressent pas dans la liste !
Pensez aussi à retirer les IPs que vous utilisez et qui sont dans la liste (serveur, NAS, pc, box, wifi...)
Notez que certaines IPs tapent quand même... mais même si elles tapent : leur connexion est très réduite.

- stop arriereplan.bat est un outil permettant de détendre Windows. De le rendre plus aimable.
Ça désactive des services "améliorant l'expérience utilisateur", ça configure l'explorateur Windows, désinstalle OneDrive, ajoute des entrées dans le fichier hosts...

- cmd.bat
Vous êtes dans un environnement tellement bridé que le cmd est inaccessible ?
Pas de problème :-D

- Kill process... ou "comment mettre un high-kick à un process qui ne fait que de se lancer encore et encore sans que vous le vouliez ?"

- stop bits.bat ... c'est un .bat sale. Tout ça pour arrêter les processus liés au Background Intelligent Transfer Service...
Mais... je vous en fais cadeau, on sait jamais :-D
