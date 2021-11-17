function QCM_start {
    # Nettoyage de la console utilisateur :
    Clear-Host
    # Script de QCM
    $path_q = 'a definir'
    $path_r = 'a definir'
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
        $question = Get-Content 'a definir' | Select-Object -Index $random
        $reponse = Get-Content 'a definir' | Select-Object -Index $random | ForEach-Object { $_.split("=")[1] }
        # Afin de pas avoir plusieurs fois le même question, nous stockons la valeur de la réponse, nous créons un tableau pour le stocker
        $num = Get-Content 'a definir' | Select-Object -Index $random | ForEach-Object { $_.split("=")[0] } 
        Get-Content 'a definir' | Select-Object -Index $random | ForEach-Object { $_.split("=")[0] } >> C:\Users\Hugo\Desktop\num_q.txt 
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
