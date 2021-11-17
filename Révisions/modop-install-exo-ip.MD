# Installation sur Windows : 

Tout d'abord, il va falloir récupérer la source du script : 
Copiez-collez le code de mon github sur un bloc-notes. Une fois le code copié-collé, renommé le fichier en "exo-ip.ps1" (Attention, l'extension est très importante)
Sur Windows, il n'est pas possible d'exécuter un script PowerShell en administrateur.
Il existe deux méthodes :

## 1) Ouvrir un terminal en administrateur, rendez-vous où se trouve le fichier .ps1 et exécutez-le.
> cd C:\Users\....
> .\exo-ip.ps1

## 2) Créez un nouveau bloc-notes et tapez le contenu suivant : 
> powershell.exe -file C:\Users\...{chemin_vers_le_script}....\exo-ip.ps1

Enregistrez ce fichier avec l'extension ***.bat***
Une fois le ***.bat*** généré, vous pourrez l'exécuter en tant qu'administrateur.

Il est possible d'installer la bibliothèque nécessaire avant d'exécuter le script powershell.
Pour cela, ouvrez un shell PowerShell et tapez la commande suivante : 
> Install-Module Subnet



Une fois le module installé, vous pouvez tester son fonctionnement en tapant une adresse aléatoire : 
> Get-Subnet 192.168.10.10 -MaskBits 24


Sur cette version, les masques de sous-réseau inférieur à 16 prennent plus de temps à être calculés. Dans le script, les adresses et le masque sont générés
aléatoirement dans une variable. ***Le masque minimum est de 16 et le masque maximum est 32***. 

## Explication du script :

Vous pouvez sélectionner 4 modules différents. Ce qui fait la différence entre chaque module c'est le nombre d'IP qui va être généré. 
Pour chaque adresse générée, vous devrez donner : 
1 - La classe de l'IP (type de réponse attendu : A, B, C...)

2 - L'adresse de sous-réseau (type de réponse attendu : 192.168.0.0) --> sans le masque

3 - L'adresse de diffusion/broadcast (type de réponse attendu : 192.168.255.255)

4 - La première IP allouable sur le réseau : soit -> adresse de sous-réseau  + 1 ***(Etant donné un problème sur la bibliothèque utilisée, la 1ère IP correspond au sous-réseau)***

5 - La dernière IP allouable sur le réseau : soit -> adresse de diffusion - 1 ***(De même que la précédente, le '-1' n'est pas pris en compte dans le code, donc diffusion)***

6 - Le nombre total d'IP allouable sur le réseau à l'aide de : (2^32-masque)-2 (type de réponse attendu : 256)
