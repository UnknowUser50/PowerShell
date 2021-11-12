<#
    NAME
        ScannerV2.ps1
    SYNOPSIS
        Scanner powershell scannant les machines et les ports ouverts
    SYNTAX
        .\scannerV2.ps1
    DESCRIPTION
        FR.
            Ce script PowerShell permet de scanner différents sous réseaux. Par rapport
            à sa première version, l'utilisateur peut directement choisir lors du
            lancement du script les sous réseaux qu'il va scanner. Une fois le sous réseau
            scanné, chaque fois qu'une machine est connectée, celle-ci sera envoyée dans un
            fichier texte. Les informations envoyées dans ce fichier texte sont :
            * Adresse IP utilisée sur le réseau
            * Nom d'hôte donné par le D.N.S
            Il est possible de scanner plusieurs sous réseaux pendant la même instance du 
            script.
            La seconde partie du script va se charger de scanner les ports des machines
            qui ont été réperées sur le/les réseau(x). Les ports fermés ne seront pas
            affichés. Un tableau prédéfini est déjà initalisé dans le code. Libre à
            vous de modifier ce tableau.
        EN.
            This PowerShell script allows yo uto scan different subnets. Compared to its first
            version, the user can directly choose when launching the script the subnets he will
            scan. Once the subnet is scanned, each time a machine is connected, it will be send
            in a text file. Informations sent in ths text file is :
            * IP Address used on the network
            * Host name given by the D.N.S
            It is possible to scan several subnets during the same instance of the script.
            The second part of the script will take care of scanning ports of machines that have
            been found on the network. Closed ports will not be displayed. A predefined array is
            already initialized in the source code. You are free to modify this array.
    RELATED LINKS
        Github : https://github.com/UnknowUser50/
#>

function INIT {
    if(Test-Path C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt)
    {
        ##* On vide le contenu : 
        Remove-Item C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt
    }

    ##* On place l'affichage des warnings et des progressions en mode silennce
    ##* pour ne pas déranger l'afficher du script. 
    $Global:WarningPreference = 'SilentlyContinue'
    $Global:ProgressPreference = 'SilentlyContinue'
}

##* Nettoyage de la console : 
Clear-Host
function getRouting {

    ##* Fonctin globale -> portée hors de la fonction où elle est déclarée
    $Global:nbSubnetByUser = Read-Host -Prompt "[?] Combien de sous réseau voulez-vous analyser "

    if($Global:nbSubnetByUser -eq 0)
    {
        ##* Alerte : nous ne pouvons pas avoir la valeur 0 donc sortie du script 
        Write-Host "[!] Alerte : Cette variable doit être supérieur à 0 !" -ForegroundColor Red
    }

    ##* Tableau pour la préparation des sous réseau
    $Global:userSubnet = @()
    $entrer = 0

    while($entrer -lt $Global:nbSubnetByUser)
    {
        $Global:userSubnet += Read-Host -Prompt "[?] Entrer le sous-réseau souhaité "
        ##* Si le variable saisie par l'utilisateur est nulle alors : 
        if(!$Global:userSubnet)
        {
            Write-Host "[!] Alerte : Cette variable ne peut pas être nulle !" -ForegroundColor Red
        }
        $entrer++
    }
    ##* On efface les questions posées par le script
    Clear-Host

    for($a = 0; $a -lt $Global:nbSubnetByUser; $a++)
    {
        Write-Host "[*] Le sous-réseau '$($Global:userSubnet[$a])' est déclaré" -ForegroundColor Yellow
    }

}

