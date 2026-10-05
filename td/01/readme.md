[< Revenir à la page d'Accueil](../../readme.md)

# TD n°1

> ⚠️ Vous devez au préalable **configurer l'ordinateur** avant de débuter ce TD. Les instructions sont sur Moodle, c'est à réaliser une seule fois lors du 1er TD.

## Chargement des fichiers et démarrage de JupyterLab

<details>
<Summary><b>Si vous êtes sur un ordinateur UGA</b></Summary>

Lancez l'application _Anaconda Prompt_, puis excécutez-y ces commandes :

```powershell
H:
cd intro-python
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '01']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/bootstrap_td.py').read())"
```

Si vous avez une phrase du type "Le TD.. a été installé dans...", vous pouvez continuer. Lancez cette commande :

```powershell
conda run -n intro-python-feg-l3 jupyter lab
```

</details>

<br>

<details>
<summary><b>Si vous êtes sur votre ordinateur personnel</b></summary>

Localisez votre dossier `intro-python`.

---

<details>
<summary>💡 Aide : je n'arrive pas à trouver mon dossier <code>intro-python</code></summary>

Ouvrez un terminal et lancez :

```bash
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/open-intro-python.py').read())"
```

Vous pouvez fermer le terminal, et une fenêtre s'est ouverte automatiquement. Le dossier `intro-python` y est visible. Il est conseillé d'ajouter ce dossier à vos _accès rapides_, pour le retrouver rapidement.

</details>

---

Sur le dossier `intro-python`, faites un `clic droit` puis `Ouvrir dans un Terminal`.

Dans le terminal, exécutez cette commande :

```bash
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '01']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/bootstrap_td.py').read())"
```

Si vous avez une phrase du type "Le TD.. a été installé dans...", vous pouvez continuer. Lancez cette commande :

```bash
conda run -n intro-python-feg-l3 jupyter lab
```

</details>
<br>

Il faut garder ce terminal ouvert tant que JupyterLab est utilisé.

## Exercice 1

Dans _JupyterLab_, repérer l'explorateur de fichiers (panneau de gauche). Localiser le répertoire du 1er TD et l'ouvrir.

Vous découvrez les différents fichiers de ce TD. Repérez l'extension des fichiers :

- les fichiers terminant par `.ipynb` sont des _Notebooks Python_
- les fichiers terminant par `.py` sont des _Scripts Python_

Nous allons découvrir leur fonctionnement aujourd'hui.

Ouvrez le premier Notebook intitulé `01_prise_en_main.ipynb` et suivez les instructions.

## Exercice 2

Le but de cet exercice est d'apprendre à fermer proprement _JupyerLab_.

Commencez par sauvegarder votre fichier `01_prise_en_main.ipynb`. Repérez ensuite l'adresse utilisée dans le navigateur pour accéder à _JupyterLab_ (du style `localhost:8888/lab...`) et copiez-la (`Ctrl+C`). Fermez ensuite le navigateur.

Ouvrez à nouveau un navigateur web et collez l'adresse précédente (`Ctrl+V`). _JupyterLab_ s'affiche à nouveau : il n'était donc pas réellement fermé.

> 💡 Ce que l'on doit comprendre : l'application _Jupyterlab_ tourne en arrière plan, et le navigateur web permet uniquement d'afficher à l'application, pas de la démarrer ou l'arrêter.

Pour fermer réellement _JupyterLab_, allez désormais dans le terminal que vous avez ouvert au tout début du TD (appelé "Anaconda Prompt" ou "Terminal" selon les machines). Cliquez dans le Terminal puis faites `Ctrl+C`, et répondez "y" à la question "Shut down this Jupyter server". Cette fois-ci, l'application n'est plus accessible via un navigateur. Vous pouvez fermer cette fenêtre.

## Exercice 3

Cet exercice se déroule désormais hors de _JupyterLab_ et a pour but de découvrir Python en pratiquant (_Learn by doing_).

Objectif : compéter les 4 premiers niveaux de la Python Quest sur le site [Utileaf](https://utileaf.com/tools/python-quest).

A faire :

1. Allez sur [Utileaf](https://utileaf.com/tools/python-quest)
2. Cliquez sur "Start Learning"
3. Compléter ensuites les 4 permiers niveaux :
   - Python Camp
   - Variable Forest
   - String Garden
   - Number Peak

## Exercice 4

Comme au début du TD, ouvrez un terminal dans le dossier `intro-python` :

- Si vous êtes sur une machine UGA, lancez _Anaconda Prompt_ puis exécutez
  ```powershell
  H:
  cd intro-python
  conda run -n intro-python-feg-l3 jupyter lab
  ```
- Si vous êtes sur votre ordinateur personnel, localisez votre dossier `intro-python`, puis `clic droit` > `Ouvrir dans un Terminal` et exécutez

  ```bash
  conda run -n intro-python-feg-l3 jupyter lab
  ```

Ouvrez le dossier du TD1, puis lancez le notebook intitulé `04_fonctions.ipynb`, et suivez les consignes.

## (bonus) Exercice 5

Dans JupyterLab, cliquez sur le _Launcher_ (bouton `+`), et créez un notebook que vous appellerez `05_predictions.ipynb`.

En utilisant le notebook, réalisez l'exercice 5, dont les consignes sont ci-dessous.

**Partie 1**

Essayez de prédire le résultat de chacune des instructions suivantes, puis vérifiez-le en testant dans le notebook :

- `(1+2)**3`
- `"Da" * 4`
- `"Da" + 3`
- `("Pa"+"La") * 2`
- `("Da"*4) / 2`
- `5 / 2`
- `5 // 2`
- `5 % 2`

**Partie 2**

Essayez de prédire le résultat de chacune des instructions suivantes, puis vérifiez-le en testant dans le notebook :

- `str(4) * int("3")`
- `int("3") + float("3.2")`
- `str(3) * float("3.2")`
- `str(3/4) * 2`
