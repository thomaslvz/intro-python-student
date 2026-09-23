# ============================================================================
# Intro Python - Setup script Windows 11
# ============================================================================

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------

# Repository containing the course files.
$repoBaseUrl = "https://raw.githubusercontent.com/thomaslvz/intro-python-student/main"

$environmentUrl = "$repoBaseUrl/environment.yml"
$checkSetupUrl = "$repoBaseUrl/setup/check_setup.py"




# Error message displayed when Conda is not available.
# This can be overridden before running the script:
#   $env:INTRO_PYTHON_CONDA_ERROR = "Please install Miniconda first."
if (-not $env:INTRO_PYTHON_CONDA_ERROR) {
    $env:INTRO_PYTHON_CONDA_ERROR = @"
Miniconda ne semble pas installé sur cette machine.
Procédez d'abord à l'installation de Miniconda, puis relancez ce script.
"@
}

# ----------------------------------------------------------------------------
# Helper functions
# ----------------------------------------------------------------------------

function Write-Step {
    param (
        [string]$Message
    )

    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Stop-Script {
    param (
        [string]$Message
    )

    Write-Host ""
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

# ----------------------------------------------------------------------------
# Check Conda
# ----------------------------------------------------------------------------

Write-Step "Checking Conda installation"

try {
    $condaVersion = conda --version 2>&1

    if ($LASTEXITCODE -ne 0) {
        throw "Conda command returned exit code $LASTEXITCODE."
    }

    Write-Host "Conda found: $condaVersion" -ForegroundColor Green
}
catch {
    Stop-Script $env:INTRO_PYTHON_CONDA_ERROR
}

# ----------------------------------------------------------------------------
# Select machine type
# ----------------------------------------------------------------------------

Write-Step "Selecting machine type"

Write-Host "Sur quel type d'ordinateur êtes-vous actuellement ?"
Write-Host ""
Write-Host "  1 - Ordinateur personnel"
Write-Host "  2 - Ordinateur de l'UGA"
Write-Host ""

$machineType = Read-Host "Entrez 1 ou 2"

switch ($machineType) {
    "1" {
        $courseDirectory = Join-Path $HOME "intro-python"
    }

    "2" {
        Write-Step "Looking for the network home drive"

        $drive = (
            Get-PSDrive -PSProvider FileSystem |
            Where-Object {
                $_.DisplayRoot -and
                $_.DisplayRoot -like "*home*$env:USERNAME*"
            }
        ).Name

        if (-not $drive) {
            Stop-Script "Could not find the network home drive for user '$env:USERNAME'."
        }

        if ($drive.Count -gt 1) {
            Stop-Script "Multiple network home drives were found for user '$env:USERNAME'."
        }

        $courseDirectory = "${drive}:\intro-python"
    }

    default {
        Stop-Script "Invalid choice. Please enter 1 or 2."
    }
}

Write-Host "Course directory: $courseDirectory" -ForegroundColor Green

# ----------------------------------------------------------------------------
# Create and enter the course directory
# ----------------------------------------------------------------------------

Write-Step "Preparing course directory"

try {
    New-Item -ItemType Directory -Path $courseDirectory -Force -ErrorAction Stop | Out-Null
    Set-Location -Path $courseDirectory -ErrorAction Stop

    Write-Host "Working directory: $(Get-Location)" -ForegroundColor Green
}
catch {
    Stop-Script "Could not create or access '$courseDirectory'. Details: $($_.Exception.Message)"
}

# ----------------------------------------------------------------------------
# Configure Miniconda repositories
# ----------------------------------------------------------------------------

Write-Step "Accepting Anaconda repository Terms of Service"

$condaChannels = @(
    "https://repo.anaconda.com/pkgs/main"
    "https://repo.anaconda.com/pkgs/r"
    "https://repo.anaconda.com/pkgs/msys2"
)

foreach ($channel in $condaChannels) {
    Write-Host "Accepting TOS for: $channel"

    conda tos accept --override-channels --channel $channel

    if ($LASTEXITCODE -ne 0) {
        Stop-Script "Failed to accept the Terms of Service for '$channel'."
    }
}

# ----------------------------------------------------------------------------
# Python environment creation
# ----------------------------------------------------------------------------

$environmentFile = Join-Path $courseDirectory "environment.yml"

Write-Step "Downloading Python environment definition"

try {
    Invoke-WebRequest `
        -Uri $environmentUrl `
        -OutFile $environmentFile `
        -ErrorAction Stop
}
catch {
    if (Test-Path $environmentFile) {
        Remove-Item -Force $environmentFile
    }

    Stop-Script "Could not download environment.yml. Details: $($_.Exception.Message)"
}

Write-Step "Creating Python environment"

conda env create -f $environmentFile --quiet

if ($LASTEXITCODE -ne 0) {
    Remove-Item -Force $environmentFile
    Stop-Script "Could not create the Python environment."
}

Remove-Item -Force $environmentFile

# ----------------------------------------------------------------------------
# Run setup check
# ----------------------------------------------------------------------------

$checkSetupFile = Join-Path $courseDirectory "check_setup.py"
Write-Step "Downloading setup check"

try {
    Invoke-WebRequest `
        -Uri $checkSetupUrl `
        -OutFile $checkSetupFile `
        -ErrorAction Stop
}
catch {
    if (Test-Path $checkSetupFile) {
        Remove-Item -Force $checkSetupFile
    }

    Stop-Script "Could not download check_setup.py. Details: $($_.Exception.Message)"
}

Write-Step "Running setup check"

conda run -n intro-python-feg-l3 python $checkSetupFile

$setupCheckExitCode = $LASTEXITCODE

Remove-Item -Force $checkSetupFile

if ($setupCheckExitCode -ne 0) {
    Stop-Script "The setup check failed."
}

# ----------------------------------------------------------------------------
# Initialization of the course directory
# ----------------------------------------------------------------------------

Write-Step "Populating the course directory"

New-Item -ItemType Directory -Force ./data
New-Item -ItemType File -Force ./data/sample.txt
New-Item -ItemType Directory -Force ./td

# Bootstrap TD1
$td = "01"
conda run -n intro-python-feg-l3 python -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '$td']; exec(urllib.request.urlopen('$repoBaseUrl/setup/bootstrap_td.py').read())"

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
Write-Host "Le dossier de travail est localisé dans $courseDirectory." -ForegroundColor Green
