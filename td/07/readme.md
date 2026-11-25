warning installer seaborn

move data to data?

-

[< Revenir à la page d'Accueil](../../readme.md)

# TD7

## Configuration du TD & lancement de _JupyterLab_

<details>
<Summary><b>Si vous êtes sur Windows (PC UGA ou PC perso)</b></Summary>

Ouvrez l'application "Anaconda Powershell Prompt" et lancez la commande suivante :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; $ScriptPath = Join-Path $env:TEMP "script.ps1" ; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' -OutFile $ScriptPath; & $ScriptPath -BootstrapTD "07"
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
bash "$script" --bootstrap-td 07

```

<!-- alternative (non interactive?)
curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" | bash -s -- --bootstrap-td 07
 -->

Vous devez voir un message du type :

> ```bash
> ==> Tout est en ordre !
> ```

suivi des instructions pour lancer jupyter lab : suivez ces instructions pour démarrer le TD.

</details>

## Exercices

Il y a un exercice obligatoire : `01_first_plots.ipynb`.

Le deuxième exercice est optionnel.

Si vous avez terminé, vous pouvez revenir aux TD précédents (en particulier TD 5 ou 6) et terminer les exercices non terminés sur pandas.

Vous pouvez fermer _JupyterLab_ quand vous avez terminé, en **quittant le Terminal**.
