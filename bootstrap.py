import io
import os
import urllib.request
import zipfile


# URL of the public GitHub repository archive.
REPO_URL = "HIDDEN"


# Download the repository as a ZIP archive.
print("Downloading course files...")
archive_data = urllib.request.urlopen(REPO_URL).read()


# Open the ZIP archive directly from memory.
with zipfile.ZipFile(io.BytesIO(archive_data)) as archive:
    # GitHub puts the repository contents inside a directory
    # such as "repository-main/".
    root = archive.namelist()[0].split("/")[0]

    # Remove the "-main" suffix from the repository directory name.
    dest = root[:-5] if root.endswith("-main") else root

    # Create the destination directory if it does not exist.
    os.makedirs(dest, exist_ok=True)

    # Extract each file into the destination directory.
    for name in archive.namelist():
        # Ignore directories.
        if not name.startswith(root + "/") or name.endswith("/"):
            continue

        # Remove the GitHub-generated root directory from the path.
        relative_path = name[len(root) + 1 :]

        # Build the local destination path.
        destination = os.path.join(dest, relative_path)

        # Create parent directories when necessary.
        os.makedirs(os.path.dirname(destination), exist_ok=True)

        # Write the file.
        # Existing files are overwritten.
        with open(destination, "wb") as file:
            file.write(archive.read(name))


print(f"Course files updated in: {dest}")