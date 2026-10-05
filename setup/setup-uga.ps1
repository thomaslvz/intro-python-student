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
# Finding network drive
# ----------------------------------------------------------------------------

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


# ----------------------------------------------------------------------------
# Create and enter the course directory
# ----------------------------------------------------------------------------

Write-Step "Preparing course directory"


$courseDirectory = "${drive}:\intro-python"


Write-Host "Course directory: $courseDirectory" -ForegroundColor Green

try {
    New-Item -ItemType Directory -Path $courseDirectory -Force -ErrorAction Stop | Out-Null
    Set-Location -Path $courseDirectory -ErrorAction Stop

    Write-Host "Working directory: $(Get-Location)" -ForegroundColor Green
}
catch {
    Stop-Script "Could not create or access '$courseDirectory'. Details: $($_.Exception.Message)"
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
# Initialization of the course directory
# ----------------------------------------------------------------------------

Write-Step "Populating the course directory"

New-Item -ItemType Directory -Force ./data
New-Item -ItemType File -Force ./data/sample.txt
New-Item -ItemType Directory -Force ./td

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
Write-Host "Le dossier de travail est localisé dans $courseDirectory." -ForegroundColor Green
