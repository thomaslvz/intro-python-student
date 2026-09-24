# TD n°1

Ouvrez un terminal dans le dossier `intro-python`.

Exécutez la commande suivante pour récupérer les fichiers du TD1 :

```bash
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '01']; exec(urllib.request.urlopen('$repoBaseUrl/setup/bootstrap_td.py').read())"
```
Lancez *JupyterLab* :

```bash
conda run --no-capture-output -n intro-python-feg-l3 jupyter lab
```

Dans *JupyterLab*, repérer l'explorateur de fichiers (panneau de gauche). Localiser le répertoire du 1er TD et l'ouvrir.

Vous découvrez les différents fichiers de ce TD. Repérez l'extension des fichiers :

- les fichiers terminant par `.ipynb` sont des *Notebooks Python*
- les fichiers terminant par `.py` sont des *Scripts Python*

Nous allons découvrir leur fonctionnement aujourd'hui.

# Exercice 1

Ouvrez le premier Notebook intitulé `01_prise_en_main.ipynb` et suivez les instructions.

# Exercice 2

à compléter
