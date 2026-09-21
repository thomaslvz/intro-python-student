# Introduction à python [draft]

## Setup (sur les machines UGA - `Windows 11`)

### Installer Miniconda

Télécharger Miniconda depuis le [site officiel](https://www.anaconda.com/download/success), et suivre les instructions d'installation.

En particulier, on cochera les options suivantes:
- install for : just me
- PATH (⚠️à détailler)

### Création du dossier de travail 

**Très important : on ne travaille pas dans le dossier de téléchargements ou n'importe où sur le disque dur.** Nous allons créer un dossier de travail qui contiendra l'ensemble des fichiers nécessaires au cours. Ce dossier portera le même nom chez tout le monde : `intro-python`, et sera situé dans l'espace disque personnel de chacun.e.

- Dans la barre de recherche windows en bas de l'écran, taper *Terminal*, et lancer l'application Terminal.
- Copier coller la commande suivante et la lancer en appuyant sur la touche entrée :
    ```powershell
    Invoke-RestMethod "https://raw.githubusercontent.com/maslvz/intro-python-student/refs/heads/main/setup/setup-w11-UGA.ps1" | Invoke-Expression
    ```
    Cela va configurer python et créer un dossier de travail pour ce cours.
    
    Tant que le curseur en bas du terminal clignote, l'installation est en cours. Au bout de quelques minutes, vous devez voir le message ci-dessous :
    > ```bash
    > ============================================================
    > SETUP OK
    > Your Python environment is ready.
    > ============================================================
    > ```
    Si cela ne fonctionne pas, appeler l'enseignant. Si cela fonctionne, fermer le terminal.

- Localiser le dossier `intro-python` sur l'ordinateur : ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur son espace personnel dans les *Emplacements réseaux*. Vous devez voir le dossier `intro-python`. Si ce n'est pas le cas, appeler l'enseignant

## Setup (sur une machine perso)
à compléter, distinguer mac/pc


