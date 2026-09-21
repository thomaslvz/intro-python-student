#!/usr/bin/env bash

# ============================================================================
# Intro Python - Setup script for Linux and macOS
# ============================================================================

set -o pipefail

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------

# Repository containing the course/bootstrap code.
INTRO_PYTHON_REPO_URL="https://raw.githubusercontent.com/thomaslvz/intro-python-student"

# Error message displayed when Conda is not available.
if [[ -z "${INTRO_PYTHON_CONDA_ERROR:-}" ]]; then
    INTRO_PYTHON_CONDA_ERROR="Miniconda ne semble pas installé sur cette machine.
Procédez d'abord à l'installation de Miniconda, puis relancez ce script."
fi

# ----------------------------------------------------------------------------
# Helper functions
# ----------------------------------------------------------------------------

write_step() {
    echo
    echo "==> $1"
}

stop_script() {
    echo
    echo "ERROR: $1" >&2
    exit 1
}

# ----------------------------------------------------------------------------
# Check Conda
# ----------------------------------------------------------------------------

write_step "Checking Conda installation"

if ! conda_version=$(conda --version 2>&1); then
    stop_script "$INTRO_PYTHON_CONDA_ERROR"
fi

echo "Conda found: $conda_version"

# ----------------------------------------------------------------------------
# Create and enter the course directory
# ----------------------------------------------------------------------------

write_step "Preparing course directory"

course_directory="$HOME/intro-python"

if ! mkdir -p "$course_directory"; then
    stop_script "Could not create or access '$course_directory'."
fi

if ! cd "$course_directory"; then
    stop_script "Could not enter '$course_directory'."
fi

echo "Working directory: $(pwd)"

# ----------------------------------------------------------------------------
# Configure Conda repositories
# ----------------------------------------------------------------------------

write_step "Accepting Anaconda repository Terms of Service"

conda_channels=(
    "https://repo.anaconda.com/pkgs/main"
    "https://repo.anaconda.com/pkgs/r"
)

for channel in "${conda_channels[@]}"; do
    echo "Accepting TOS for: $channel"

    if ! conda tos accept --override-channels --channel "$channel"; then
        stop_script "Failed to accept the Terms of Service for '$channel'."
    fi
done

# ----------------------------------------------------------------------------
# Run bootstrap script
# ----------------------------------------------------------------------------

write_step "Running course bootstrap"

bootstrap_url="${INTRO_PYTHON_REPO_URL%/}/refs/heads/main/bootstrap.py"

echo "Bootstrap URL: $bootstrap_url"

if ! conda run -n base python -c "
import urllib.request
exec(urllib.request.urlopen('$bootstrap_url').read())
"; then
    stop_script "The course bootstrap script failed."
fi

echo
echo "Bootstrap completed successfully in $course_directory."

# ----------------------------------------------------------------------------
# Python environment creation
# ----------------------------------------------------------------------------

write_step "Python environment creation"

if ! conda env create \
    -f ./intro-python-student/environment.yml \
    --quiet; then

    stop_script "Failed to create the Python environment."
fi

# ----------------------------------------------------------------------------
# Run setup check
# ----------------------------------------------------------------------------

write_step "Running setup check"

if ! conda run -n intro-python-feg-l3 \
    python ./intro-python-student/check_setup.py; then

    stop_script "The setup check failed."
fi

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------

echo
echo "Working directory: $course_directory"