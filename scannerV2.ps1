function INIT {
    if(Test-Path C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt)
    {
        ##* On vide le contenu : 
        Remove-Item C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt
    }

    $WarningPreference = 'SilentlyContinue'
}

##* Nettoyage de la console : 
Clear-Host
function getRouting {

    ##* Fonctin globale -> portée hors de la fonction où elle est déclarée
    $Global:nbSubnetByUser = Read-Host -Prompt "[+] Combien de sous réseau voulez-vous analyser "

    if($Global:nbSubnetByUser -eq 0)
    {
        ##* Alerte : nous ne pouvons pas avoir la valeur 0 donc sortie du script 
        Write-Host "[!] Alerte : Cette variable doit être supérieur à 0 !"
    }

    ##* Tableau pour la préparation des sous réseau
    $Global:userSubnet = @()
    $entrer = 0

    while($entrer -lt $Global:nbSubnetByUser)
    {
        $Global:userSubnet += Read-Host -Prompt "[+] Entrer le sous-réseau souhaité "
        ##* Si le variable saisie par l'utilisateur est nulle alors : 
        if(!$Global:userSubnet)
        {
            Write-Host "[!] Alerte : Cette variable ne peut pas être nulle !"
        }
        $entrer++
    }

    for($a = 0; $a -lt $Global:nbSubnetByUser; $a++)
    {
        Write-Host "[*] Le sous-réseau '$($Global:userSubnet[$a])' est déclaré"
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
            Write-Host "[!] Alerte : Le script n'a pas pu créer le(s) fichier(s) contenant les sous-réseaux"
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
    Write-Host "[+]==================== Sortie du script ====================[+]"

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
                    Write-Host "Appareil connecté en : $($liste[$k]) =====> $($hostnameV2)"
                    "$($liste[$k])==>$($hostnameV2)" >> C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt
                }
            }
        }
    }
    Write-Host "[+]==================== Fin du script ====================[+]"
    Write-Host `n""
    $openPort = Read-Host -Prompt "[+] Voulez-vous scanner les ports des machines récupérées ? [0/n] "
    if($openPort -eq "O" -or $openPort -eq "o" )
    {
        $OneorTwo = Read-Host -Prompt "[+] Voulez faire un scan de tous les ports ou ceux les plus utilisés ? (1/2)"
        if($OneorTwo -eq "1")
        {
            ##* Appel de la fonction pour scanner tous les ports
            openPorts
        }
        elseif($OneorTwo -eq "2")
        {
            ##* Appel de la fonction pour scanner que les ports les plus utilisées.
            simplePorts
        }
    }
}

function openPorts {

    $listeMachine = Get-Content C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split("=")[0] }
    $nomMachine = Get-Content C:\Users\$env:username\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split(">")[1] }
    $nombreMachine = $listeMachine.Count

    for($c = 0; $c -ne $nombreMachine; $c++)
    {
        Write-Host "[+] Scan de port sur la machine : $($nomMachine[$c])/$($listeMachine[$c])"
        for($p = 1; $p -ne 23; $p++)
        {
            $status = Test-NetConnection -ComputerName $listeMachine[$c] -Port $p | findstr "TcpTestSucceeded" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "s+" }
            if($status -eq "True")
            {
                Write-Host "`t[$($p)] Port $($p) ouvert"
            } 
        }
    }
}

function simplePorts {

    ##* Récuperation des machines scannées sur le réseau : 
    $listeMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split("=")[0] }
    $nomMachine = Get-Content C:\Users\$env:USERNAME\AppData\Local\Temp\machineScannees.txt | ForEach-Object { $_.split(">")[1] }
    $nombreMachine = $listeMachine.Count

    ##* Ports les plus utilisés
    $Global:portService = @(21,22,23,25,53,69,80,88,110,115,161,220,443,464,514,3306) ##* 16
    $Global:portConnu = @(1080,1433,1434,1494,1701,27017) ##* 6

    $nbport = $Global:portService.Count
    $nbportC = $Global:portConnu.Count
    
    ##* On boule déja sur le nombre de machine connectée :
    for($i = 0; $i -ne $nombreMachine; $i++)
    {
        Write-Host "[+] Scan des ports sur la machine suivante : $($nomMachine[$i])/$($listeMachine[$i])"
        ##* Premier tableau de port :
        for($y = 0; $y -ne $nbport; $y++)
        {
            $status = Test-NetConnection -ComputerName $listeMachine[$i] -Port $Global:portService[$y]  | findstr "TcpTestSucceeded" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "s+" }
            if($status -eq "True")
            {
                Write-Host "`t[+] Le port $($Global:portService[$y]) est ouvert"
            }
        }
        ##* Second tableau de port
        for($z = 0; $z -ne $nbportC; $z++)
        {
            $statusBis = Test-NetConnection -ComputerName $listeMachine[$i] -Port $Global:portConnu[$z] | findstr "TcpTestSucceeded" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "s+" }
            if($st
                Write-Host "`t[+] Le port $($Global:portConnu[$z]) est ouvert"
            }
atusBis -eq "True")
            {
        }
    } 

}

INIT
getRouting
tempCreation
discoveringSubnet
$WarningPreference = 'Continue'
