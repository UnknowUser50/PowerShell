# Installation du module :
Install-Module Subnet
# Désactivation des erreurs et des barres de progression :
$ProgressPreference = 'silentlyContinue'
$ErrorActionPreference = 'silentlyContinue'
# Lavage : 
Clear-Host
# On étable le score à 0
$score = 0

# Création du menu :
Write-Host ""
Write-Host "          [ - Révision Licence Pro : Administration et sécurité - ]        " -ForegroundColor Yellow
Write-Host "                    [ - Base des réseaux informatique - ]                  " -ForegroundColor Yellow
Write-Host "          ---------------------------------------------------------        " -ForegroundColor Yellow
Write-Host "                                                                           "
Write-Host "          > 1 < - Mode Touriste   : 10 IPs                                 " -ForegroundColor Green
Write-Host "          > 2 < - Mode Challenger : 20 IPs                                 " -ForegroundColor Green
Write-Host "          > 3 < - Mode TryHarder  : 30 IPs                                 " -ForegroundColor Green
Write-Host "          > 4 < - Mode Training   : Au choix                               " -ForegroundColor Green
Write-Host "                                                                           "
Write-Host "          > 0 < - Quitter le script                                        " -ForegroundColor Red
Write-Host "                                                                           "
$get_module = Read-Host "          > Votre module "

# Déclaration des fonctions :
function touriste
{
    # Nettoyage :
    Clear-Host
    # Affichage des consignes : 
    Write-Host "" -ForegroundColor Green
    Write-Host "> Pour chaque adresse IP qui s'affichera, vous devrez donner : " -ForegroundColor Green
    Write-Host "     => La classe de l'adresse I.P" -ForegroundColor Yellow
    Write-Host "     => L'adresse de sous réseau de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => L'adresse de diffusion de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => La première adresse I.P (@SSR comptéée) " -ForegroundColor Yellow
    Write-Host "     => La dernière adresse I.P (Broadcast comptéée) " -ForegroundColor Yellow
    Write-Host "     => Le nombre de machine utilisable dans le réseau" -ForegroundColor Yellow
    Write-Host "Pour ce module, vous devrez obtenir la note minimale de 7/10 pour le valider" -ForegroundColor Green
    Write-Host "* L'utilisation de la caculatrice est autorisée" -ForegroundColor Gree
    Write-Host "=> Bonne chance" -ForegroundColor Red
    Write-Host ""
    Write-Host ""
    for ($i = 0; $i -le 10; $i++)
    {
        # Nous préparons les variables : 
        $octet1 = Get-Random -Minimum 0 -Maximum 254
        $octet2 = Get-Random -Minimum 0 -Maximum 254
        $octet3 = Get-Random -Minimum 0 -Maximum 254
        $octet4 = Get-Random -Minimum 0 -Maximum 254
        $masque = Get-Random -Minimum 17 -Maximum 32
        $adresse = "$($octet1).$($octet2).$($octet3).$($octet4)"
        # Variables utiles à la correction, les putains de REGEX de merde
        $class = Get-Subnet $adresse -MaskBits $masque | findstr "NetworkClass" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " } 
        $ssr = Get-Subnet $adresse -MaskBits $masque  | findstr "NetworkAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " }         
        $range1 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[0] } | ForEach-Object { $_.Trim() -replace "" }
        $range2 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $broadcast = Get-Subnet $adresse -MaskBits $masque | findstr "BroadcastAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $nb_machine = Get-Subnet $adresse -MaskBits $masque | findstr "HostAddressCount" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }

        Write-Host "Numéro $($i) : $($adresse)/$($masque)" -ForegroundColor Yellow
        # Questionnement utilisateur : 
        $user_class = Read-Host "> Classe de l'adresse I.P "
        $user_subnet = Read-Host "> Sous réseau de l'adresse I.P"
        $user_diffusion = Read-Host "> Adresse de diffusion "
        $user_first = Read-Host "> Première I.P "
        $user_last = Read-Host "> Dernière I.P "
        $user_compute = Read-Host "> Nombre de machine possible "

        # Correction :
        Write-Host
        Write-Host "-------------------------- Correction ---------------------------------"
        Write-Host "Classe => Votre réponse : $($user_class)        - La réponse attendue : $($class)" -ForegroundColor Blue
        Write-Host "Sous réseau => Votre réponse : $($user_subnet)   - La réponse attendue : $($ssr)" -ForegroundColor Blue
        Write-Host "Diffusion => Votre réponse : $($user_diffusion)     - La réponse attendue : $($broadcast)" -ForegroundColor Blue
        Write-Host "Première => Votre réponse : $($user_first)      - La réponse attendue : $($range1)" -ForegroundColor Blue
        Write-Host "Dernière => Votre réponse : $($user_last)      - La réponse attendue : $($range2)" -ForegroundColor Blue
        Write-Host "Machine => Votre réponse : $($user_compute)       - La réponse attendue : $($nb_machine)" -ForegroundColor Blue
        Write-Host ""
        Write-Host ""

        # On vérifie 
        if($user_class -eq $class -and $user_subnet -eq $ssr -and $user_diffusion -eq $broadcast -and $user_first -eq $range1 -and $user_last -eq $range2 -and $user_compute -eq $nb_machine)
        {
            $score++
        }
    }
    Write-Host "> Votre score : $($score)" -ForegroundColor DarkYellow

}

