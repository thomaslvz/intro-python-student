# ============================================================================
# Intro Python - Setup script Windows 11
# ============================================================================

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------

# Repository containing the course files.
$repoBaseUrl = "https://raw.githubusercontent.com/thomaslvz/intro-python-student/main"

$environmentUrl = "$repoBaseUrl/environment.yml"
$environmentName = "intro-python-l3-feg"
$checkSetupUrl = "$repoBaseUrl/setup/check_setup.py"

# ----------------------------------------------------------------------------
# Command-line options
# ----------------------------------------------------------------------------

$envOnly = $args -contains "--EnvOnly"

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
# Finding conda installation
# ----------------------------------------------------------------------------


function Find-CondaInstallations {

    $installations = @()

    # 1. CONDA_EXE environment variable
    if ($env:CONDA_EXE -and (Test-Path $env:CONDA_EXE)) {
        $installations += [PSCustomObject]@{
            CondaExe = $env:CONDA_EXE
            BasePath = Split-Path (Split-Path $env:CONDA_EXE)
            Source   = "CONDA_EXE"
        }
    }

    # 2. Conda available in PATH
    $condaCommand = Get-Command conda -ErrorAction SilentlyContinue

    if ($condaCommand) {
        $condaExe = $condaCommand.Source

        if (Test-Path $condaExe) {
            $installations += [PSCustomObject]@{
                CondaExe = $condaExe
                BasePath = Split-Path (Split-Path $condaExe)
                Source   = "PATH"
            }
        }
    }

    # 3. Standard installation locations
    $standardPaths = @(
        (Join-Path $HOME "anaconda3"),
        (Join-Path $HOME "Anaconda3"),
        (Join-Path $HOME "miniconda3"),
        (Join-Path $HOME "Miniconda3"),
        (Join-Path $env:ProgramData "Anaconda3"),
        (Join-Path $env:ProgramData "Miniconda3")
    )

    foreach ($basePath in $standardPaths) {

        $condaExe = Join-Path $basePath "Scripts\conda.exe"

        if (Test-Path $condaExe) {
            $installations += [PSCustomObject]@{
                CondaExe = $condaExe
                BasePath = $basePath
                Source   = "Standard path"
            }
        }
    }

    # Remove duplicates
    $installations |
        Sort-Object CondaExe -Unique
}

Write-Step "Looking for conda installation"

$condaInstallations = Find-CondaInstallations

if ($condaInstallations.Count -eq 0) {
    Write-Host "No Conda installation found."
    Stop-Script "Please install Anaconda (or miniconda) and run this script again."
}
else {
    Write-Host "Conda installation(s) found:"

    foreach ($installation in $condaInstallations) {
        Write-Host "  $($installation.CondaExe)"
        Write-Host "  Source: $($installation.Source)"
    }

    $condaInstallation = $condaInstallations[0]
    $condaExe = $condaInstallation.CondaExe

    Write-Host "Conda executable: [$condaExe]"
    Write-Host "Exists: $(Test-Path $condaExe)"

    & $condaExe --version
    if ($LASTEXITCODE -ne 0) {
        Stop-Script "The detected Conda installation could not be executed."
    }
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

if ($envOnly) {

    if (-not (Test-Path $courseDirectory -PathType Container)) {
        Stop-Script "The course directory does not exist: $courseDirectory"
    }

    Write-Host "Course directory found: $courseDirectory" -ForegroundColor Green
}
else {

    try {
        New-Item `
            -ItemType Directory `
            -Path $courseDirectory `
            -Force `
            -ErrorAction Stop | Out-Null

        Write-Host "Course directory: $courseDirectory" -ForegroundColor Green
    }
    catch {
        Stop-Script "Could not create '$courseDirectory'. Details: $($_.Exception.Message)"
    }
}

try {
    Set-Location -Path $courseDirectory -ErrorAction Stop

    Write-Host "Working directory: $(Get-Location)" -ForegroundColor Green
}
catch {
    Stop-Script "Could not access '$courseDirectory'. Details: $($_.Exception.Message)"
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

& $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
& $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
& $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2

& $condaExe env create -f $environmentFile --quiet

if ($LASTEXITCODE -ne 0) {
    Remove-Item -Force $environmentFile
    Stop-Script "Could not create the Python environment."
}

Remove-Item -Force $environmentFile

if ($envOnly) {
    Write-Host ""
    Write-Host "Python environment created successfully." -ForegroundColor Green
    exit 0
}

# ----------------------------------------------------------------------------
# Initialization of the course directory
# ----------------------------------------------------------------------------

Write-Step "Populating the course directory"

New-Item -ItemType Directory -Force ./data
New-Item -ItemType File -Force ./data/sample.txt
New-Item -ItemType Directory -Force ./td


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


& $condaExe run --no-capture-output `
    -n $environmentName `
    python -X utf8 $checkSetupFile

$setupCheckExitCode = $LASTEXITCODE

Remove-Item -Force $checkSetupFile

if ($setupCheckExitCode -ne 0) {
    Stop-Script "The setup check failed."
}



# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
Write-Host "Le dossier de travail est localisé dans $courseDirectory." -ForegroundColor Green
