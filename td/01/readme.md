[< Revenir à la page d'Accueil](../../readme.md)

# TD n°1

>⚠️ Si vous êtes sur un ordinateur UGA, vous devez au préalable **[configurer l'ordinateur](../../setup/setup-w11.md)** avant de débuter ce TD. Si vous êtes sur un ordinateur personnel, il faut avoir terminé le travail préparatoire demandé sur Moodle. Si vous avez déjà réalisé ces étapes, vous pouvez démarrer ce qui suit.

Ouvrez un terminal dans le dossier `intro-python`.

Exécutez la commande suivante pour récupérer les fichiers du TD1 :

```bash
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '01']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/bootstrap_td.py').read())"
```
Lancez *JupyterLab* avec cette commande :

```bash
conda run -n intro-python-feg-l3 jupyter lab
```

Dans *JupyterLab*, repérer l'explorateur de fichiers (panneau de gauche). Localiser le répertoire du 1er TD et l'ouvrir.

Vous découvrez les différents fichiers de ce TD. Repérez l'extension des fichiers :

- les fichiers terminant par `.ipynb` sont des *Notebooks Python*
- les fichiers terminant par `.py` sont des *Scripts Python*

Nous allons découvrir leur fonctionnement aujourd'hui.

# Exercice 1

Ouvrez le premier Notebook intitulé `01_prise_en_main.ipynb` et suivez les instructions.

# Exercice 2

Le but de cet exercice est d'apprendre à fermer proprement *JupyerLab*.

Commencez par sauvegarder votre fichier `01_prise_en_main.ipynb`. Repérez ensuite l'adresse utilisée dans le navigateur pour accéder à *JupyterLab* (du style `localhost:8888/lab...`) et copiez-la (`Ctrl+C`). Fermez ensuite le navigateur.

Ouvrez à nouveau un navigateur web et collez l'adresse précédente (`Ctrl+V`). *JupyterLab* s'affiche à nouveau : il n'était donc pas réellement fermé.

> 💡 Ce que l'on doit comprendre : l'application *Jupyterlab* tourne en arrière plan, et le navigateur web permet uniquement d'afficher à l'application, pas de la démarrer ou l'arrêter.

Pour fermer réellement *JupyterLab*, allez désormais dans le terminal que vous avez ouvert au tout début du TD. Cliquez dans le Terminal puis faites `Ctrl+C`, et répondez "y" à la question "Shut down this Jupyter server". Cette fois-ci, l'application n'est plus accessible via un navigateur. Vous pouvez fermer le terminal.

# Exercice 3

Cet exercice se déroule désormais hors de *JupyterLab* et a pour but de découvrir Python en pratiquant (*Learn by doing*).

Objectif : compéter les 4 premiers niveaux de la Python Quest sur le site [Utileaf](https://utileaf.com/tools/python-quest).

A faire :
1. Allez sur [Utileaf](https://utileaf.com/tools/python-quest)
2. Cliquez sur "Start Learning"
3. Compléter ensuites les 4 permiers niveaux :
   - Python Camp
   - Variable Forest
   - String Garden
   - Number Peak

# Exercice 4

Comme au début du TD, ouvrez un terminal dans le dossier `intro-python`, puis lancez *JupyterLab* :

```bash
conda activate intro-python-feg-l3
jupyter lab
```

Ouvrez le dossier du TD1, puis lancez le notebook intitulé `04_fonctions.ipynb`, et suivez les consignes.

# (bonus) Exercice 5


Dans JupyterLab, cliquez sur le *Launcher* (bouton `+`), et créez un notebook que vous appellerez `exercice_05.ipynb`.

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