function challenger
{
    # Nettoyage :
    Clear-Host
    # Affichage des consignes : 
    Write-Host "" -ForegroundColor Green
    Write-Host "> Pour chaque adresse IP qui s'affichera, vous devrez donner : " -ForegroundColor Green
    Write-Host "     => La classe de l'adresse I.P" -ForegroundColor Yellow
    Write-Host "     => L'adresse de sous réseau de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => L'adresse de diffusion de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => La première adresse I.P (@SSR comptéée) " -ForegroundColor Yellow
    Write-Host "     => La dernière adresse I.P (Broadcast comptéée) " -ForegroundColor Yellow
    Write-Host "     => Le nombre de machine utilisable dans le réseau" -ForegroundColor Yellow
    Write-Host "Pour ce module, vous devrez obtenir la note minimale de 7/10 pour le valider" -ForegroundColor Green
    Write-Host "* L'utilisation de la caculatrice est autorisée" -ForegroundColor Gree
    Write-Host "=> Bonne chance" -ForegroundColor Red
    Write-Host ""
    Write-Host ""
    for ($i = 0; $i -le 20; $i++)
    {
        # Nous préparons les variables : 
        $octet1 = Get-Random -Minimum 0 -Maximum 254
        $octet2 = Get-Random -Minimum 0 -Maximum 254
        $octet3 = Get-Random -Minimum 0 -Maximum 254
        $octet4 = Get-Random -Minimum 0 -Maximum 254
        $masque = Get-Random -Minimum 17 -Maximum 32
        $adresse = "$($octet1).$($octet2).$($octet3).$($octet4)"
        # Variables utiles à la correction
        $class = Get-Subnet $adresse -MaskBits $masque | findstr "NetworkClass" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " } 
        $ssr = Get-Subnet $adresse -MaskBits $masque  | findstr "NetworkAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " }         
        $range1 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[0] } | ForEach-Object { $_.Trim() -replace "" }
        $range2 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $broadcast = Get-Subnet $adresse -MaskBits $masque | findstr "BroadcastAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $nb_machine = Get-Subnet $adresse -MaskBits $masque | findstr "HostAddressCount" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }

        Write-Host "Voici la $($i) I.P : $($adresse)/$($masque)" -ForegroundColor Yellow
        # Questionnement utilisateur : 
        $user_class = Read-Host "> Classe de l'adresse I.P "
        $user_subnet = Read-Host "> Sous réseau de l'adresse I.P"
        $user_diffusion = Read-Host "> Adresse de diffusion "
        $user_first = Read-Host "> Première I.P "
        $user_last = Read-Host "> Dernière I.P "
        $user_compute = Read-Host "> Nombre de machine possible "

        # Correction :
        Write-Host
        Write-Host "-------------------------- Correction ---------------------------------"
        Write-Host "Classe => Votre réponse : $($user_class)        - La réponse attendue : $($class)" -ForegroundColor Blue
        Write-Host "Sous réseau => Votre réponse : $($user_subnet)   - La réponse attendue : $($ssr)" -ForegroundColor Blue
        Write-Host "Diffusion => Votre réponse : $($user_diffusion)     - La réponse attendue : $($broadcast)" -ForegroundColor Blue
        Write-Host "Première => Votre réponse : $($user_first)      - La réponse attendue : $($range1)" -ForegroundColor Blue
        Write-Host "Dernière => Votre réponse : $($user_last)      - La réponse attendue : $($range2)" -ForegroundColor Blue
        Write-Host "Machine => Votre réponse : $($user_compute)       - La réponse attendue : $($nb_machine)" -ForegroundColor Blue
        Write-Host ""
        Write-Host ""

        # On vérifie 
        if($user_class -eq $class -and $user_subnet -eq $ssr -and $user_diffusion -eq $broadcast -and $user_first -eq $range1 -and $user_last -eq $range2 -and $user_compute -eq $nb_machine)
        {
            $score++
        }
    }
    Write-Host "> Votre score : $($score)" -ForegroundColor DarkYellow
}

