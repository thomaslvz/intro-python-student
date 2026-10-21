[< Revenir à la page d'Accueil](../readme.md)

# Configurer sa machine perso (`Windows 11`)

NB : si vous êtes sur une machine perso tournant sur Windows 10, il est conseillé d'utiliser plutôt les machines de l'UGA. En effet, les mises à jours de sécurité [ne sont plus publiées pour Windows 10](https://www.microsoft.com/fr-fr/windows/end-of-support), ce qui représente un risque.

## Etape 1 : Vérifier si Python est installé

Dans le menu Windows, cherchez "Anaconda PowerShell Prompt". Si vous le trouvez, passez à la deuxième étape.

Si vous ne le trouvez pas, il faut l'installer :

- Téléchargez Anaconda ou Miniconda depuis le [site officiel](https://www.anaconda.com/download/success). Les deux distribution fonctionnent, mais Anaconda prend plus de place sur votre disque dur.
- Lancez l'installation en laissant les options par défau.t
- Quand c'est terminé, vérifiez qu'Anaconda PowerShell Prompt est disponible dans les applications de l'ordinateur

## Etape 2 : Configuration des éléments du cours

Ouvrez l'application "Anaconda Powershell Prompt" et lancez la commande suivante :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; Invoke-RestMethod 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' | Invoke-Expression
```

Cela vérifie que tout est bien configuré, et si besoin, installe les éléments manquants.

Au bout de quelques minutes, on doit voir le message ci-dessous :

> ```bash
> ==> Tout est en ordre !
> ```

## Etape 3 : Localisation du dossier de travail

Pour finir, localiser le dossier `intro-python` sur l'ordinateur :

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur le disque dur qui contient Windows. Aller ensuite dans _Utilisateurs_ et cliquer sur son nom d'utilisateur. On doit voir le dossier `intro-python`. Si ce n'est pas le cas, appeler l'enseignant.

**Retenir que ce dossier sera le dossier de travail pour tout ce cours et contiendra nos fichiers.**
