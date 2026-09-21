# ============================================================================
# Intro Python - Setup script Windows 11 UGA
# ============================================================================

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------

# Repository containing the course/bootstrap code.
$env:INTRO_PYTHON_REPO_URL = "https://raw.githubusercontent.com/thomaslvz/intro-python-student"

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
# Find the network home drive
# ----------------------------------------------------------------------------

Write-Step "Looking for the network home drive"

$drive = (
    Get-PSDrive -PSProvider FileSystem |
    Where-Object {
        $_.DisplayRoot -like "*home*$env:USERNAME*"
    }
).Name

if (-not $drive) {
    Stop-Script "Could not find the network home drive for user '$env:USERNAME'."
}

if ($drive.Count -gt 1) {
    Stop-Script "Multiple network home drives were found for user '$env:USERNAME'."
}

$drive = "${drive}:/"

Write-Host "Network home drive: $drive" -ForegroundColor Green

# ----------------------------------------------------------------------------
# Create and enter the course directory
# ----------------------------------------------------------------------------

$courseDirectory = "$drive/intro-python"

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
# Run bootstrap script
# ----------------------------------------------------------------------------

Write-Step "Running course bootstrap"

$bootstrapUrl = "$($env:INTRO_PYTHON_REPO_URL.TrimEnd('/'))/refs/heads/main/bootstrap.py"

Write-Host "Bootstrap URL: $bootstrapUrl"

conda run -n base python -c @"
import urllib.request
exec(urllib.request.urlopen('$bootstrapUrl').read())
"@

if ($LASTEXITCODE -ne 0) {
    Stop-Script "The course setup script failed with exit code $LASTEXITCODE."
}
Write-Host ""
Write-Host "Bootstrap completed successfully." -ForegroundColor Green


# ----------------------------------------------------------------------------
# Python environment creation
# ----------------------------------------------------------------------------

Write-Step "Python environment creation"

conda env create -f ./intro-python-student/environment.yml

if ($LASTEXITCODE -ne 0) {
    Stop-Script "The course setup script failed with exit code $LASTEXITCODE."
}

# ----------------------------------------------------------------------------
# Run setup check
# ----------------------------------------------------------------------------

Write-Step "Running setup check"

conda run -n intro-python-feg-l3 python ./intro-python-student/check_setup.py

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
