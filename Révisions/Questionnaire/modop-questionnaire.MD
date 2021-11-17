# Télécharger et préparer le script pour le questionnaire de réseau
 
## Etape 1
 
 Il suffira tout d'abord de télécharger le script powershell, de le placer dans un bloc-notes et de lui donner l'extension '.ps1'
 > Enregistrer sous > nom = quest-reseau.ps1

Comme pour le script sur l'adressage IP, il existe deux manières d'exécuter le script powershell : 
1 - Lancer un ***shell admnistrateur***, se déplacer dans le répertoire où est stocké le script, puis l'exécuter.
```
cd C:\Users\...\
```
```
.\Questionnaire-reseau.ps1
```

2 - Préparer un fichier à l'extension ***'.bat'***. Il est possible de créer un ***'.bat'*** depuis un bloc-notes. 
Si vous décidez d'utiliser cette technique, voici la ligne de commande à saisir dans le bloc-notes :
```
powershell.exe -file C:\Users\...{chemin_dossier_dest}...\Questionnaire-reseau.ps1
```
Il suffira ensuite d'enregistrer vos modifications sous l'extension ***'.bat'***. Une fois cela fait, la dernière étape
consiste à exécuter le ***'.bat'*** en tant qu'administrateur.

## Etape 2

Afin de pouvoir générer les questions et les réponses, le script est obligé de fonctionner avec deux fichiers texte qui sont les suivants :
> questions.txt
> reponses.txt 

Ces deux fichiers contiennent respectivement les questions ainsi que les réponses associées.

Pour le bon fonctionnement, deux variables du script vont être à modifier. En effet, les lieux de stockage de ces deux fichiers peuvent
différer d'une machine à une autre. Il convient donc d'effectuer ces modifications.
Pour modifier ces variables, double-cliquez sur le fichier à l'extension ***'.ps1'***. Une fois celui-ci ouvert, vous pourrez apercevoir
deux variables avec comme valeur :
```
$path_q = 'a definir'
$path_r = 'a definir'
```

Laissez les single-quote et comme valeur, placez le chemin (par exemple C:\Users\Test\Desktop\questions.txt) des fichiers nécessaires.
Une fois cela fait, vous pouvez exécuter le script.

## Conclusion

Diverses modifications seront apportées à ce script, des mises à jours ne tarderont pas à arriver.
