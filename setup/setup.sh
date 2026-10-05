#!/usr/bin/env bash

# ============================================================================
# Intro Python - Setup script for Linux and macOS
# ==============================s==============================================



# Repository containing the course files.
repoBaseUrl="https://raw.githubusercontent.com/thomaslvz/intro-python-student/main"

environmentUrl="$repoBaseUrl/environment.yml"
environmentName="intro-python-feg-l3"
checkSetupUrl="$repoBaseUrl/setup/check_setup.py"
courseDirectory="$HOME/intro-python"

environmentFile=""
checkSetupFile=""
# Always remove temporary setup files when the script exits.
cleanup() {
    rm -f "$environmentFile" "$checkSetupFile"
}

trap cleanup EXIT

# ----------------------------------------------------------------------------
# Command-line options
# ----------------------------------------------------------------------------

skipDir=false
skipEnv=false
skipCheck=false

for arg in "$@"; do
    case "$arg" in
        --SkipDir)
            skipDir=true
            ;;
        --SkipEnv)
            skipEnv=true
            ;;
        --SkipCheck)
            skipCheck=true
            ;;
    esac
done

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

write_step "Looking for conda installation"

if ! conda_version=$(conda --version 2>&1); then
    echo "No Conda installation found in PATH."
    stop_script "Please install Anaconda (or miniconda), add it to PATH, and run this script again."
fi

echo "Conda: $conda_version"

# ----------------------------------------------------------------------------
# Create and enter the course directory
# ----------------------------------------------------------------------------

write_step "Preparing course directory"


if $skipDir; then

    if [[ ! -d "$courseDirectory" ]]; then
        stop_script "The course directory does not exist: $courseDirectory. You cannot run this script with the --SkipDir flag."
    fi

    echo "Course directory found: $courseDirectory"

else

    if ! mkdir -p "$courseDirectory"; then
        stop_script "Could not create '$courseDirectory'."
    fi

    echo "Course directory: $courseDirectory"
fi

if ! cd "$courseDirectory"; then
    stop_script "Could not access '$courseDirectory'."
fi

echo "Working directory: $(pwd)"


# ----------------------------------------------------------------------------
# Initialization of the course directory
# ----------------------------------------------------------------------------

write_step "Populating the course directory"

if ! $skipDir; then

    if ! mkdir -p ./data ./td; then
        stop_script "Could not create the course directories."
    fi

    if ! touch ./data/sample.txt; then
        stop_script "Could not create ./data/sample.txt."
    fi

else
    echo "Skipped by user."
fi


# ----------------------------------------------------------------------------
# Python environment creation
# ----------------------------------------------------------------------------

write_step "Downloading Python environment definition"

environmentExists=false

if conda env list | awk '{print $1}' | grep -Fxq "$environmentName"; then
    environmentExists=true
fi

if $skipEnv; then

    if ! $environmentExists; then
        stop_script "The Python environment '$environmentName' does not exist. You cannot run this script with the --SkipEnv flag."
    fi

    echo "Skipped by user (python environment '$environmentName' already exists)."

else

    environmentFile="$courseDirectory/.environment.yml"


    if ! curl -fsSL "$environmentUrl" -o "$environmentFile"; then
        stop_script "Could not download environment.yml."
    fi


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

    write_step "Creating Python environment"

    if ! conda env create -f "$environmentFile" --quiet; then
        stop_script "Could not create the Python environment."
    fi
fi



# ----------------------------------------------------------------------------
# Run setup check
# ----------------------------------------------------------------------------


write_step "Setup check"


if ! $skipCheck; then

    checkSetupFile="$courseDirectory/.check_setup.py"

    echo "Downloading setup check"

    if ! curl -fsSL "$checkSetupUrl" -o "$checkSetupFile"; then
        stop_script "Could not download check_setup.py."
    fi

    echo "Running setup check"

    conda run --no-capture-output \
        -n "$environmentName" \
        python -X utf8 "$checkSetupFile"

    setupCheckExitCode=$?

    if [[ $setupCheckExitCode -ne 0 ]]; then
        stop_script "The setup check failed."
    fi

else
    echo "Skipped by user."
fi


# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------

echo
echo "Le dossier de travail de ce cours est : $courseDirectory"
