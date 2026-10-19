# Introduction à python

<details>
<summary id="setup">Configuration initiale</summary>

Pour configurer l'ordinateur, suivez les instructions de _setup_ :

- [Sur une machine UGA](setup/setup-w11-uga.md)
- [Sur une machine perso avec`Windows 11`](setup/setup-w11.md)
- [Sur une machine perso avec `Mac` ou `Linux`](setup/setup-mac-linux.md)

</details>

## Déroulé des séances

Les TD sont réalisés sur l'environnement de développement _JupyterLab_.

A chaque début de séance, une commande est lancée dans un terminal pour vérifier la configuration et démarrer _JupyterLab_.

| Numéro de séance  | Thématique                                        | Supports                                                                                                                                                                                                                | Ressources utiles                                                     |
| ----------------- | ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **Séance 1**      | Prise en main                                     | [Présentation](https://thomaslvz.github.io/intro-python-student/01_prise-en-main) / [TD](td/01/readme.md)<br><br>A finir chez soi : [Python Quest](https://utileaf.com/tools/python-quest) (niv. 1 à 4)                 | [Guide syntaxe Markdown](https://www.markdownguide.org/basic-syntax/) |
| **Séance 2**      | Variables, types, structures de données           | [Présentation](https://thomaslvz.github.io/intro-python-student/02_variables-types-list-dict) / [TD](td/02/readme.md)                                                                                                   |                                                                       |
| **Séance 3**      | _Annulée_                                         |                                                                                                                                                                                                                         |                                                                       |
| **Séance 4**      | Fonctions, strutures conditionnelles, boucles     | [Présentation](https://thomaslvz.github.io/intro-python-student/03_fonctions-boucles-conditions) / [TD](td/03/readme.md)<br><br> A finir chez soi : [Python Quest](https://utileaf.com/tools/python-quest) (niv. 5 à 9) |                                                                       |
| _Pause Toussaint_ |
| **Séance 5**      | Numpy<br><br>📄 _Evaluation 1h (sans ordinateur)_ |                                                                                                                                                                                                                         |                                                                       |
| **Séance 6**      | pandas, premiers pas                              |                                                                                                                                                                                                                         |                                                                       |
| **Séance 6**      |                                                   |                                                                                                                                                                                                                         |                                                                       |
| **Séance 7**      |                                                   |                                                                                                                                                                                                                         |                                                                       |
| **Séance 8**      |                                                   |                                                                                                                                                                                                                         |                                                                       |
| **Séance 9**      |                                                   |                                                                                                                                                                                                                         |                                                                       |

### Ressources externes / Bibliographie

- Apprendre Python avec d'autres cours :
  - capsules vidéo niv. débutant.e sur [learn.microsoft.com](https://learn.microsoft.com/en-us/shows/intro-to-python-development/) (en anglais)
  - le très complet [cours](https://python.sdv.u-paris.fr/) de Patrick Fuchs & Pierre Poulain (Université Paris Cité)
  - des cours, ateliers, exercices, mini-projets pour les économistes, niv. intermédiaire et avancé.e, sur [QuantEcon](https://quantecon.org/) (en anglais)
- S'entraîner à coder en Python sur des exercices en ligne (en anglais) :
  - la [Python Quest](https://utileaf.com/tools/python-quest) sur Utileaf (niv. débutant.e)
  - de nombreux exercices tous niveaux, classés par thématique, sur [CodingPractice](https://codingpractice.online/)
- Exécuter du code Python en ligne depuis n'importe quel ordinateur, sans installation :
  - Dans une [console python](https://fr.futurecoder.io/course/#ide)
  - Sur [JupyterLab](https://jupyter.org/try-jupyter/lab/)

## Questions fréquentes

### Si je veux refaire un TD que j'ai déjà fait, comment m'y prendre ?

Peu importe que ce soit la première fois ou non, il faut suivre toutes les instructions préparatoires du début du TD. Cela permet de vérifier que l'ordinateur est bien configuré. Si les fichiers du TD sont déjà présents sur votre ordinateur, le script d'initialisation vous demandera si vous voulez les conserver (c'est conseillé !) ou les remplacer.

### Où sont les corrigés des TD ?

Les notebooks corrigés sont déposés sur Moodle progressivement. Vous pouvez les télécharger et les ranger dans votre dossier `intro-python`, afin de les ouvrir comme n'importe quel notebook.

### Je peux travailler sur un autre ordinateur UGA que celui de d'habitude ?

C'est possible, mais à **chaque fois** que vous voulez travailler sur un ordinateur différent, il faut refaire la [configuration initiale](https://github.com/thomaslvz/intro-python-student/blob/main/setup/setup-w11-uga.md). Cela n'effacera **pas** vos fichiers, et si l'ordinateur possède déjà Python installé, ce sera très rapide.

Votre dossier `intro-python` est conservé d'un ordinateur à l'autre, sur tout le réseau UGA.

### Comment lancer JupyterLab ?

Si vous (re)faites un TD, suivez les instructions du TD.

Si vous voulez simplement lancer JupyterLab pour travailler sur vos fichiers, suivez les instructions ci-dessous.

- sur `Windows` (ordinateur perso ou UGA), ouvrez l'application _Anaconda Powershell Prompt_ et lancez :

  ```powershell
  Invoke-RestMethod 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' | Invoke-Expression
  ```

- sur `MacOS`/`Linux`, ouvrez un _Terminal_ et lancez :

  ```bash
  curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" | bash
  ```

Les instructions pour lancer _JupyterLab_ seront affichées à l'écran.

### Comment ouvrir un terminal dans mon dossier `intro-python` ?

Etape 1 :

- Sous `Windows`, lancez l'application _Anaconda PowersShell Prompt_
- Sous `MacOS`, ou `Linux`, lancez l'application _Terminal_

Etape 2 :

Pour vous localiser dans le dossier `intro-python` :

- Si vous êtes sur un ordinateur UGA, tapez la commande
  ```shell
  cd H:/intro-python
  ```
- Si vous êtes sur votre ordinateur personnel, tapez la commande
  ```shell
  cd ~/intro-python
  ```
  Vous y êtes !

### Comment localiser dossier `intro-python` sur le disque dur ?

**Si vous êtes sur un PC UGA :**

- Lancez l'explorateur de fichiers
- Cliquez sur `Ce PC`
- Dans les emplacements réseaux, ouvrir le disque correspondant à votre nom d'utilisateur (dique `H:`)
- Le dossier `intro-python` est là

**Si vous êtes sur un PC perso :**

- Ouvrez l'application _Anaconda Powershell Prompt_ (`Windows`) ou _Terminal_ (`MacOS/Linux`)
- Lancez la commande
  ````bash
  conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/open-intro-python.py').read())"  ```
  ````
- Vous pouvez fermer le terminal, et une fenêtre s'est ouverte automatiquement. Le dossier `intro-python` y est visible. Il est conseillé d'ajouter ce dossier à vos _accès rapides_, pour le retrouver rapidement.

### Quand je veux lancer jupyterlab, j'ai une erreur me disant que `conda` n'existe pas

Message d'erreur type :

- sur `Windows`: `conda : The term 'conda' is not recognized as the name of a cmdlet, function, script file, or operable program.`
- sur `MacOS/Linux` : `conda: command not found`

Solution :

- sur `Windows` :
  - rééssayez depuis l'application _Anaconda PowerShell Prompt_ plutôt que le terminal
  - si vous n'avez pas _Anaconda PowerShell Prompt_, il faut (re)faire l'étape 1 de la [Configuration initiale](setup/setup-w11.md)
- sur `Mac`/`Linux` :
  - Ouvez un terminal et exécutez-y la commande suivante :
    ```python
    curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" | bash
    ```
  - Si vous voyez un messsage `==> Tout est en ordre !`, la commande `conda` doit fonctionner.
  - Si vous ne voyez pas ce message, faites une capture d'écran et envoyez la à l'enseignant pour obtenir de l'aide.

### J'ai une erreur `EnvironmentLocationNotFound`

Message d'erreur type :

```bash
EnvironmentLocationNotFound: Not a conda environment: /.../envs/intro-python-feg-l3
```

Solution :

- sur `Windows` (ordinateur perso ou UGA), ouvrez l'application _Anaconda Powershell Prompt_ et lancez :

  ```powershell
  $ScriptPath = Join-Path $env:TEMP "script.ps1"
  Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' -OutFile $ScriptPath
  & $ScriptPath -ForceEnvironment
  ```

- sur `MacOS`/`Linux`, ouvrez un terminal et lancez :

  ```bash
  script=$(mktemp) || exit 1
  trap 'rm -f "$script"' EXIT

  curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" -o "$script" &&
  bash "$script" --force-environment
  ```

### Comment obtenir les présentations en PDF ?

_A faire avec le navigateur Firefox ou Chrome_

- ouvrez la présentation
- cliquez sur le menu en haut à gauche, puis, `Tools` > `PDF export mode`
- dans le navigateur, faire menu > `Imprimer` et sélectionner `Enregistrer au format PDF`
- vérifiez que la case "imprimer les arrières plans" soit cochée, et que l'option "ajuster à la largeur de la page" soit activée
- cliquez sur "Enregistrer"
