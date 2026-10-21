[< Revenir à la page d'Accueil](../readme.md)

# Configurer sa machine perso (`Mac` ou `Linux`)

## Etape 1 : Installer Miniconda

Télécharger Miniconda depuis le [site officiel](https://www.anaconda.com/download/success), et suivre les instructions d'installation.

⚠️ Il faut **absolument** veiller, quand ce sera proposé au cours de l'installation, à cocher la case "_Add installation to my PATH environment variable_". En cas de doute, voir avec l'enseignant.

## Etape 2 : Configuration des éléments du cours

Ouvrir l'application _Terminal_.

Copier-coller la commande suivante et taper sur _Entrée_ :

```bash
curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.sh" | bash
```

Cela vérifie que tout est bien configuré, et si besoin, installe les éléments manquants.

Au bout de quelques minutes, on doit voir le message ci-dessous :

> ```bash
> ==> Tout est en ordre !
> ```

Si cela ne fonctionne pas, appeler l'enseignant (ou envoyez une capture d'écran du message d'erreur).

## Etape 3 : Localisation du dossier de travail

Toujours dans le terminal, lancez la commande suivante :

<details>
<summary>Sous Mac</summary>

```bash
open "$HOME/intro-python"
```

</details>

<details>
<summary>Sous Linux</summary>

```bash
xdg-open ~/intro-python
```

</details>

<br>
Cela ouvre votre dossier de travail `intro-python` qui contiendra les fichiers du cours.

⚠️ **Bien repérer où il est situé pour être capable d'y revenir de manière autonome avec l'explorateur de fichier.** En cas de doute avec ça, appeler l'enseignant.
