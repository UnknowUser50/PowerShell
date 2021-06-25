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
