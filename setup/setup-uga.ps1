# ============================================================================
# Intro Python - Setup script Windows 11
# ============================================================================

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------

# Repository containing the course files.
$repoBaseUrl = "https://raw.githubusercontent.com/thomaslvz/intro-python-student/main"

$environmentUrl = "$repoBaseUrl/environment.yml"
$environmentName = "intro-python-feg-l3"
$checkSetupUrl = "$repoBaseUrl/setup/check_setup.py"
$universityDomainPattern = "ad.u-ga.fr*home"

# ----------------------------------------------------------------------------
# Command-line options
# ----------------------------------------------------------------------------

$skipDir = $args -contains "--SkipDir"
$skipEnv = $args -contains "--SkipEnv"
$skipCheck = $args -contains "--SkipCheck"

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
    # User installation
    (Join-Path $HOME "anaconda3"),
    (Join-Path $HOME "miniconda3"),

    # User-local installation
    (Join-Path $env:LOCALAPPDATA "anaconda3"),
    (Join-Path $env:LOCALAPPDATA "miniconda3"),

    # System-wide installation
    (Join-Path $env:ProgramData "anaconda3"),
    (Join-Path $env:ProgramData "miniconda3")
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

function Test-CondaEnvironment {
    param (
        [string]$CondaExe,
        [string]$EnvironmentName
    )

    $environmentList = & $CondaExe env list --json 2>$null

    if ($LASTEXITCODE -ne 0) {
        return $false
    }

    $environmentInfo = $environmentList | ConvertFrom-Json

    return $environmentInfo.envs |
        Where-Object {
            (Split-Path $_ -Leaf) -eq $EnvironmentName
        }
}

# ----------------------------------------------------------------------------
# Finding conda installation
# ----------------------------------------------------------------------------



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
# Finding UGA network drive
# ----------------------------------------------------------------------------

Write-Step "Looking for UGA network home drive"

$drive = (
    Get-PSDrive -PSProvider FileSystem |
    Where-Object {
        $_.DisplayRoot -and
        $_.DisplayRoot -like "*$universityDomainPattern*$env:USERNAME*"
    }
).Name

if ($drive) {
    Write-Host "Network drive found at ${drive}."
    $courseDirectory = "${drive}:\intro-python"
}
else {
    Write-Host "Could not find the UGA network home drive for user '$env:USERNAME'."
    Write-Host "Will use Home directory instead."
    $courseDirectory = "${HOME}\intro-python"
}

if ($drive.Count -gt 1) {
    Stop-Script "Multiple network home drives were found for user '$env:USERNAME'."
}


# ----------------------------------------------------------------------------
# Create and enter the course directory
# ----------------------------------------------------------------------------

Write-Step "Preparing course directory"

if ($skipDir) {

    if (-not (Test-Path $courseDirectory -PathType Container)) {
        Stop-Script "The course directory does not exist: $courseDirectory. You cannot run this script with --SkipDir flag."
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
# Initialization of the course directory
# ----------------------------------------------------------------------------


if (-not $skipDir) {

    Write-Step "Populating the course directory"

    New-Item -ItemType Directory -Force ./data
    New-Item -ItemType File -Force ./data/sample.txt
    New-Item -ItemType Directory -Force ./td
}
else {
    Write-Host "Skipping course directory creation and population." -ForegroundColor Yellow
}

# ----------------------------------------------------------------------------
# Python environment creation
# ----------------------------------------------------------------------------

Write-Step "Python environment creation"

$environmentExists = Test-CondaEnvironment `
    -CondaExe $condaExe `
    -EnvironmentName $environmentName

if ($skipEnv) {

    if (-not $environmentExists) {
        Stop-Script "The Python environment '$environmentName' does not exist. You cannot run this script with the --SkipEnv flag."
    }

    Write-Host "Python environment '$environmentName' already exists. Skipping creation." -ForegroundColor Yellow
}
else {

    $environmentFile = Join-Path $courseDirectory "environment.yml"

    Write-Host "Downloading Python environment definition"

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

    Write-Host "Creating Python environment"

    & $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
    & $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
    & $condaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2

    & $condaExe env create -f $environmentFile --quiet

    if ($LASTEXITCODE -ne 0) {
        Remove-Item -Force $environmentFile
        Stop-Script "Could not create the Python environment."
    }

    Remove-Item -Force $environmentFile
}

# ----------------------------------------------------------------------------
# Run setup check
# ----------------------------------------------------------------------------

Write-Step "Setup check"


if (-not $skipCheck) {

    $checkSetupFile = Join-Path $courseDirectory "check_setup.py"

    Write-Host "Downloading setup check"

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

    Write-Host "Running setup check"

    & $condaExe run --no-capture-output `
        -n $environmentName `
        python -X utf8 $checkSetupFile

    $setupCheckExitCode = $LASTEXITCODE

    Remove-Item -Force $checkSetupFile

    if ($setupCheckExitCode -ne 0) {
        Stop-Script "The setup check failed."
    }
}
else {
    Write-Host "Skipping setup check." -ForegroundColor Yellow
}


# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------
Write-Host "Le dossier de travail est localisé dans $courseDirectory." -ForegroundColor Green
