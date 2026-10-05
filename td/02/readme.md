# TD n°2

## Chargement des fichiers et démarrage de JupyterLab

<details>
<Summary><b>Si vous êtes sur un ordinateur UGA</b></Summary>

Lancez l'application _Anaconda Prompt_, puis excécutez-y ces commandes :

```powershell
H:
cd intro-python
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '02']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/bootstrap_td.py').read())"
```

Si vous avez une phrase du type "Le TD.. a été installé dans...", vous pouvez continuer. Lancez cette commande :

```powershell
conda run -n intro-python-feg-l3 jupyter lab
```

</details>

<br>

<details>
<summary><b>Si vous êtes sur votre ordinateur personnel</b></summary>

Localisez votre dossier `intro-python`.

---

<details>
<summary>💡 Aide : je n'arrive pas à trouver mon dossier <code>intro-python</code></summary>

Ouvrez un terminal et lancez :

```bash
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/open-intro-python.py').read())"
```

Vous pouvez fermer le terminal, et une fenêtre s'est ouverte automatiquement. Le dossier `intro-python` y est visible. Il est conseillé d'ajouter ce dossier à vos _accès rapides_, pour le retrouver rapidement.

</details>

---

Sur le dossier `intro-python`, faites un `clic droit` puis `Ouvrir dans un Terminal`.

Dans le terminal, exécutez cette commande :

```bash
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '02']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/bootstrap_td.py').read())"
```

Si vous avez une phrase du type "Le TD.. a été installé dans...", vous pouvez continuer. Lancez cette commande :

```bash
conda run -n intro-python-feg-l3 jupyter lab
```

</details>
<br>

Il faut garder ce terminal ouvert tant que JupyterLab est utilisé.
