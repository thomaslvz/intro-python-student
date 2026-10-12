### Instructions
# Execute this script in a powershell terminal.
# It will check if the conda environment and the file structure are correctly set up for the course.
# If not, it will set them up.
# When the script stops with no errors, the prompt is located in the course directory.
#
# Steps included:
# 1. Check if conda is installed
# 2. Check if the conda environment is installed
# 3. Check if the course directory is set up (automatically detects UGA domain if existing)
#
# Params:
# -CondaPath: Path to the conda executable (to force conda command localization)
# -ForceCourseDirectory: Force the course directory to be (re)set up
# -ForceEnvironment: Force the conda environment to be (re)installed
#
# Examples :
# 1) Without parameters (recommended)
# Invoke-RestMethod 'https://raw.githubusercontent.com/URL' | Invoke-Expression
# 2) With parameters
# $ScriptPath = Join-Path $env:TEMP "script.ps1"
# Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/URL' -OutFile $ScriptPath
# & $ScriptPath -ForceCourseDirectory -CondaPath "C:/conda"


# ----------------------------------------------------------------------------
# Command-line options
# ----------------------------------------------------------------------------

param (
    [string]$CondaPath,
    [switch]$ForceCourseDirectory,
    [switch]$ForceEnvironment,
    [string]$BootstrapTD
)

# ----------------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------------

$repoBaseUrl = "https://raw.githubusercontent.com/thomaslvz/intro-python-student/main"

# Keep your existing $repoBaseUrl definition above this configuration.
$environmentUrl = "$repoBaseUrl/environment.yml"
$environmentName = "intro-python-feg-l3"
$universityDomainPattern = "ad.u-ga.fr*home"

$condaMissingMessage = @"
Il faut installer Miniconda ou Anaconda sur cet ordinateur pour ce cours.

Téléchargez et installez Anaconda ou Miniconda depuis :
https://www.anaconda.com/download/success?reg=skipped


"@
# ----------------------------------------------------------------------------
# Helper functions
# ----------------------------------------------------------------------------

