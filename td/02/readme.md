# TD n°2

## Chargement des fichiers et démarrage de JupyterLab

<details>
<Summary><b>Si vous êtes sur un ordinateur UGA</b></Summary>

Lancez l'application _Anaconda Prompt_, puis excécutez-y cette commande pour vérifier l'installation de conda depuis le dernier TD :

```powershell
$script="$env:TEMP\intro-python-setup.ps1"; Invoke-WebRequest "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup-uga.ps1" -OutFile $script; Unblock-File $script; & $script --SkipDir
```

Si cela fonctionne, exécutez ensuite :

```powershell
H:
cd intro-python
conda run --no-capture-output -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '02']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/bootstrap_td.py').read())"
```

Si vous avez une phrase du type "Le TD.. a été installé dans...", vous pouvez continuer. Lancez cette commande :

```powershell
conda activate intro-python-feg-l3
jupyter lab
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
conda run -s -n intro-python-feg-l3 python -X utf8 -c "import sys, urllib.request; sys.argv = ['bootstrap_td.py', '02']; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/bootstrap_td.py').read())"
```

Si vous avez une phrase du type "Le TD.. a été installé dans...", vous pouvez continuer. Lancez cette commande :

```bash
conda activate intro-python-feg-l3
jupyter lab
```

</details>
<br>

Il faut garder ce terminal ouvert tant que JupyterLab est utilisé.

## Exercices

Les 3 exercices sont à faire dans _JupyterLab_, il y a un notebook par exercice, à faire dans l'ordre de numérotation :

- `01_types.ipynb`
- `02_lists.ipynb`
- `03_dictionnaries.ipynb`

## Bonus

- Si vous avez terminé, vous pouvez faire les exercices n°4 et 5 (bonus) du TD 1.

- Une fois terminé, vous pouvez chercher les challenges suivants sur _Coding Practice_. Attention, ces exercices sont à faire **_sans utiliser aucune boucle `for`_** !
  - [Average of a list](https://codingpractice.online/problems/fix-the-bug-average)
  - [Is it a palindrome phrase ?](https://codingpractice.online/problems/is-palindrome-phrase)
  - [Find the missing number](https://codingpractice.online/problems/find-missing-number)
    <details>
    <summary>Indice</summary>

    on a vu en maths en L1 que la somme des $n$ entiers de 1 à $n$ vaut $n(n+1)/2$...
    </details>

  - [Reverse a sublist between 2 positions](https://codingpractice.online/problems/reverse-linked-list-between-positions)