function tryharder
{
    # Nettoyage :
    Clear-Host
    # Affichage des consignes : 
    Write-Host "" -ForegroundColor Green
    Write-Host "> Pour chaque adresse IP qui s'affichera, vous devrez donner : " -ForegroundColor Green
    Write-Host "     => La classe de l'adresse I.P" -ForegroundColor Yellow
    Write-Host "     => L'adresse de sous réseau de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => L'adresse de diffusion de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => La première adresse I.P (@SSR comptéée) " -ForegroundColor Yellow
    Write-Host "     => La dernière adresse I.P (Broadcast comptéée) " -ForegroundColor Yellow
    Write-Host "     => Le nombre de machine utilisable dans le réseau" -ForegroundColor Yellow
    Write-Host "Pour ce module, vous devrez obtenir la note minimale de 7/10 pour le valider" -ForegroundColor Green
    Write-Host "* L'utilisation de la caculatrice est autorisée" -ForegroundColor Gree
    Write-Host "=> Bonne chance" -ForegroundColor Red
    Write-Host ""
    Write-Host ""
    for ($i = 0; $i -le 20; $i++)
    {
        # Nous préparons les variables : 
        $octet1 = Get-Random -Minimum 0 -Maximum 254
        $octet2 = Get-Random -Minimum 0 -Maximum 254
        $octet3 = Get-Random -Minimum 0 -Maximum 254
        $octet4 = Get-Random -Minimum 0 -Maximum 254
        $masque = Get-Random -Minimum 17 -Maximum 32
        $adresse = "$($octet1).$($octet2).$($octet3).$($octet4)"
        # Variables utiles à la correction
        $class = Get-Subnet $adresse -MaskBits $masque | findstr "NetworkClass" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " } 
        $ssr = Get-Subnet $adresse -MaskBits $masque  | findstr "NetworkAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " }         
        $range1 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[0] } | ForEach-Object { $_.Trim() -replace "" }
        $range2 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $broadcast = Get-Subnet $adresse -MaskBits $masque | findstr "BroadcastAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $nb_machine = Get-Subnet $adresse -MaskBits $masque | findstr "HostAddressCount" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }

        Write-Host "Voici la $($i) I.P : $($adresse)/$($masque)" -ForegroundColor Yellow
        # Questionnement utilisateur : 
        $user_class = Read-Host "> Classe de l'adresse I.P "
        $user_subnet = Read-Host "> Sous réseau de l'adresse I.P"
        $user_diffusion = Read-Host "> Adresse de diffusion "
        $user_first = Read-Host "> Première I.P "
        $user_last = Read-Host "> Dernière I.P "
        $user_compute = Read-Host "> Nombre de machine possible "

        # Correction :
        Write-Host
        Write-Host "-------------------------- Correction ---------------------------------"
        Write-Host "Classe => Votre réponse : $($user_class)        - La réponse attendue : $($class)" -ForegroundColor Blue
        Write-Host "Sous réseau => Votre réponse : $($user_subnet)   - La réponse attendue : $($ssr)" -ForegroundColor Blue
        Write-Host "Diffusion => Votre réponse : $($user_diffusion)     - La réponse attendue : $($broadcast)" -ForegroundColor Blue
        Write-Host "Première => Votre réponse : $($user_first)      - La réponse attendue : $($range1)" -ForegroundColor Blue
        Write-Host "Dernière => Votre réponse : $($user_last)      - La réponse attendue : $($range2)" -ForegroundColor Blue
        Write-Host "Machine => Votre réponse : $($user_compute)       - La réponse attendue : $($nb_machine)" -ForegroundColor Blue
        Write-Host ""
        Write-Host ""

        # On vérifie 
        if($user_class -eq $class -and $user_subnet -eq $ssr -and $user_diffusion -eq $broadcast -and $user_first -eq $range1 -and $user_last -eq $range2 -and $user_compute -eq $nb_machine)
        {
            $score++
        }
    }
    Write-Host "> Votre score : $($score)" -ForegroundColor DarkYellow
}

