[< Revenir à la page d'Accueil](../../readme.md)

# TD4

## Configuration du TD & lancement de _JupyterLab_

<details>
<Summary><b>Si vous êtes sur Windows (PC UGA ou PC perso)</b></Summary>

Ouvrez l'application "Anaconda Powershell Prompt" et lancez la commande suivante :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $ScriptPath = Join-Path $env:TEMP "script.ps1" ; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' -OutFile $ScriptPath; & $ScriptPath -BootstrapTD "04"
```

Vous devez voir un message du type :

> ```bash
> ==> Tout est en ordre !
> ```

suivi des instructions pour lancer jupyter lab : suivez ces instructions pour démarrer le TD.

</details>

<details>
<summary><b>Si vous êtes sur Mac ou Linux</b></summary>

Ouvrez un terminal et lancez :

```bash
script=$(mktemp) || exit 1
trap 'rm -f "$script"' EXIT

curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" -o "$script" &&
bash "$script" --bootstrap-td 04

```

<!-- alternative (non interactive?)
curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" | bash -s -- --bootstrap-td 04
 -->

Vous devez voir un message du type :

> ```bash
> ==> Tout est en ordre !
> ```

suivi des instructions pour lancer jupyter lab : suivez ces instructions pour démarrer le TD.

</details>

## Exercices

Ils sont à réaliser un-par-un dans _JupyterLab_ en ouvrant les notebooks dédiés, dans l'ordre :

- `01_data_selection.ipynb` (durée conseillée : 10 min) : manipulations des arrays pour sélectionner des données.
- `02_arrays_maths.ipynb` (durée conseillée : 15 min) : calculs sur des arrays.
- `03_climate_data.ipynb` (durée conseillée : 20 min): application à un cas concrêt, sur des données climatiques.

Vous pouvez fermer _JupyterLab_ quand vous avez terminé, en **quittant le Terminal**.
