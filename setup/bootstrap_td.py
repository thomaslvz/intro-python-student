"""\
Usage: python bootstrap_td.py <numero du TD>

The script will:
- Check that it is run from the intro-python folder
- Check the active Conda environment
- Ask what to do if the local TD folder already exists
- Download and install the requested TD from the remote repository
"""

import io
import os
import re
import sys
import urllib.request
import zipfile
from pathlib import PurePosixPath

from send2trash import send2trash


# Configuration
CONDA_ENV = "intro-python-feg-l3"
REPO_URL = (
    "https://github.com/thomaslvz/intro-python-student/archive/refs/heads/main.zip"
)


def error(message):
    print(f"Erreur : {message}")
    sys.exit(1)


def choose_existing_folder_action(destination):
    """Ask what to do with an existing TD folder."""
    print()
    print(f"Le dossier '{destination}' existe deja.")
    print()
    print("- Appuyez sur Entrée pour ne toucher à rien")
    print("et conserver les fichiers existants.")
    print("- Tapez 'remplacer' pour supprimer ce dossier")
    print("et installer les fichiers vierges du TD.")
    print("Attention, risque de perte du travail déjà effectué !")
    print("- Tapez 'renommer' pour conserver tous vos fichiers existants")
    print("et installer les fichiers vierges du TD.")
    print()

    while True:
        answer = input("Votre choix [Entrée/remplacer/renommer] : ")
        answer = answer.strip().lower()

        if answer == "":
            return "keep"

        if answer in ("remplacer", "renommer"):
            return answer

        print("Choix invalide. Entrez 'remplacer', 'renommer' ou appuyez sur Entrée.")


def download_td_files(td):
    """Download the repository and return the requested TD files."""
    print("Téléchargement des fichiers...")

    try:
        with urllib.request.urlopen(REPO_URL) as response:
            data = response.read()
    except Exception as exc:
        error(f"échec du telechargement : {exc}")

    try:
        with zipfile.ZipFile(io.BytesIO(data)) as archive:
            # Find the repository root folder.
            names = archive.namelist()
            roots = [name.split("/")[0] for name in names if name.strip("/")]

            if not roots:
                error("le depot distant est vide.")

            root = roots[0]
            prefix = f"{root}/td/{td}/"

            files = {}

            for name in names:
                if not name.startswith(prefix) or name.endswith("/"):
                    continue

                relative = name[len(prefix) :]
                relative_path = PurePosixPath(relative)

                # Reject unsafe archive paths.
                if (
                    relative_path.is_absolute()
                    or ".." in relative_path.parts
                    or not relative_path.parts
                ):
                    error(f"chemin invalide dans le depot : {name}")

                with archive.open(name) as source:
                    files[relative] = source.read()

            if not files:
                error(f"le TD '{td}' n'existe pas dans le depot.")

            return files

    except zipfile.BadZipFile:
        error("le fichier téléchargé n'est pas une archive ZIP valide.")


def unique_backup_path(path):
    """Return a backup filename that does not already exist."""
    directory = os.path.dirname(path)
    filename = os.path.basename(path)
    stem, extension = os.path.splitext(filename)

    candidate = os.path.join(directory, f"{stem}-my-file{extension}")
    counter = 2

    while os.path.lexists(candidate):
        candidate = os.path.join(
            directory,
            f"{stem}-my-file-{counter}{extension}",
        )
        counter += 1

    return candidate


def install_td_files(destination, files, action):
    """Install pristine files, optionally preserving local versions."""
    if action == "remplacer" and os.path.exists(destination):
        print("Suppression du dossier existant...")
        send2trash(destination)  # Delete permanently on UGA Network drive

    os.makedirs(destination, exist_ok=True)

    for relative, content in files.items():
        path = os.path.join(destination, *PurePosixPath(relative).parts)
        os.makedirs(os.path.dirname(path), exist_ok=True)

        if os.path.lexists(path):
            if action == "renommer":
                if not os.path.isfile(path):
                    error(
                        f"impossible de remplacer '{path}' : "
                        "un dossier ou un lien existe a cet emplacement."
                    )

                backup = unique_backup_path(path)
                os.rename(path, backup)
                print(f"Fichier local conservé : {os.path.relpath(backup)}")
            else:
                # Never overwrite an unexpected local file.
                error(f"le fichier '{path}' existe deja. Aucun fichier ne sera ecrasé.")

        with open(path, "wb") as target:
            target.write(content)


def main():
    # Check the current directory.
    if os.path.basename(os.getcwd()) != "intro-python":
        error("ce script doit etre lancé depuis le dossier 'intro-python'.")

    # Check the active Conda environment.
    if os.environ.get("CONDA_DEFAULT_ENV") != CONDA_ENV:
        print(f"Erreur : l'environnement Conda '{CONDA_ENV}' n'est pas actif.")
        print("Veuillez d'abord activer cet environnement avec :")
        print(f"    conda activate {CONDA_ENV}")
        sys.exit(1)

    # Check the TD number.
    if len(sys.argv) != 2 or not re.fullmatch(r"[a-zA-Z0-9]{2}", sys.argv[1]):
        print("Erreur : numero de TD invalide.")
        print("Exemple : python bootstrap_td.py 01")
        print("          python bootstrap_td.py a1")
        sys.exit(1)

    td = sys.argv[1].lower()
    destination = os.path.join("td", td)

    action = "install"

    # If the folder exists, ask before downloading or changing anything.
    if os.path.exists(destination):
        action = choose_existing_folder_action(destination)

        if action == "keep":
            print("Operation terminée : aucun fichier n'a ete modifié.")
            return

    # Download and validate before modifying local files.
    files = download_td_files(td)

    try:
        install_td_files(destination, files, action)
    except OSError as exc:
        error(f"probleme lors de l'installation : {exc}")

    print()
    print(f"Le TD {td} a ete installe dans : {os.path.abspath(destination)}")

    if action == "renommer":
        print(
            "Les fichiers locaux en conflit ont ete conservés avec le suffixe '-my-file'."
        )


if __name__ == "__main__":
    main()
