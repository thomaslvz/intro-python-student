from pathlib import Path
import platform
import shutil
import subprocess


course_directory = Path.home() / "intro-python"

if not course_directory.is_dir():
    raise FileNotFoundError(f"The directory does not exist: {course_directory}")

system = platform.system()

if system == "Windows":
    subprocess.Popen(["explorer", str(course_directory)])

elif system == "Darwin":
    subprocess.Popen(["open", str(course_directory)])

elif system == "Linux":
    if shutil.which("xdg-open") is None:
        raise RuntimeError("xdg-open is not available on this system.")

    subprocess.Popen(["xdg-open", str(course_directory)])

else:
    raise RuntimeError(f"Unsupported operating system: {system}")