function tempCreation {

    ##* Création des fichiers temporaires dans le dossier '%TEMP%' de l'utilisateur :
    for($a = 0; $a -lt $global:nbSubnetByUser; $a++)
    {
        ##* Création des fichiers :
        "" > "C:\Users\$($env:USERNAME)\AppData\Local\Temp\subnet$($a).txt"
        ##* Vérification du code retour de la dernière commande : 
        if($? -ne "False")
        {
            Write-Host "[!] Alerte : Le script n'a pas pu créer le(s) fichier(s) contenant les sous-réseaux" -ForegroundColor Red
        }
    }

    ##* Alimentation du contenu des fichiers temporaires :
    $global:TabSubnet = @()
    $prefix = @()

    foreach($data in $Global:userSubnet)
    {
        for($b = 0; $b -lt $global:nbSubnetByUser; $b++)
        {
            $data = $Global:userSubnet[$b] ##* Si ajout de masque CIDR : | ForEach-Object { $_.split("/"[0]) }
            $subWithoutZERO = $data.Substring($data.Length-1,1)
            ##* Si le dernier caractère est bien un zéro alors : 
            if($subWithoutZERO -eq "0")
            {
                ##* On donne à la variable préfix les 3 premiers octets :
                $prefix = $data.Substring(0,$data.Length-1)
                ##* Uitlisé pour débugguer : Write-Host $prefix

                ##* Ajout de la valeur dans le tableau :
                $global:TabSubnet += $prefix
            }
        } 
    }

    ##* Génération des valeurs pour le scan d'adresse I.P
    for($i = 0; $i -ne $global:nbSubnetByUser; $i++)
    {
        for($j = 1; $j -ne 256; $j++)
        {
            "$($global:TabSubnet[$i])$($j)" >> C:\Users\$env:USERNAME\AppData\Local\Temp\subnet$i.txt
        }
    }

    ##* Demande de suppresion de fichiers temporaires :
    #$destroy = Read-Host -Prompt "[+] Voulez-vous supprimer les fichiers temporaires ? (O/n) "
    if($destroy -eq "O" -or $destroy -eq "o")
    {
        ##* Appel de la fonction chargée de la destruction :
        tempDestruction
    }
}

function tempDestruction {

    # On détruit les fichiers temporaires où le contenu des sous réseau est placé :
    for($i = 0; $i -lt $Global:nbSubnetByUser; $i++)
    {
        Remove-Item C:\Users\$env:USERNAME\AppData\Local\Temp\subnet$i.txt
    }
}

function discoveringSubnet {

    Write-Host `n""
    Write-Host "[+]==================== Sortie du script ====================[+]" -ForegroundColor Yellow

    for($i = 0; $i -ne $global:nbSubnetByUser; $i++)
    {
        ##* Création des variables, celle-ci seront reset à chaque fichier de plage trouvé.
        $ip = @()
        $liste = Get-Content C:\Users\$env:username\AppData\Local\Temp\subnet$i.txt

        ##* On boucle pour placer les valeurs trouvées dans le tableau dédié à cet effet.
        foreach($data in $liste)
        {
            $ip += $data
        }

        ##* On affiche les valeurs + test du ping
        for($k = 1; $k -ne 25; $k++)
        {
            ##* Si variable n'est pas nulle alors :
            if($liste[$k])
            {
                if(Test-Connection $liste[$k] -BufferSize 32 -Count 1 -Quiet)
                {
                    ##* On résout les noms en fonction des IPs connectées (DNS) :
                    $hostname = [System.Net.Dns]::GetHostByAddress($liste[$k]).Hostname
                    $hostnameV2 = $hostname | ForEach-Object { $_.split(".")[0] } | ForEach-Object { $_.Trim() -replace "s+" }

                    ##* On place les valeurs récupérées dans un fichier texte pour une sauvegarde :
                    Write-Host "Appareil connecté en : $($liste[$k]) =====> $($hostnameV2)" -ForegroundColor Green
                    "$($liste[$k])==>$($hostnameV2)" >> C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt
                }
            }
        }
    }

    Write-Host "[+]==================== Fin du script ====================[+]" -ForegroundColor Yellow
    Write-Host `n""
    Write-Host "[+]==================== Scan de ports ====================[+]" -ForegroundColor Yellow
    $openPort = Read-Host -Prompt "[?] Voulez-vous scanner les ports des machines récupérées ? [O/n] "

    if($openPort -eq "O" -or $openPort -eq "o" )
    {
        Write-Host "`n"
        Write-Host "[!]==================== Séléction du scan ====================[!]" -ForegroundColor Yellow
        Write-Host "- 1 - Scan classique 65535 ports " -ForegroundColor Yellow
        Write-Host "- 2 - Scan des 1000 premiers ports " -ForegroundColor Yellow
        Write-Host "- 3 - Scan des ports les plus importants " -ForegroundColor Yellow
        Write-Host "`n"
        $choixMenu = Read-Host -Prompt "- ? - Votre choix "

        switch ( $choixMenu )
        {
            1 { ClassicScan }
            2 { 1000Ports }
            3 { fastScan }
            default { Write-Host "[!] Alerte : Ce choix n'est pas possible !" -ForegroundColor Red }
        }
    }
}

