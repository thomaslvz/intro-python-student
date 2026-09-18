# Introduction à python

## Setup (sur une machine perso)
à compléter, distinguer mac/pc


## Setup (sur les machines UGA)

### Installer Miniconda

Télécharger Miniconda depuis le [site officiel](https://www.anaconda.com/download/success), et suivre les instructions d'installation.

En particulier, on cochera les options suivantes:
- install for : just me
- PATH (⚠️à détailler)

### Création du dossier de travail et vérification de l'installation de Miniconda

**Très important : on ne travaille pas dans le dossier de téléchargements ou n'importe où sur le disque dur.** Nous allons créer un dossier de travail qui contiendra l'ensemble des fichiers nécessaires au cours. Ce dossier portera le même nom chez tout le monde : `intro-python`.

A faire :
- Créer le dossier `intro-python` à l'endroit de son choix.
- Ouvrir ensuite ce dossier avec le navigateur de fichiers.
- Dans le dossier, faire SHIFT+clic droit, puis `ouvrir dans un PowerShell`.

Vérifier si Miniconda est installé en tapant 
```bash
conda --version
```
Le résultat doit être du type `conda xx.x.x`. Si ce n'est pas le cas, appeler l'enseignant.

Enfin, activer les téléchargements de packages en tapant

```bash
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
```

### Création de l'environnement python

Ouvrir un terminal PowerShell **dans le dossier `intro-python`**, comme précédemment.

Lancer la commande suivante :

```
conda run -n base python -c "import urllib.request; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/bootstrap.py').read())"
```

*Explications (facultatif en première lecture) : Tout au long du cours, un dossier `intro-python-student` contiendra les fichiers d'exercices et de cours. La commande ci-dessus permet de le maintenir à jour à tout moment, elle est à exécuter depuis un terminal PowerShell dans `intro-python`.*

Créer l'environnement python :
```
conda env create -f ./intro-python-student/environment.yml
```

Lancer le script de vérification de l'installation :

```bash
conda run -n intro-python-feg-l3 python ./intro-python-student/check_setup.py
```

Cela doit afficher le message ci-dessous :
> ```bash
> ============================================================
> SETUP OK
> Your Python environment is ready.
> ============================================================
> ```
Si cela ne fonctionne pas, appeler l'enseignant. Si cela fonctionne, passer à la suite.
<!-- 
Vérifier que l'environnement est activé
```bash
conda list
```
Cela doit afficher une liste de packages présents dans l'environnement de base. Si cela affiche un message d'erreur, appeler l'enseignant. -->


<!-- 
### Ouvrir son premier notebook avec jupyterlab

Depuis un terminal dans le dossier de travail, exécuter :

conda activate l3-python-economics jupyter lab
jupyter lab

Une page doit s'ouvrir automatiquement dans votre navigateur.

Ouvrez ensuite le notebook :

notebooks/00_test_setup.ipynb

Exécutez toutes les cellules.

Si aucune erreur n'apparaît, votre installation est terminée. -->

