[< Revenir à la page d'Accueil](../../readme.md)

# TD5

## Configuration du TD & lancement de _JupyterLab_

<details>
<Summary><b>Si vous êtes sur Windows (PC UGA ou PC perso)</b></Summary>

Ouvrez l'application "Anaconda Powershell Prompt" et lancez la commande suivante :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $ScriptPath = Join-Path $env:TEMP "script.ps1" ; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' -OutFile $ScriptPath; & $ScriptPath -BootstrapTD "05"
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
bash "$script" --bootstrap-td 05

```

<!-- alternative (non interactive?)
curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" | bash -s -- --bootstrap-td 05
 -->

Vous devez voir un message du type :

> ```bash
> ==> Tout est en ordre !
> ```

suivi des instructions pour lancer jupyter lab : suivez ces instructions pour démarrer le TD.

</details>

## Exercices

Ils sont à réaliser un-par-un dans _JupyterLab_ en ouvrant les notebooks dédiés, dans l'ordre :

- `01_numpy_boolean_indexing.ipynb` : pratique du Boolean indexing avec Numpy ;
- `02_pandas_basics.ipynb` : découverte de pandas (types et sélection de donnée) ;
- `03_pandas_csv_exploration.ipynb` : utilisation de pandas sur de la donnée existante ;
- `04_titanic_data.ppynb` (exercice optionnel) : idem.

Vous pouvez fermer _JupyterLab_ quand vous avez terminé, en **quittant le Terminal**.
