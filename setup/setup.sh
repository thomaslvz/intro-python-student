#!/usr/bin/env bash

# ============================================================================
# Intro Python - Setup script for Linux and macOS
# ==============================s==============================================



# Repository containing the course files.
repoBaseUrl="https://raw.githubusercontent.com/thomaslvz/intro-python-student/main"

environmentUrl="$repoBaseUrl/environment.yml"
checkSetupUrl="$repoBaseUrl/setup/check_setup.py"
bootstrapUrl="$repoBaseUrl/setup/bootstrap_td.py"

# ----------------------------------------------------------------------------
# Error message displayed when Conda is not available.
# This can be overridden before running the script:
#   export INTRO_PYTHON_CONDA_ERROR="Please install Miniconda first."
# ----------------------------------------------------------------------------

if [ -z "${INTRO_PYTHON_CONDA_ERROR:-}" ]; then
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
# Temporary files
# ----------------------------------------------------------------------------

environmentFile="$course_directory/.intro-python-environment.yml"
checkSetupFile="$course_directory/.intro-python-check_setup.py"

# Always remove temporary setup files when the script exits.
cleanup() {
    rm -f "$environmentFile" "$checkSetupFile"
}

trap cleanup EXIT


# ----------------------------------------------------------------------------
# Python environment creation
# ----------------------------------------------------------------------------

write_step "Downloading Python environment definition"

if ! curl -fsSL "$environmentUrl" -o "$environmentFile"; then
    stop_script "Could not download environment.yml."
fi

write_step "Creating Python environment"

conda env create -f "$environmentFile" --quiet

if [ $? -ne 0 ]; then
    stop_script "Could not create the Python environment."
fi

# ----------------------------------------------------------------------------
# Initialization of the course directory
# ----------------------------------------------------------------------------

write_step "Populating the course directory"

mkdir -p ./data
touch ./data/sample.txt
mkdir -p ./td

# ----------------------------------------------------------------------------
# Run setup check
# ----------------------------------------------------------------------------

write_step "Downloading setup check"

if ! curl -fsSL "$checkSetupUrl" -o "$checkSetupFile"; then
    stop_script "Could not download check_setup.py."
fi

write_step "Running setup check"

conda run -n intro-python-feg-l3 python "$checkSetupFile"

setupCheckExitCode=$?

if [ "$setupCheckExitCode" -ne 0 ]; then
    stop_script "The setup check failed."
fi

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------

echo
echo "Le dossier de travail de ce cours est : $course_directory"
