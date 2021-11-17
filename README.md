# Scanner PowerShell / v1.0 et v2.0

## Script PowerShell servant à scanner des sous réseaux PREDEFINIS : **scanner.ps1**

Ce script PowerShell peut-être utilisé pour scanner des sous réseaux prédéfinis. Par défaut, pour pouvoir l'utiliser, il suffit simplement de remplacer les plages I.P dans le script par celle désirée par exemple :
* 10.10.10.0
* 20.20.20.0 

Le script va ensuite scanner le réseau indiqué et rechercher les machines connectées à celui-ci. Si une machine est localisée, la bibliothèque de PowerShell **[System.Net.Dns]** va nous permettre de résoudre les noms de machine en fonction l'adresse I.P qu'elles utilisent sur le réseau. 

Les couples obtenus (donc adresse I.P + nom d'hôte) seront sauvegarder dans un fichier texte.

### Globalité : 

Ce script sert à simplement à repérer les machines connectées sur les réseaux indiqués dans le code du script. Ce script peut par exemple être utilisé en entreprise afin de scanner vos réseau et voir qui est connecté. 

## Script PowerSHell servant à scanner des sous réseaux DONNEES : **scannerV2.ps1** 

Ce script PowerShell ne fonctionne pas de la même manière que le précédent. Au début du script, il vous sera proposé de rentrer le nombre VOULU de sous réseau à scanner.
ATTENTION : Les réseaux qui peuvent être scannés doivent être de la forme : 10.10.10.0 soit un réseau de classe C. Il n'est pas nécessaire de placer le masque de sous réseau au moment de saisir les plages.

Une fois les sous réseaux scannés, les adresses de {1..256} seront placées dans un fichier texte dans votre dossier temporaire : /AppData/Local/Temp/{fichier.txt}
Le script va ensuite pouvoir faire comme sa version 1.0 et repérer les machines sur les différents sous réseaux.

==> La version en cour de développement va prévoir de scanner les ports les plus importants sur les machines afin de voir les ports ouverts.

# Script de révision réseau

## Script permettant de générer des adresses IP aléatoire vous permettant de réviser.

Ce script permet de vous entrainer aux calculs d'adresses I.P. Vous aurez 4 modules disponibles sur ce script.
* Le premier vous questionnera sur 10 adresses IP
* Le deuxième vous questionnera sur 20 adresses IP
* Le troisième vous questionnera sur 30 adresses IP
* Le quatrième vous questionnera sur le nombre d'IP de votre choix.

Pour chaque adresse IP vous devrez donner les informations suivantes :
* La classe de l'adresse IP (A,B,C,D...),
* L'adresse de sous réseau,
* L'adresse de diffusion,
* La première adresse I.P (adresse de sous réseau comprise),
* La dernière adresse I.P (adresse de broadcast comprise),
* Le nombre de machines possibles sur le réseau.

# Script questionnaire réseau informatique

Ce script permet de reviser certaines notions sur le réseau informatique pour la préparation d'une évaluation de fin de module.
Un total de 43 questions est pour le moment présent.
