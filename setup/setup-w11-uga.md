[< Revenir à la page d'Accueil](../readme.md)

# Configurer une machine UGA (`Windows 11`)

## Etape 1 : Vérifier si Anaconda est installé

Dans le menu Windows, cherchez "Anaconda Prompt". Si vous le trouvez, passez à la deuxième étape.

Si vous ne le trouvez pas, il faut l'installer :

- Téléchargez Anaconda (et pas Miniconda) depuis le [site officiel](https://www.anaconda.com/download/success)
- Lancez l'installation en laissant les options par défaut
- Quand c'est terminé, vérifiez qu'Anaconda Prompt est disponible dans les applications de l'ordinateur

## Etape 2 : Configuration de l'environnement

<details>
<summary>Si vous avez déjà configuré une autre machine UGA, mais pas celle sur laquelle vous vous trouvez actuellement</summary>

Ouvrir un _Terminal_ et lancer :

```
$script = Join-Path $env:TEMP 'intro-python-setup.ps1'
Invoke-WebRequest 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup.ps1' -OutFile $script
Unblock-File $script
& $script --SkipDir
```

Au bout de quelques minutes, on doit voir le message ci-dessous :

> ```bash
> ============================================================
> SETUP OK
> Your Python environment is ready.
> ============================================================
> ```

Votre machine est configurée, vous pouvez fermer le Terminal et quitter cette page.

</details>

<details>
<summary>Si vous n'avez jamais configuré de machine UGA pour ce cours (1ère fois)</summary>

Nous allons créer un dossier de travail qui contiendra l'ensemble des fichiers et travaux du cours. Ce dossier portera le même nom chez tout le monde (`intro-python`). Il sera situé sera situé dans l'espace disque personnel accessible depuis n'importe quel ordinateur UGA.

Dans la barre de recherche windows en bas de l'écran, taper _Terminal_ et lancer l'application Terminal.

Copier-coller la commande suivante et la lancer en appuyant sur la touche entrée :

```powershell
Invoke-RestMethod "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup.ps1" | Invoke-Expression
```

Tant que le curseur en bas du terminal clignote, l'installation est en cours. Au bout de quelques minutes, on doit voir le message ci-dessous :

> ```bash
> ============================================================
> SETUP OK
> Your Python environment is ready.
> ============================================================
> ```

Si cela fonctionne, fermer le terminal.

Si un autre message d'erreur apparaît, appeler l'enseignant.

</details>

## Etape 3 : Localisation du dossier de travail

Pour finir, localiser le dossier `intro-python` sur l'ordinateur :

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur son espace personnel dans les _Emplacements réseaux_. On doit voir le dossier `intro-python`. Si ce n'est pas le cas, appeler l'enseignant.

**Retenir que ce dossier sera le dossier de travail pour tout ce cours.**
