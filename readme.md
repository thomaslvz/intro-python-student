# Introduction à python

<details>
<summary id="setup">Configuration initiale</summary>

Pour configurer l'ordinateur, suivez les instructions de _setup_ :

- [Sur une machine UGA](setup/setup-w11-uga.md)
- [Sur une machine perso avec`Windows 11`](setup/setup-w11.md)
- [Sur une machine perso avec `Mac` ou `Linux`](setup/setup-mac-linux.md)

</details>

## Déroulé des séances

Les TD sont réalisés sur l'environnement de développement _JupyterLab_.

A chaque début de séance, il est demandé d'ouvrir un terminal dans le dossier de travail `intro-python` : c'est une opération "clasique" qu'il faut savoir refaire (cf. [ici](#comment-ouvrir-un-terminal-dans-mon-dossier-de-travail-intro-python-)).

| Numéro de séance | Thématique                              | Supports                                                                                                  | Ressources utiles                                                     |
| ---------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Séance 1         | Prise en main                           | [Présentation](https://thomaslvz.github.io/intro-python-student/01_prise-en-main) / [TD](td/01/readme.md) | [Guide syntaxe Markdown](https://www.markdownguide.org/basic-syntax/) |
| Séance 2         | Variables, types, structures de données | [Présentation](#) / [TD](#)                                                                               |                                                                       |
| Séance 3         |                                         |                                                                                                           |                                                                       |
| Séance 4         |                                         |                                                                                                           |                                                                       |
| Séance 5         |                                         |                                                                                                           |                                                                       |
| Séance 6         |                                         |                                                                                                           |                                                                       |
| Séance 7         |                                         |                                                                                                           |                                                                       |
| Séance 8         |                                         |                                                                                                           |                                                                       |
| Séance 9         |                                         |                                                                                                           |                                                                       |

### Ressources externes / Bibliographie

- Apprendre Python avec d'autres cours :
  - capsules vidéo niv. débutant.e sur [learn.microsoft.com](https://learn.microsoft.com/en-us/shows/intro-to-python-development/) (en anglais)
  - le très complet [cours](https://python.sdv.u-paris.fr/) de Patrick Fuchs & Pierre Poulain (Université Paris Cité)
  - des cours, ateliers, exercices, mini-projets pour les économistes, niv. intermédiaire et avancé.e, sur [QuantEcon](https://quantecon.org/) (en anglais)
- S'entraîner à coder en Python sur des exercices en ligne (en anglais) :
  - la [Python Quest](https://utileaf.com/tools/python-quest) sur Utileaf (niv. débutant.e)
  - de nombreux exercices tous niveaux, classés par thématique, sur [CodingPractice](https://codingpractice.online/)
- Exécuter du code Python en ligne depuis n'importe quel ordinateur, sans installation :
  - Dans une [console python](https://fr.futurecoder.io/course/#ide)
  - Sur [JupyterLab](https://jupyter.org/try-jupyter/lab/)

## Questions fréquentes

### Comment ouvrir un terminal dans mon `intro-python` ?

<details>
<summary>Sur un ordinateur UGA</summary>

Lancez _Anaconda Prompt_, puis exécutez :

```shell
H:
cd intro-python
```

Vous y êtes !

</details>

<details>
<summary>Sur son ordinateur perso sous Windows</summary>

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur le disque dur qui contient Windows. Aller ensuite dans _Utilisateurs_ et cliquer sur son nom d'utilisateur. Faire `Shift+Clic droit` sur le dossier `intro-python` et choisir `Ouvrir dans le terminal` ou `Ouvrir dans Powershell`.

</details>

<details>
<summary>Sur son ordinateur perso sous Mac</summary>

Ouvrir l'application _Terminal_ et rentrer la commande `cd ~/intro-python && open .`. Le terminal est désormais dans le dossier `intro-python`, et _Finder_ s'est ouvert pour afficher le contenu du répertoire.

</details>
<details>
<summary>Sur son ordinateur perso sous Linux</summary>

Ouvrir l'application _Terminal_ et rentrer la commande `cd ~/intro-python && xdg-open .`. Le terminal est désormais dans le dossier `intro-python`, et le navigateur de fichiers s'est ouvert pour afficher le contenu du répertoire.

</details>

### J'ai une erreur me disant que `conda` n'existe pas

Message d'erreur type :

- sur windows: `conda : The term 'conda' is not recognized as the name of a cmdlet, function, script file, or operable program.`
- sur mac/linux : `conda: command not found`

Solution : il faut (ré)installer Miniconda, cf. [Configuration initiale](#setup)

### J'ai une erreur `EnvironmentLocationNotFound`

Message d'erreur type :

```bash
EnvironmentLocationNotFound: Not a conda environment: /.../envs/intro-python-feg-l3
```

Solution : il faut refaire l'étape 2 de la [Configuration initiale](#setup)

### Comment obtenir les présentations en PDF ?

_A faire avec le navigateur Firefox ou Chrome_

- ouvrez la présentation
- cliquez sur le menu en haut à gauche, puis, `Tools` > `PDF export mode`
- dans le navigateur, faire menu > `Imprimer` et sélectionner `Enregistrer au format PDF`
- vérifiez que la case "imprimer les arrières plans" soit cochée, et que l'option "ajuster à la largeur de la page" soit activée
- cliquez sur "Enregistrer"
