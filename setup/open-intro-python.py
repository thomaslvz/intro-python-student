from pathlib import Path
import platform
import shutil
import subprocess


course_directory = Path.home() / "intro-python"

if not course_directory.is_dir():
    print(
        f"❌ Le dossier {course_directory} n'existe pas. Il faut (re)faire l'étape 2 de la configuration initiale."
    )
else:
    parent_directory = course_directory.parent
    system = platform.system()

    if system == "Windows":
        subprocess.Popen(["explorer", str(parent_directory)])

    elif system == "Darwin":
        subprocess.Popen(["open", str(parent_directory)])

    elif system == "Linux":
        if shutil.which("xdg-open") is None:
            print("❌ xdg-open is not available on this system.")
        else:
            subprocess.Popen(["xdg-open", str(parent_directory)])

    else:
        print(f"❌ Unsupported operating system: {system}")
