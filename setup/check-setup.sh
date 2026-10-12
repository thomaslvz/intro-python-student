#!/usr/bin/env bash

# Check Conda, prepare the course directory and create the Python environment.
# Compatible with macOS and Linux.
#
# Usage:
#   bash setup.sh
#   bash setup.sh --force-course-directory
#   bash setup.sh --force-environment
#   bash setup.sh --bootstrap-td 02
#   bash setup.sh --force-environment --bootstrap-td 02
#
# Options:
#   --force-course-directory  Recreate the course directory structure.
#   --force-environment       Recreate the Conda environment.
#   --bootstrap-td NUMBER     Run the bootstrap script for a TD.
#   -h, --help                Display this help message.

set -Eeuo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

REPO_BASE_URL="https://raw.githubusercontent.com/thomaslvz/intro-python-student/main"
ENVIRONMENT_URL="${REPO_BASE_URL}/environment.yml"
ENVIRONMENT_NAME="intro-python-feg-l3"
COURSE_DIRECTORY="${HOME}/intro-python"

CONDA_MISSING_MESSAGE="Il faut installer Miniconda ou Anaconda sur cet ordinateur pour ce cours.

Téléchargez et installez Anaconda ou Miniconda depuis :
https://www.anaconda.com/download/success?reg=skipped"

# -----------------------------------------------------------------------------
# Command-line options
# -----------------------------------------------------------------------------

