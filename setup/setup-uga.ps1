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

    # 3. Windows Registry
    $registryPaths = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    foreach ($registryPath in $registryPaths) {

        $entries = Get-ItemProperty `
            -Path $registryPath `
            -ErrorAction SilentlyContinue |
            Where-Object {
                $_.DisplayName -match "^(Anaconda|Miniconda)" -and
                $_.InstallLocation
            }

        foreach ($entry in $entries) {

            $basePath = $entry.InstallLocation
            $condaExe = Join-Path $basePath "Scripts\conda.exe"

            if (Test-Path $condaExe) {
                $installations += [PSCustomObject]@{
                    CondaExe = $condaExe
                    BasePath = $basePath
                    Source   = "Registry"
                    Name     = $entry.DisplayName
                }
            }
        }
    }

    # 4. Standard installation locations
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

$condaInstallations = Find-CondaInstallations

if ($condaInstallations.Count -eq 0) {
    Write-Host "No Conda installation found."
    # → installation de Miniconda
}
else {
    Write-Host "Conda installation(s) found:"

    foreach ($installation in $condaInstallations) {
        Write-Host "  $($installation.CondaExe)"
        Write-Host "  Source: $($installation.Source)"
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

& $condaExe env create -f $environmentFile --quiet

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
