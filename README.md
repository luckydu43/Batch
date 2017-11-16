# Batch

Ces fichiers sont des fichiers .bat, tournant donc sur un environnement Windows.
Les accès distants ont été testés sur du NTFS. Vu ce que j'utilise, ça devrait marcher aussi avec FAT/FAT32, à voir.
Ils n'ont pas été testés pour taper sur du UNIX distant.

- Sauvegarde incrémentale est un outil batch qu'il est préférable de joindre à une tâche programmée (journalière de par sa configuration actuelle) pour sauvegarder un répertoire placé en local ou sur le réseau (cf la conf utilisée dans HardCopy.bat pour cela) de manière incrémentale : seuls les fichiers modifiés depuis le dernier jour ouvrable (cf %MAXAGE% dans le fichier .bat) sont placés dans un répertoire daté du jour de la copie.
Cela m'avait été demandé par un webmaster, pour sauvegarder les données de son site web sans tout copier.

- Hard Copy.bat est un outil de copie qui a pour but pour copier des données depuis un serveur distant (ou un répertoire local, ça marche aussi) alors que la ressource distante est capricieuse.
Il est donc capable (après relance) de ne copier que ce qui manque.
J'y ai intégré de la sécurité (le nom de l'ordinateur distant doit être dans la "liste" intégrée au fichier. Si vous avez besoin d'une liste blanche plus grande, cf ScriptRoute.bat (V3 à l'heure où j'écris ces mots) qui ne devrait pas tarder à arriver), une gestion d'exceptions, du logging (log.txt)
En clair... si ça plante vous le saurez parce que c'est logué dans le log.txt. Et si ça marche vous le saurez aussi ;-)
En attente d'intégrer une automatisation de la relance (robocopy  n'a pas l'air de renvoyer un code erreur via errorlevel...)
