# TD n°2

Ouvrir un terminal dans le dossier `intro-python` et exécuter les commandes suivantes :

```bash
# Download files
conda run -n intro-python-feg-l3 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '02']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/main/setup/bootstrap_td.py').read())"
# Launch JupyterLab
conda run -n intro-python-feg-l3 jupyter lab
```

Il faut garder ce terminal ouvert tant que JupyterLab est utilisé.