function Write-Step {
    param ([string]$Message)

    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-WarningMessage {
    param ([string]$Message)

    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Stop-Script {
    param ([string]$Message)

    Write-Host ""
    Write-Host "ERROR: $Message" -ForegroundColor Red
    throw $Message
}

function Test-Executable {
    param ([string]$Path)

    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $false
    }

    try {
        & $Path --version 2>$null | Out-Null
        return ($LASTEXITCODE -eq 0)
    }
    catch {
        return $false
    }
}

function Find-StandardCondaInstallations {

    $installations = @()

    $standardPaths = @(
        (Join-Path $HOME "anaconda3"),
        (Join-Path $HOME "miniconda3"),
        (Join-Path $env:LOCALAPPDATA "anaconda3"),
        (Join-Path $env:LOCALAPPDATA "miniconda3"),
        (Join-Path $env:ProgramData "anaconda3"),
        (Join-Path $env:ProgramData "miniconda3")
    )

    foreach ($basePath in $standardPaths) {

        $condaExe = Join-Path $basePath "Scripts\conda.exe"

        if (Test-Executable $condaExe) {
            $installations += $condaExe
        }
    }

    return @($installations | Sort-Object -Unique)
}

function Get-CourseDirectory {
    param (
        [bool]$UniversityDriveDetected,
        [string]$DomainPattern
    )

    if ($UniversityDriveDetected) {
        $matchingDrives = @(
            Get-PSDrive -PSProvider FileSystem |
                Where-Object {
                    $_.DisplayRoot -and
                    $_.DisplayRoot -like "*$DomainPattern*$env:USERNAME*"
                }
        )

        if ($matchingDrives.Count -gt 1) {
            Stop-Script "Multiple UGA home drives were found. Resolve the drive mapping before proceeding."
        }

        if ($matchingDrives.Count -eq 1) {
            return "$($matchingDrives[0].Name):\intro-python"
        }

        Write-WarningMessage "The UGA domain was detected, but no matching network home drive was found."
    }

    return (Join-Path $HOME "intro-python")
}

function New-CourseDirectory {
    param (
        [string]$RootPath
    )

    Write-Step "Preparing course directory"

    try {
        New-Item -ItemType Directory -Path $RootPath -Force -ErrorAction Stop |
            Out-Null

        New-Item -ItemType Directory -Path (Join-Path $RootPath "data") -Force -ErrorAction Stop |
            Out-Null

        New-Item -ItemType Directory -Path (Join-Path $RootPath "td") -Force -ErrorAction Stop |
            Out-Null

        New-Item -ItemType File -Path (Join-Path $RootPath "data\sample.txt") -Force -ErrorAction Stop |
            Out-Null
    }
    catch {
        Stop-Script "Could not prepare '$RootPath'. Details: $($_.Exception.Message)"
    }

    Write-Host "Course directory ready: $RootPath" -ForegroundColor Green
}

function Test-CourseDirectory {
    param ([string]$RootPath)

    return (
        (Test-Path -LiteralPath $RootPath -PathType Container) -and
        (Test-Path -LiteralPath (Join-Path $RootPath "td") -PathType Container)
    )
}

function Test-CondaEnvironment {
    param (
        [string]$CondaExe,
        [string]$EnvironmentName
    )

    try {
        $environmentList = & $CondaExe env list --json 2>$null

        if ($LASTEXITCODE -ne 0) {
            return $false
        }

        $environmentInfo = $environmentList | ConvertFrom-Json

        foreach ($environmentPath in $environmentInfo.envs) {
            if ((Split-Path $environmentPath -Leaf) -eq $EnvironmentName) {
                return $true
            }
        }

        return $false
    }
    catch {
        return $false
    }
}

function New-PythonEnvironment {
    param (
        [string]$CondaExe,
        [string]$EnvironmentFile,
        [string]$EnvironmentName,
        [string]$DefinitionUrl,
        [bool]$Force
    )

    Write-Step "Preparing Python environment"

    if ($Force -and (Test-CondaEnvironment $CondaExe $EnvironmentName)) {
        Write-WarningMessage "Removing the existing environment '$EnvironmentName'. Its installed packages will be deleted."

        & $CondaExe env remove --name $EnvironmentName --yes

        if ($LASTEXITCODE -ne 0) {
            Stop-Script "Could not remove the existing environment '$EnvironmentName'."
        }
    }

    try {
        Write-Host "Downloading environment definition..."

        Invoke-WebRequest `
            -Uri $DefinitionUrl `
            -OutFile $EnvironmentFile `
            -ErrorAction Stop
    }
    catch {
        if (Test-Path $EnvironmentFile) {
            Remove-Item -LiteralPath $EnvironmentFile -Force
        }

        Stop-Script "Could not download environment.yml. Details: $($_.Exception.Message)"
    }

    try {
        # Accept Anaconda channel terms before creating the environment.
        & $CondaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
        & $CondaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
        & $CondaExe tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2

        Write-Host "Creating Python environment..."

        & $CondaExe env create `
            --name $EnvironmentName `
            --file $EnvironmentFile `
            --quiet

        if ($LASTEXITCODE -ne 0) {
            Stop-Script "Could not create the Python environment '$EnvironmentName'."
        }
    }
    finally {
        if (Test-Path $EnvironmentFile) {
            Remove-Item -LiteralPath $EnvironmentFile -Force -ErrorAction SilentlyContinue
        }
    }

    if (-not (Test-CondaEnvironment $CondaExe $EnvironmentName)) {
        Stop-Script "The environment '$EnvironmentName' was not found after creation."
    }

    Write-Host "Python environment ready: $EnvironmentName" -ForegroundColor Green
}

# ----------------------------------------------------------------------------
# Main script
# ----------------------------------------------------------------------------

Write-Step "Checking university domain"

$universityDriveDetected = [bool](
    Get-PSDrive -PSProvider FileSystem |
        Where-Object {
            $_.DisplayRoot -and
            $_.DisplayRoot -like "*$universityDomainPattern*$env:USERNAME*"
        } |
        Select-Object -First 1
)

if ($universityDriveDetected) {
    Write-Host "UGA network home drive detected." -ForegroundColor Green
}
else {
    Write-Host "No UGA network home drive detected."
}
# ----------------------------------------------------------------------------
# Find and validate Conda
# ----------------------------------------------------------------------------

Write-Step "Looking for Conda"

$condaExe = $null
$pathConda = Get-Command conda -ErrorAction SilentlyContinue |
    Select-Object -First 1

# 1. Explicit path takes priority.
if ($CondaPath) {

    if (-not (Test-Executable $CondaPath)) {
        Stop-Script "The specified Conda executable does not exist or cannot be executed: '$CondaPath'."
    }

    $condaExe = (Resolve-Path -LiteralPath $CondaPath).Path
}

# 2. Otherwise, use Conda from PATH if it is executable.
elseif ($pathConda -and $pathConda.Source -and
        (Test-Executable $pathConda.Source)) {

    $condaExe = $pathConda.Source
}

# 3. Otherwise, search standard installation locations.
else {

    $installations = @(Find-StandardCondaInstallations)

    if ($installations.Count -eq 1) {
        $condaExe = $installations[0]
    }
    elseif ($installations.Count -gt 1) {

        Write-Host "Multiple Conda installations were found:" -ForegroundColor Yellow

        foreach ($installation in $installations) {
            Write-Host "  $installation"
        }

        Stop-Script "Please choose a Conda installation and rerun the script with -CondaPath."
    }
    else {

        Write-WarningMessage "No Conda installation was found."

        Stop-Script $condaMissingMessage

    }
}

# 4. Report the selected executable.
Write-Host "Conda found at: $condaExe" -ForegroundColor Green

if ($pathConda -and $pathConda.Source -and
    $pathConda.Source -ieq $condaExe) {

    Write-Host "Conda is available in PATH." -ForegroundColor Green
}
else {
    Write-WarningMessage "Conda is not available in PATH. You will have to use Anaconda PowerShell Prompt."
}

# ----------------------------------------------------------------------------
# Find or create course directory
# ----------------------------------------------------------------------------

Write-Step "Checking course directory"

$courseDirectory = Get-CourseDirectory `
    -UniversityDriveDetected $universityDriveDetected `
    -DomainPattern $universityDomainPattern

if ($ForceCourseDirectory -or -not (Test-CourseDirectory $courseDirectory)) {
    if (-not (Test-Path -LiteralPath $courseDirectory -PathType Container)) {
        Write-Host "Course directory is not configured."
    }
    else {
        Write-WarningMessage "The course directory is incomplete or recreation was requested."
    }

    New-CourseDirectory -RootPath $courseDirectory
}
else {
    Write-Host "Course directory detected: $courseDirectory" -ForegroundColor Green
}

try {
    Set-Location -LiteralPath $courseDirectory -ErrorAction Stop
}
catch {
    Stop-Script "Could not access '$courseDirectory'. Details: $($_.Exception.Message)"
}

# ----------------------------------------------------------------------------
# Find or create Python environment
# ----------------------------------------------------------------------------

Write-Step "Checking Python environment"

$environmentExists = Test-CondaEnvironment `
    -CondaExe $condaExe `
    -EnvironmentName $environmentName

if ($ForceEnvironment -or -not $environmentExists) {
    if (-not $environmentExists) {
        Write-Host "Python environment '$environmentName' is not configured."
    }

    New-PythonEnvironment `
        -CondaExe $condaExe `
        -EnvironmentFile (Join-Path $courseDirectory "environment.yml") `
        -EnvironmentName $environmentName `
        -DefinitionUrl $environmentUrl `
        -Force ([bool]$ForceEnvironment)
}
else {
    Write-Host "Python environment detected: $environmentName" -ForegroundColor Green
}

# ----------------------------------------------------------------------------
# Bootstrap TD (optional)
# ----------------------------------------------------------------------------

if ($BootstrapTD) {
    Write-Step "Bootstrapping TD $BootstrapTD"

    $bootstrapUrl = "$repoBaseUrl/setup/bootstrap_td.py"
    $bootstrapFile = Join-Path $env:TEMP "bootstrap_td.py"

    try {
        Invoke-WebRequest `
            -Uri $bootstrapUrl `
            -OutFile $bootstrapFile `
            -ErrorAction Stop
    }
    catch {
        Stop-Script "Could not download bootstrap_td.py. Details: $($_.Exception.Message)"
    }

    try {
        & $condaExe run `
            --name $environmentName `
            python $bootstrapFile $BootstrapTD

        if ($LASTEXITCODE -ne 0) {
            Stop-Script "Bootstrap failed for TD '$BootstrapTD'."
        }
    }
    finally {
        Remove-Item -LiteralPath $bootstrapFile -Force -ErrorAction SilentlyContinue
    }
}

# ----------------------------------------------------------------------------
# Done
# ----------------------------------------------------------------------------

Write-Step "Tout est en ordre ! ✅"
Write-Host ""
Write-Host "📂 Le dossier de travail intro-python est situé dans :" -ForegroundColor Green
Write-Host "    $courseDirectory" -ForegroundColor Green
if ($BootstrapTD) {
    Write-Host "Il contient désormais les fichiers du TD $BootstrapTD." -ForegroundColor Green
}
Write-Host ""
Write-Host "🖥️ Vous pouvez lancer JupyterLab depuis l'application Anaconda PowerShell Prompt, avec les commandes :" -ForegroundColor Green
Write-Host ""
Write-Host "    conda activate $environmentName" -ForegroundColor Green
Write-Host "    jupyter lab" -ForegroundColor Green
