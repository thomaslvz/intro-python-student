[< Revenir à la page d'Accueil](../readme.md)

# Configurer une machine UGA (`Windows 11`)

Sur la pluspart des machines de l'UGA, python est déjà installé. Il faut juste configurer l'environnement de travail.

## Configuration de l'environnement

⚠️**On ne travaille pas dans le dossier de téléchargements ou n'importe-où sur le disque dur.**

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

Si il est écrit qu'il faut installer Anaconda ou Miniconda, aller [ici](https://www.anaconda.com/download/success?reg=skipped), puis télécharger et installer _Anaconda Distribution_. Une fois terminé, relancer la commande ci-dessus.

Si un autre message d'erreur apparaît, appeler l'enseignant.

## Localisation du dossier de travail

Pour finir, localiser le dossier `intro-python` sur l'ordinateur :

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur son espace personnel dans les _Emplacements réseaux_. On doit voir le dossier `intro-python`. Si ce n'est pas le cas, appeler l'enseignant.

**Retenir que ce dossier sera le dossier de travail pour tout ce cours.**
