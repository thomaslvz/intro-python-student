[< Revenir à la page d'Accueil](../readme.md)

# Configurer une machine UGA (`Windows 11`)

## Etape 1 : Vérifier si Anaconda est installé

Dans le menu Windows, cherchez "Anaconda PowerShell Prompt". Si vous le trouvez, passez à la deuxième étape.

Si vous ne le trouvez pas, il faut l'installer :

- Téléchargez Anaconda (et pas Miniconda) depuis le [site officiel](https://www.anaconda.com/download/success)
- Lancez l'installation en laissant les options par défaut
- Quand c'est terminé, vérifiez qu'Anaconda PowerShell Prompt est disponible dans les applications de l'ordinateur

## Etape 2 : Configuration des éléments du cours

Ouvrez l'application "Anaconda Powershell Prompt" et lancez la commande suivante :

```powershell
Invoke-RestMethod 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' | Invoke-Expression
```

Cela vérifie que tout est bien configuré, et si besoin, réinstalle les éléments manquants.

Au bout de quelques minutes, on doit voir le message ci-dessous :

> ```bash
> Bilan : tout est prêt ! ✅
> ```

## Etape 3 : Localisation du dossier de travail

Pour finir, localiser le dossier `intro-python` sur l'ordinateur :

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur son espace personnel dans les _Emplacements réseaux_. On doit voir le dossier `intro-python`. Si ce n'est pas le cas, appeler l'enseignant.

**Retenir que ce dossier sera le dossier de travail pour tout ce cours et contiendra nos fichiers.**