function ClassicScan {

    [CmdletBinding()]
    Param(
        $port = @(1..65535),
        [int]$portNB = $port.Count,
        [string]$hostname = $null,
        [int]$timeout = 100
    )

    ##* Variables
    $listeMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split("=")[0]}
    $nomMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split(">")[1] }
    $nombreMachine = $listeMachine.Count

    for($i = 0; $i -ne $nombreMachine; $i++)
    {
        Write-Host "[+] Scan de port sur la machine : $($nomMachine[$i])/$($listeMachine[$i])" -ForegroundColor Yellow
        $requete = $state = $null
        $hostname = $listeMachine[$i]

        ##* Boucle pour les ports :
        for($j = 0; $j -ne $portNB; $j++)
        {
            $nvPort = $port[$j]

            $client = New-Object System.Net.Sockets.TcpClient
            $initConnexion = $client.BeginConnect($hostname,$nvPort,$requete,$state)

            Start-Sleep -milli $timeout

            if($client.Connected) { $open = $true } else { $open = $false }
            $client.Close()
            if($open -eq $true) { Write-Host "`t[+] Le port $($nvPort) est ouvert" -ForegroundColor Green }
        }
    }

    Write-Host "`n[+]==================== Fin du scan ====================[+]`n`n" -ForegroundColor Yellow
    $Global:WarningPreference = 'Continue'
    $Global:ProgressPreference = 'Continue'

    ## Fin du script :
    Read-Host -Prompt "Appuyer sur une touche pour continuer..."

}

function 1000Ports {

    [CmdletBinding()]
    Param(
        [Parameter()]
        [string]$hostname = $null,
        [int]$timeout = 100,
        $port = @(1..1000),
        [int]$portNB = $port.Count
    )

    ##* Variables :
    $listeMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split("=")[0] }
    $nomMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split(">")[1] }
    $nombreMachine = $listeMachine.Count

    for($i = 0; $i -ne $nombreMachine; $i++)
    {
        Write-Host "[+] Scan de port sur la machine : $($nomMachine[$i])/$($listeMachine[$i])" -ForegroundColor Yellow
        $requete = $state = $null
        $hostname = $listeMachine[$i]

        ##* Boucle pour les ports : 
        for($j = 0; $j -ne $portNB; $j++)
        {
            $nvPort = $port[$j]

            $client = New-Object System.Net.Sockets.TcpClient
            $initConnexion = $client.BeginConnect($hostname,$nvPort,$requete,$state)

            Start-Sleep -milli $timeout

            if($client.Connected) { $open = $true } else { $open = $false }
            $client.Close()
            if( $open -eq $true) { Write-Host "`t[+] Le port $($nvPort) est ouvert" -ForegroundColor Green }
        }
    }

    Write-Host "`n[+]==================== Fin du scan ====================[+]`n`n" -ForegroundColor Yellow
    $Global:WarningPreference = 'Continue'
    $Global:ProgressPreference = 'Continue'

    ## Fin du script :
    Read-Host -Prompt "Appuyer sur une touche pour continuer..."

}

function fastScan {

    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$hostname = $null,
        [int]$timeout = 100,
        $port = @(21,22,23,25,53,69,80,88,110,115,161,220,443,464,514,1080,1433,1434,1494,1701,3306,27017),
        [int]$portNB = $port.Count
    )

    $listeMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split("=")[0] }
    $nomMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split(">")[1] }
    $nombreMachine = $listeMachine.Count

    for($i = 0; $i -ne $nombreMachine; $i++)
    {
        Write-Host "[+] Scan des ports sur la machine suivante : $($nomMachine[$i])/$($listeMachine[$i])" -ForegroundColor Yellow
        $requete = $state = $null
        $hostname = $listeMachine[$i]

        ##* Boucle pour les ports : 
        for($y = 0; $y -ne $portNB; $y++)
        {
            $nvPort = $port[$y]

            $client = New-Object System.Net.Sockets.TcpClient
            $initConnexion = $client.BeginConnect($hostname,$nvPort,$requete,$state)
            Start-Sleep -milli $timeout

            if($client.Connected) { $open = $true } else { $open = $false }
            $client.Close()
            if($open -eq $true) { Write-Host "`t[+] Le port $($nvPort) est ouvert" -ForegroundColor Green }
        }
    }
    Write-Host "`n[+]==================== Fin du scan ====================[+]`n`n" -ForegroundColor Yellow

    ## Fin du script :
    Read-Host -Prompt "Appuyer sur une touche pour continuer..."

}

INIT
getRouting
tempCreation
discoveringSubnet
