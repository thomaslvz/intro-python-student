[< Revenir à la page d'Accueil](../readme.md)

# Configurer sa machine perso (`Windows 11`)

NB : si vous êtes sur une machine perso tournant sur Windows 10, il est conseillé d'utiliser plutôt les machines de l'UGA. En effet, les mises à jours de sécurité [ne sont plus publiées pour Windows 10](https://www.microsoft.com/fr-fr/windows/end-of-support), ce qui représente un risque.

## Etape 1 : Vérifier si Anaconda est installé

Dans le menu Windows, cherchez "Anaconda PowerShell Prompt". Si vous le trouvez, passez à la deuxième étape.

Si vous ne le trouvez pas, il faut l'installer :

- Téléchargez Anaconda ou Miniconda depuis le [site officiel](https://www.anaconda.com/download/success). Les deux distribution fonctionnent, mais Anaconda prend plus de place sur votre disque dur.
- Lancez l'installation en laissant les options par défau.t
- Quand c'est terminé, vérifiez qu'Anaconda PowerShell Prompt est disponible dans les applications de l'ordinateur

## Etape 2 : Création du dossier de travail

⚠️**On ne travaille pas dans le dossier de téléchargements ou n'importe-où sur le disque dur.**

Nous allons créer un dossier de travail qui contiendra l'ensemble des fichiers et travaux du cours. Ce dossier portera le même nom chez tout le monde (`intro-python`).

Le dossier de travail sera situé sera situé dans le répertoire utilisateur (aussi appelé _Home_).

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
>
> Si cela ne fonctionne pas, appeler l'enseignant. Si cela fonctionne, fermer le terminal.

Pour finir, localiser le dossier `intro-python` sur l'ordinateur :

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur le disque dur qui contient Windows. Aller ensuite dans _Utilisateurs_ et cliquer sur son nom d'utilisateur. On doit voir le dossier `intro-python`. Si ce n'est pas le cas, appeler l'enseignant.

**Retenir que ce dossier sera le dossier de travail pour tout ce cours.**
