##* ------------------------------------------------------------------------------------------------------
##* Présentation : Le script permettant de regarder les machines connectées sur une plage réseau prédéfinie
##*                Les postes retenus sont redirigés vers un partage pour une analyse ultérieure (A.D)
##*                Le code n'est pas encore automatique (l'ajout des plages I.P est manuel et non auto-
##*                matique.
##*                Afin de ne pas renseigner le nom d'utilisateur, vous pouvez utiliser la variable
##*                d'environnement suivante : '$env:username' qui permet de donner le nom d'utilisateur
##*                qui exécute le script. 
##*
##* Créateur :     Hugo Duparque - Etudiant en informatique / CFA UTEC Marne-la-Vallée
##*
##* Date :         15 juin 2021
##*
##* Version :      1.0 - sans interface graphique
##*
##* Complément :   Ce script est créé pour fonctionner avec un autre script PowerShell. Il ne s'agit là
##*                que de la partie servant à récolter les machines qui seront utilisées sur le deuxième
##*                script PowerShell
##* --------------------------------------------------------------------------------------------------------

function discoveringSubnet {

    ##* ---------------------------------------------------------------------------
    ##* Sous réseau 1 : {...plage des adresses I.P à définir...}
    ##* ---------------------------------------------------------------------------
    
    "" > C:\Users\$env:username\Desktop\liste1.txt
    "" > C:\Users\$env:username\Desktop\liste2.txt

    $ip1 = @()
    $list1 = Get-Content C:\Users\$env:username\AppData\Local\Temp\subnet1.txt

    foreach($data1 in $list1)
    {
        $ip1 += $data1 
    }

    for($a = 0; $a -ne 253; $a++)
    {
       if(Test-Connection $list1[$a] -BufferSize 32 -Count 1 -Quiet)
       {
            $hostname = [System.Net.Dns]::GetHostByAddress($list1[$a]).Hostname
            $hostnameV2 = $hostname | ForEach-Object { $_.split(".")[0] } | ForEach-Object { $_.Trim() -replace "s+" } 
            
            "$($list1[$a]) => $($hostnameV2)" >> C:\Users\$env:username\Desktop\liste1.txt
       } 
    }

    ##* ----------------------------------------------------------------------------
    ##* Sous réseau 2 : {...plage des adresses I.P à définir...}
    ##* ----------------------------------------------------------------------------
    $ip2 = @()
    $list2 = Get-Content C:\Users\$env:username\AppData\Local\Temp\subnet2.txt

    foreach($data2 in $list2)
    {
        $ip2 += $data2
    }

    for($b = 0; $b -ne 254; $b++)
    {
        if(Test-Connection $list2[$b] -BufferSize 32 -Count 1 -Quiet)
        {
            $hostname2 = [System.Net.Dns]::GetHostByAddress($list2[$b]).Hostname
            $hostnameV2_2 = $hostname2 | ForEach-Object { $_.split(".")[0] } | ForEach-Object { $_.Trim() -replace "s+" }

            "$($list2[$b]) => $($hostnameV2_2)" >> C:\Users\$env:username\Desktop\liste2.txt
        }
    }

    ##* ------------------------------------------------------------------------------------------------------------------------

}

function getHostByAddress {

    ##* --------------------------------------------------------------------------------------------------------------------
    ##* Sous réseau 1 : {...plage des adresses I.P à définir...}
    ##* --------------------------------------------------------------------------------------------------------------------

    "" > ##* >> {...chemin partage pour décallage vers l'A.D...}
    
    $nbcouple = Get-Content C:\Users\$env:username\Desktop\liste1.txt
    $tab = @()
    $tab += $nbcouple
    $nb = $nbcouple.Count

    for($y = 0; $y -ne $nb; $y++)
    {
        $prefix = $tab[$y] | ForEach-Object { $_.split(">")[1] } | ForEach-Object { $_.Trim() -replace "s+" }

        if($prefix -match "^à définir selon vos choix" -or $prefix -match "^" -or $prefix -match "^m" -or $prefix -match "^")
        {
            "$($tab[$y])" ##* >> {...chemin partage pour décallage vers l'A.D...}
        }
    }

    ##* -----------------------------------------------------------------------------------------------------------------------
    ##* Sous réseau 2 : {...plage des adresses I.P à définir...}
    ##* -----------------------------------------------------------------------------------------------------------------------

    ##* On vide le fichier pour un nouveau traitement :
    "" > ##* >> {...chemin partage pour décallage vers l'A.D...}

    ##* Création des variables nécessaires :
    $nbcouple2 = Get-Content C:\Users\$env:username\Desktop\liste2.txt
    $tab2 = @()
    $tab2 += $nbcouple2
    $nb2 = $nbcouple2.Count

    ##* Enregistrement :
    for($x = 0; $x -ne $nb2; $x++)
    {
        $prefix2 = $tab2[$x] | ForEach-Object { $_.split(">")[1] } | ForEach-Object { $_.Trim() -replace "s+" }

        if($prefix2 -match "^" -or $prefix -match "^" -or $prefix -match "^" -or $prefix -match "^")
        {
            "$($tab2[$x])" ##* >> {...chemin partage pour décallage vers l'A.D...}
        }
    }
}

discoveringSubnet
getHostByAddress
