# Ce fichier est un mode opératoire permettant de mettre à jour un module PowerShell.
#### Le module original est disponible à l'URL suivante : https://www.powershellgallery.com/packages/Subnet/1.0.9/Content/Public%5CGet-Subnet.ps1
<br/>
<br/>

# Sommaire
## 0 - Prérequis
## 1 - Introduction et problématique 
## 2 - Localisation du module après téléchargement
## 3 - Modification du fichier PowerShell
## 4 - Test de validation 
<br />
<br />

## 0 - Prérequis

Pour faire des modifications sur un module, il est nécessaire de posséder ce module. La commande pour installer le module est la suivante : 
```
PS C:\Users\Utilisateur> Install-Module Subnet
```
Il faudra ensuite accéder les conditions de téléchargement.

<br />

## 1 - Introduction et problématique 

Le module PowerShell est un module permettant de récupérer des informations de base sur un réseau donné.
Ces informations peuvent être intéressantes et nous pouvons donc réaliser divers exercices pour tester nos connaissances sur le calcul d'adresse.

Les informations obtenues grâce à ce module sont les suivantes :
> Adresse IP

> Masque de sous-réseau (format int)

> Adresse de sous-réseau

> Masque de sous-réseau (format IP)

> Classe de l'adresse IP

> Plage des IPs

> Adresses disponibles

> Nombre d'adresse allouable

Le problème majeur est que nous souhaitons obtenir la première adresse allouable sur le réseau et la dernière adresse allouable du réseau est que nous obtenons soit
***'l'adresse de sous-réseau - l'adresse de diffusion'*** ou bien sur le module ***'uniquement la première adresse allouable'***.
Cependant, l'adresse de sous-réseau ainsi que l'adresse de diffusion ne sont pas allouables à des machines qui souhaitent se connecter.
Voici comment, sur papier, obtenir ces deux adresses : 
```
Première adresse allouable : adresse-sous-reseau + 1
Dernière adresse allouable : adresse-de-diffusion - 1
```
La suite du document explique comment procéder pour obtenir ces informations. La sortie ressemblera, après modifications à : 
```
PS C:\Users\Utilisateur> Get-Subnet 192.168.10.10 -MaskBits 20

IPAddress        : 192.168.10.10
MaskBits         : 20
NetworkAddress   : 192.168.0.0
BroadcastAddress : 192.168.15.255
SubnetMask       : 255.255.240.0
NetworkClass     : C
Range            : 192.168.0.1 ~ 192.168.15.254
HostAddresses    : {192.168.0.1, 192.168.0.2, 192.168.0.3, 192.168.0.4…}
HostAddressCount : 4094
```
<br />

## 2 - Localisation du module après téléchargement 

Afin d'effectuer quelconque modification, nous devons tout d'abord localiser le fichier du module au format ***'.ps1'***.

Premièrement, nous allons vérifier s'il n'est pas présent au chemin d'installation de base.
Ouvrez un ***shell powershell*** et tapez la commande suivante : 
```
PS C:\Users\Utilisateur> Test-Path C:\Users\Nom_utilisateur\Documents\PowerShell\Modules\Subnet
```
Si le résultat est ***True*** vous pouvez directement passer à l'étape 3.
Cependant, si le résultat est ***False***, il va falloir vous rendre à la racine de votre PC ***(C:\)***. Si vous ouvrez un explorateur de fichier, il vous suffira de cliquer sur 
***"Ce Pc"***. En haut à droite de l'explorateur, vous trouverez une barre de recherche. Saisissez le terme suivant : 
```
Subnet
```
Le dossier que nous souhaitons obtenir porte ce nom à l'identique, double-cliquez dessus.

<br />

## 3 - Modification du fichier PowerShell

Une fois que vous vous êtes placé dans le dossier précédent cité, parcourez les dossiers jusqu'à voir un dossier nommé ***"Public"***. Rendez-vous dans ce 
dossier, vous devriez trouver un fichier nommé ***'Get-Subnet.ps1'***

Ouvrez ce fichier (avec le bloc-notes) et rendez-vous à la ligne ***'114'*** juste en dessous de l'instruction ***'Write-Warning'*** : 
```
else {
            Write-Warning "Host address enumeration was not performed because it would take some time for a /$Mask subnet. `nUse -Force if you want it to occur."
        }
```
Nous allons maintenant pouvoir créer nos deux variables. Juste en dessous de l'accolade fermante, nous allons créer ces deux variables : 
```
$GoodStartHost = Convert-Int64toIP -int $HostStartAddr
$GoodEndHost = Convert-Int64toIP -int $HostEndAddr
```
Une fois ces deux variables crées, nous allons modifier la sortie du script. Rendez-vous juste en dessous au tableau :
```
[pscustomobject]@{
```
Cela correspond à la sortie affichée sur votre shell lorsque nous appelons ***'Get-Subnet'***. Nous allons modifier les variables attribuées à ***'Range'*** : 
```
[pscustomobject]@{
            IPAddress        = $IPAddr
            MaskBits         = $Mask
            NetworkAddress   = $NetworkAddr
            BroadcastAddress = $broadcastaddr
            SubnetMask       = $MaskAddr
            NetworkClass     = $Class
            Range            = "$GoodStartHost ~ $GoodEndHost"
            HostAddresses    = $HostAddresses
            HostAddressCount = $HostAddressCount
        }
```
Nous pouvons maintenant sauvegarder nos modifications et quitter notre bloc-notes.

<br />

## 4 - Test de validation 

Nous allons maintenant tester les modifications apportées. Ouvrez un terminal PowerShell et lancez une commande Subnet de test :
```
PS C:\Users\Utilisateur> Get-Subnet 192.168.10.10 -MaskBits 20
```
La sortie devrait donc contenir un ***'Range'*** identique à celui ci-dessous :
```
Range            : 192.168.0.1 ~ 192.168.15.254
```

Le problème de première IP allouable et dernière IP allouable est maintenant réglé !
