# Configurer sa machine perso (`Mac` ou `Linux` 11)


## Etape 1 : Installer Miniconda

Télécharger Miniconda depuis le [site officiel](https://www.anaconda.com/download/success), et suivre les instructions d'installation.

⚠️ Il faut **absolument** veiller, quand ce sera proposé au cours de l'installation, à cocher la case "*Add installation to my PATH environment variable*". En cas de doute, voir avec l'enseignant.

## Etape 2 : Création du dossier de travail

⚠️**On ne travaille pas dans le dossier de téléchargements ou n'importe où sur le disque dur.** 

Nous allons créer un dossier de travail qui contiendra l'ensemble des fichiers et travaux du cours. Ce dossier portera le même nom chez tout le monde (`intro-python`). Le dossier de travail sera situé sera situé dans le répertoire utilisateur (aussi appelé *Home*).

Ouvrir l'application *Terminal*.

Copier-coller la commande suivante et taper sur *Entrée* : 
```bash
curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup.sh" | bash
```

Cela va configurer python et créer un dossier de travail pour ce cours.

Tant que le curseur en bas du terminal clignote, l'installation est en cours. Au bout de quelques minutes, on doit voir le message ci-dessous :
> ```bash
> ============================================================
> SETUP OK
> Your Python environment is ready.
> ============================================================
> ```
Si cela ne fonctionne pas, appeler l'enseignant.

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

Cela ouvre votre dossier de travail. ⚠️ **Bien repérer où il est situé pour être capable d'y revenir de manière autonome avec l'explorateur de fichier.** En cas de doute avec ça, appeler l'enseignant.