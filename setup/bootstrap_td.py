"""
Usage : python bootstrap_td.py <numéro du TD>
Params :
    - <numéro du TD> is a 2 char string, e.g. "01"

The script will :
- check that it is run from the intro-python folder
- check CONDA environment
- ask for confirmation to delete the local TD folder (if it exists)
- download the TD files from the distant repository to the local TD folder
"""

import io
import os
import sys
import urllib.request
import zipfile

from send2trash import send2trash


# Configuration
CONDA_ENV = "intro-python-feg-l3"
REPO_URL = (
    "https://github.com/thomaslvz/intro-python-student/archive/refs/heads/main.zip"
)


# Vérifier le répertoire courant
if os.path.basename(os.getcwd()) != "intro-python":
    print("Erreur : ce script doit être lancé depuis le dossier 'intro-python'.")
    sys.exit(1)


# Vérifier l'environnement Conda
if os.environ.get("CONDA_DEFAULT_ENV") != CONDA_ENV:
    print(f"Erreur : l'environnement Conda '{CONDA_ENV}' n'est pas actif.")
    print("Veuillez d'abord activer cet environnement avec :")
    print(f"    conda activate {CONDA_ENV}")
    sys.exit(1)


# Vérifier le numéro du TD
if len(sys.argv) != 2:
    print("Erreur : numéro de TD invalide.")
    print("Exemple : python bootstrap_td.py 01")
    print("          python bootstrap_td.py a1")
    sys.exit(1)

td = sys.argv[1].lower()
destination = os.path.join("td", td)


# Si le TD existe déjà, demander confirmation
if os.path.exists(destination):
    print()
    print(f"Attention : le dossier '{destination}' existe déjà.")
    print("Si vous continuez, il sera placé dans la corbeille")
    print(f"et remplacé par les fichiers vierges du TD {td}.")
    print()

    answer = input("Continuer ? [o/N] ").strip().lower()

    if answer not in ("o", "oui"):
        print("Opération annulée.")
        sys.exit(0)

    send2trash(destination)


# Télécharger le dépôt
print("Téléchargement des fichiers du cours...")

try:
    with urllib.request.urlopen(REPO_URL) as response:
        data = response.read()
except Exception as error:
    print(f"Erreur lors du téléchargement : {error}")
    sys.exit(1)


# Extraire le TD demandé
with zipfile.ZipFile(io.BytesIO(data)) as archive:
    root = archive.namelist()[0].split("/")[0]
    prefix = f"{root}/td/{td}/"

    files = [
        name
        for name in archive.namelist()
        if name.startswith(prefix) and not name.endswith("/")
    ]

    if not files:
        print(f"Erreur : le TD '{td}' n'existe pas dans le dépôt.")
        sys.exit(1)

    for name in files:
        relative = name[len(prefix) :]
        path = os.path.join(destination, relative)

        os.makedirs(os.path.dirname(path), exist_ok=True)

        with archive.open(name) as source, open(path, "wb") as target:
            target.write(source.read())


print()
print(f"Le TD {td} a été installé dans : {os.path.join(os.getcwd(), destination)}")
