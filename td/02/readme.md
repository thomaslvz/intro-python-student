[< Revenir à la page d'Accueil](../../readme.md)

# TD n°2

## Configuration du TD & lancement de _JupyterLab_

<details>
<Summary><b>Si vous êtes sur Windows (PC UGA ou PC perso)</b></Summary>

Ouvrez l'application "Anaconda Powershell Prompt" et lancez la commande suivante :

```powershell
$ScriptPath = Join-Path $env:TEMP "script.ps1"
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' -OutFile $ScriptPath
& $ScriptPath -BootstrapTD "02"
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
bash "$script" --bootstrap-td 02

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

Il faut garder ce terminal ouvert tant que JupyterLab est utilisé.

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