FORCE_COURSE_DIRECTORY=0
FORCE_ENVIRONMENT=0
BOOTSTRAP_TD=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force-course-directory)
            FORCE_COURSE_DIRECTORY=1
            shift
            ;;
        --force-environment)
            FORCE_ENVIRONMENT=1
            shift
            ;;
        --bootstrap-td)
            if [[ $# -lt 2 || -z "$2" ]]; then
                echo "ERROR: --bootstrap-td requires a TD number." >&2
                exit 1
            fi
            BOOTSTRAP_TD="$2"
            shift 2
            ;;
        -h|--help)
            sed -n '2,18p' "$0"
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# -----------------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------------

write_step() {
    printf '\n==> %s\n' "$1"
}

write_warning() {
    printf 'WARNING: %s\n' "$1" >&2
}

die() {
    printf '\nERROR: %s\n' "$1" >&2
    exit 1
}

download_file() {
    local url="$1"
    local destination="$2"

    if ! curl --fail --silent --show-error --location \
        "$url" --output "$destination"; then
        rm -f "$destination"
        die "Could not download: $url"
    fi
}

# -----------------------------------------------------------------------------
# Locate Conda
# -----------------------------------------------------------------------------

find_standard_conda_installations() {
    local candidate
    local -a candidates=(
        "${HOME}/miniconda3/bin/conda"
        "${HOME}/anaconda3/bin/conda"
        "${HOME}/miniforge3/bin/conda"
        "${HOME}/mambaforge/bin/conda"
        "${HOME}/miniconda/bin/conda"
        "/opt/homebrew/Caskroom/miniconda/base/bin/conda"
        "/opt/homebrew/Caskroom/miniforge/base/bin/conda"
        "/opt/anaconda3/bin/conda"
        "/opt/miniconda3/bin/conda"
        "/opt/miniforge3/bin/conda"
        "/usr/local/anaconda3/bin/conda"
        "/usr/local/miniconda3/bin/conda"
        "/usr/local/miniforge3/bin/conda"
    )

    for candidate in "${candidates[@]}"; do
        if [[ -x "$candidate" && -f "$candidate" ]]; then
            printf '%s\n' "$candidate"
        fi
    done
}

write_step "Looking for Conda"

CONDA_EXE="$(type -P conda 2>/dev/null || true)"

if [[ -n "$CONDA_EXE" && -x "$CONDA_EXE" ]]; then
    if ! "$CONDA_EXE" --version >/dev/null 2>&1; then
        die "Conda was found in PATH but could not be executed: $CONDA_EXE"
    fi

    printf 'Conda found in PATH: %s\n' "$CONDA_EXE"
else
    CONDA_INSTALLATIONS=()

    while IFS= read -r installation; do
        CONDA_INSTALLATIONS+=("$installation")
    done < <(find_standard_conda_installations)


    if [[ ${#CONDA_INSTALLATIONS[@]} -gt 0 ]]; then
        printf '\nConda is installed but is not available in PATH.\n'
        printf 'Detected installation(s):\n'

        for installation in "${CONDA_INSTALLATIONS[@]}"; do
            printf '  %s\n' "$installation"
        done

        printf '\nVeuillez ajouter le dossier bin de votre installation Conda au PATH, puis relancer ce script.\n'
        printf 'Consultez la documentation de votre shell pour configurer le PATH.\n'
        exit 1
    fi

    write_warning "No Conda installation was found."
    printf '\n%s\n' "$CONDA_MISSING_MESSAGE"
    exit 1
fi

# -----------------------------------------------------------------------------
# Prepare the course directory
# -----------------------------------------------------------------------------

write_step "Checking course directory"

if [[ "$FORCE_COURSE_DIRECTORY" -eq 1 ]]; then
    printf 'Recreating the course directory structure.\n'
elif [[ ! -d "$COURSE_DIRECTORY" ||
        ! -d "$COURSE_DIRECTORY/td" ]]; then
    printf 'Course directory is not configured or is incomplete.\n'
else
    printf 'Course directory detected: %s\n' "$COURSE_DIRECTORY"
fi

mkdir -p \
    "$COURSE_DIRECTORY/data" \
    "$COURSE_DIRECTORY/td" \
    || die "Could not prepare '$COURSE_DIRECTORY'."

touch "$COURSE_DIRECTORY/data/sample.txt" \
    || die "Could not create data/sample.txt."

printf 'Course directory ready: %s\n' "$COURSE_DIRECTORY"

cd "$COURSE_DIRECTORY" \
    || die "Could not access '$COURSE_DIRECTORY'."

# -----------------------------------------------------------------------------
# Check the Conda environment
# -----------------------------------------------------------------------------

environment_exists() {
    "$CONDA_EXE" env list 2>/dev/null |
        awk -v name="$ENVIRONMENT_NAME" '
            $1 == name { found = 1 }
            END { exit !found }
        '
}

write_step "Checking Python environment"

ENVIRONMENT_EXISTS=0

if environment_exists; then
    ENVIRONMENT_EXISTS=1
fi

if [[ "$FORCE_ENVIRONMENT" -eq 1 ||
      "$ENVIRONMENT_EXISTS" -eq 0 ]]; then

    if [[ "$ENVIRONMENT_EXISTS" -eq 1 ]]; then
        write_warning "The existing environment '$ENVIRONMENT_NAME' will be removed. Its installed packages will be deleted."

        "$CONDA_EXE" env remove \
            --name "$ENVIRONMENT_NAME" \
            --yes \
            || die "Could not remove the existing environment '$ENVIRONMENT_NAME'."
    else
        printf "Python environment '%s' is not configured.\n" \
            "$ENVIRONMENT_NAME"
    fi

    # Download the environment definition.
    ENVIRONMENT_FILE="${COURSE_DIRECTORY}/environment.yml"

    write_step "Downloading environment definition"

    download_file "$ENVIRONMENT_URL" "$ENVIRONMENT_FILE"

    # Accept Anaconda channel terms when supported by this Conda installation.
    if "$CONDA_EXE" tos --help >/dev/null 2>&1; then
        "$CONDA_EXE" tos accept \
            --override-channels \
            --channel https://repo.anaconda.com/pkgs/main \
            || die "Could not accept the Anaconda main channel terms."

        "$CONDA_EXE" tos accept \
            --override-channels \
            --channel https://repo.anaconda.com/pkgs/r \
            || die "Could not accept the Anaconda R channel terms."
    fi

    write_step "Creating Python environment"

    if ! "$CONDA_EXE" env create \
        --name "$ENVIRONMENT_NAME" \
        --file "$ENVIRONMENT_FILE" \
        --quiet; then
        rm -f "$ENVIRONMENT_FILE"
        die "Could not create the Python environment '$ENVIRONMENT_NAME'."
    fi

    rm -f "$ENVIRONMENT_FILE"

    environment_exists \
        || die "The environment '$ENVIRONMENT_NAME' was not found after creation."

    printf 'Python environment ready: %s\n' "$ENVIRONMENT_NAME"
else
    printf 'Python environment detected: %s\n' "$ENVIRONMENT_NAME"
fi

# -----------------------------------------------------------------------------
# Bootstrap TD (optional)
# -----------------------------------------------------------------------------

if [[ -n "$BOOTSTRAP_TD" ]]; then
    write_step "Bootstrapping TD $BOOTSTRAP_TD"

    BOOTSTRAP_URL="${REPO_BASE_URL}/setup/bootstrap_td.py"
    BOOTSTRAP_FILE="$(mktemp "${TMPDIR:-/tmp}/bootstrap_td.XXXXXX")" \
        || die "Could not create a temporary file."

    trap 'rm -f "${BOOTSTRAP_FILE:-}"' EXIT

    download_file "$BOOTSTRAP_URL" "$BOOTSTRAP_FILE"

    if ! PYTHONUTF8=1 PYTHONIOENCODING=utf-8 \
        "$CONDA_EXE" run --no-capture-output \
            --name "$ENVIRONMENT_NAME" \
            python -u "$BOOTSTRAP_FILE" "$BOOTSTRAP_TD"; then
        die "Bootstrap failed for TD '$BOOTSTRAP_TD'."
    fi

    rm -f "$BOOTSTRAP_FILE"
    trap - EXIT
fi

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

write_step "Tout est en ordre !"

printf '\nLe dossier de travail intro-python est situé dans :\n'
printf '    %s\n' "$COURSE_DIRECTORY"

if [[ -n "$BOOTSTRAP_TD" ]]; then
    printf 'Il contient les fichiers du TD %s.\n' "$BOOTSTRAP_TD"
fi

printf '\nPour lancer JupyterLab, exécutez :\n\n'
printf '    cd ~/intro-python\n'
printf '    conda activate %s\n' "$ENVIRONMENT_NAME"
printf '    jupyter lab\n'
printf '\n'
