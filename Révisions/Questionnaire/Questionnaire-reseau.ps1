function QCM_start {
    # Nettoyage de la console utilisateur :
    Clear-Host
    # Script de QCM
    $path_q = 'a definir' # Selon l'emplacement de stockage de votre fichier questions.txt
    $path_r = 'a definir' # Selon l'emplacement de stockage de votre fichier reponse.txt
    $boucle = Read-Host "> Combien de question(s) voulez-vous ?"
    if ($boucle -eq "" -or $boucle -eq $null)
    {
        # Pas de valeur pour la variable, on donne une valeur par défaut / 10 questions :
        $boucle = 10
    }
    
    for ($i = 0; $i -lt $boucle; $i++)
    {
        # On procéde au traitement :
        $random = Get-Random -Minimum 1 -Maximum 43
        # Recup. question et rép.
        $question = Get-Content $path_q | Select-Object -Index $random
        $reponse = Get-Content $path_r | Select-Object -Index $random | ForEach-Object { $_.split("=")[1] }
        # Afin de pas avoir plusieurs fois le même question, nous stockons la valeur de la réponse, nous créons un tableau pour le stocker
        $num = Get-Content $path_r | Select-Object -Index $random | ForEach-Object { $_.split("=")[0] } 
        $stock_num = @()
        if( $stock_num -notcontains $num) {
            # La valeur n'est pas présente dans le tableau, nous pouvons donc poser la question :
            Write-Host "Question $($i) : $($question)" -ForegroundColor Yellow
            Read-Host -Prompt ">"
            Write-Host "Réponse : $($reponse)" -ForegroundColor Green
            Write-Host ""
            Write-Host ""
            # Nous plaçons maintenant cette valeur (numéro de question dans le tableau) :
            $stock_num += $num
        }       
    }
}

QCM_start
