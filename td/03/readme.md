[< Revenir à la page d'Accueil](../../readme.md)

# TD3

## Configuration du TD & lancement de _JupyterLab_

<details>
<Summary><b>Si vous êtes sur Windows (PC UGA ou PC perso)</b></Summary>

Ouvrez l'application "Anaconda Powershell Prompt" et lancez la commande suivante :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
$ScriptPath = Join-Path $env:TEMP "script.ps1"
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' -OutFile $ScriptPath
& $ScriptPath -BootstrapTD "03"
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
bash "$script" --bootstrap-td 03

```

<!-- alternative (non interactive?)
curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" | bash -s -- --bootstrap-td 03
 -->

Vous devez voir un message du type :

> ```bash
> ==> Tout est en ordre !
> ```

suivi des instructions pour lancer jupyter lab : suivez ces instructions pour démarrer le TD.

</details>

## Exercices

Ils sont à réaliser un-par-un dans _JupyterLab_ en ouvrant les notebooks dédiés, dans l'ordre :

- `01_fonctions.ipynb` : cet exercice était facultatif dans le TD1. Si vous l'avez déjà fait, vous pouvez passer à la suite, sinon, faites-le maintenant.
- `02_boucles_for.ipynb`
- `03_conditions.ipynb`
- `04_list_dict_comprehension.ipynb` (exercice facultatif)

Vous pouvez fermer _JupyterLab_ quand vous avez terminé, en **quittant le Terminal**.

## Préparation du CC1

Afin de consolider les notions vues depuis le début du cours, vous pouvez continuer la [Python Quest](https://utileaf.com/tools/python-quest) sur le site _Utileaf_ :

- les niveaux 1 à 4 ont déjà été faits (donnés à faire chez soi après le TD 1)
- les niveaux 5 à 9 sont à faire désormais

**Important : le contenu du premier CC portera sur ces 9 premiers niveaux, c'ets à dire les notions vues pendant les 3 premières séances de cours.**

Si vous voulez débloquer les niveaux 1 à 4 pour commencer directement au niveau 5, appelez l'enseignant.

## Pour aller plus loin

Pour vous entraîner sur les notions vues ce jour ou pour réviser, vous pouvez suivre le [Parcours d'autoentrainement](autoentrainement.md)
