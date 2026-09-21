# Get network disk name
$drive=(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.DisplayRoot -like "*home*$env:USERNAME*" }).Name+':/'
# Create folder
mkdir -Force "$drive/intro-python"
cd "$drive/intro-python"
# Configure Miniconda repos
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main --channel https://repo.anaconda.com/pkgs/r --channel https://repo.anaconda.com/pkgs/msys2
# Clone course repo
conda run -n base python -c "import urllib.request; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/bootstrap.py').read())"