function training
{
# Nettoyage :
    Clear-Host
    $nb = Read-Host "> Combien d'IP "
    # Nettoyage :
    Clear-Host
    # Affichage des consignes : 
    Write-Host "" -ForegroundColor Green
    Write-Host "> Pour chaque adresse IP qui s'affichera, vous devrez donner : " -ForegroundColor Green
    Write-Host "     => La classe de l'adresse I.P" -ForegroundColor Yellow
    Write-Host "     => L'adresse de sous réseau de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => L'adresse de diffusion de l'adresse I.P " -ForegroundColor Yellow
    Write-Host "     => La première adresse I.P (@SSR comptéée) " -ForegroundColor Yellow
    Write-Host "     => La dernière adresse I.P (Broadcast comptéée) " -ForegroundColor Yellow
    Write-Host "     => Le nombre de machine utilisable dans le réseau" -ForegroundColor Yellow
    Write-Host "Pour ce module, vous devrez obtenir la note minimale de 7/10 pour le valider" -ForegroundColor Green
    Write-Host "* L'utilisation de la caculatrice est autorisée" -ForegroundColor Gree
    Write-Host "=> Bonne chance" -ForegroundColor Red
    Write-Host ""
    Write-Host ""
    for ($i = 0; $i -le $nb; $i++)
    {
        # Nous préparons les variables : 
        $octet1 = Get-Random -Minimum 0 -Maximum 254
        $octet2 = Get-Random -Minimum 0 -Maximum 254
        $octet3 = Get-Random -Minimum 0 -Maximum 254
        $octet4 = Get-Random -Minimum 0 -Maximum 254
        $masque = Get-Random -Minimum 17 -Maximum 32
        $adresse = "$($octet1).$($octet2).$($octet3).$($octet4)"
        # Variables utiles à la correction
        $class = Get-Subnet $adresse -MaskBits $masque | findstr "NetworkClass" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " } 
        $ssr = Get-Subnet $adresse -MaskBits $masque  | findstr "NetworkAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace " " }         
        $range1 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[0] } | ForEach-Object { $_.Trim() -replace "" }
        $range2 = Get-Subnet $adresse -MaskBits $masque | findstr "Range" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.split("~")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $broadcast = Get-Subnet $adresse -MaskBits $masque | findstr "BroadcastAddress" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }
        $nb_machine = Get-Subnet $adresse -MaskBits $masque | findstr "HostAddressCount" | ForEach-Object { $_.split(":")[1] } | ForEach-Object { $_.Trim() -replace "" }

        Write-Host "Voici la $($i) I.P : $($adresse)/$($masque)" -ForegroundColor Yellow
        # Questionnement utilisateur : 
        $user_class = Read-Host "> Classe de l'adresse I.P "
        $user_subnet = Read-Host "> Sous réseau de l'adresse I.P"
        $user_diffusion = Read-Host "> Adresse de diffusion "
        $user_first = Read-Host "> Première I.P "
        $user_last = Read-Host "> Dernière I.P "
        $user_compute = Read-Host "> Nombre de machine possible "

        # Correction :
        Write-Host
        Write-Host "-------------------------- Correction ---------------------------------"
        Write-Host "Classe => Votre réponse : $($user_class)        - La réponse attendue : $($class)" -ForegroundColor Blue
        Write-Host "Sous réseau => Votre réponse : $($user_subnet)   - La réponse attendue : $($ssr)" -ForegroundColor Blue
        Write-Host "Diffusion => Votre réponse : $($user_diffusion)     - La réponse attendue : $($broadcast)" -ForegroundColor Blue
        Write-Host "Première => Votre réponse : $($user_first)      - La réponse attendue : $($range1)" -ForegroundColor Blue
        Write-Host "Dernière => Votre réponse : $($user_last)      - La réponse attendue : $($range2)" -ForegroundColor Blue
        Write-Host "Machine => Votre réponse : $($user_compute)       - La réponse attendue : $($nb_machine)" -ForegroundColor Blue
        Write-Host ""
        Write-Host ""

        # On vérifie 
        if($user_class -eq $class -and $user_subnet -eq $ssr -and $user_diffusion -eq $broadcast -and $user_first -eq $range1 -and $user_last -eq $range2 -and $user_compute -eq $nb_machine)
        {
            $score++
        }
    }
    Write-Host "> Votre score : $($score)" -ForegroundColor DarkYellow
}

switch ($get_module)
{
    1 { touriste }
    2 { challenger }
    3 { tryharder }
    4 { training }
    0 { exit }
    default { Write-Host "          > Pas de module !" }
}
