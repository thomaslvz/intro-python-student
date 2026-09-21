# Introduction à python [draft]

## Configuration de l'ordinateur (setup)

[Sur Windows 11 (machine UGA ou machine perso)](setup/setup-w11.md)

[Sur une machine personnelle tournant sur Mac ou Linux](setup/setup-mac-linux.md)

## Consignes des TDs

**Important :** A chaque séance, avant de commencer le TD, il faut [ouvrir un terminal dans le dossier de travail](#je-ne-trouve-pas-mon-dossier-de-travail-intro-python) `intro-python`, puis lancer la commande suivante : 
```bash
conda run -n intro-python-feg-l3 python -c "import urllib.request; exec(urllib.request.urlopen('https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/bootstrap.py').read())"
```

**Liste des séances :**

[Séance 1](tds/td1.md)

## Questions fréquentes

### Comment ouvrir un terminal dans mon dossier de travail `intro-python` ?

<details>
<summary>Sur un ordinateur UGA</summary>

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur son espace personnel dans les *Emplacements réseaux*. Faire `Shift+Clic droit` sur le dossier `intro-python` et choisir `Ouvrir dans le terminal` ou `Ouvrir dans Powershell`.

</details>

<details>
<summary>Sur son ordinateur perso sous Windows</summary>

Ouvrir l'explorateur de fichiers, cliquer sur `Ce PC` puis sur le disque dur qui contient Windows. Aller ensuite dans *Utilisateurs* et cliquer sur son nom d'utilisateur. Faire `Shift+Clic droit` sur le dossier `intro-python` et choisir `Ouvrir dans le terminal` ou `Ouvrir dans Powershell`.
</details>

<details>
<summary>Sur son ordinateur perso sous Mac</summary>

Ouvrir l'application *Terminal* et rentrer la commande `cd ~/intro-python && open .`. Le terminal est désormais dans le dossier de travail, et *Finder* s'est ouvert pour afficher le contenu du répertoire.
</details>
<details>
<summary>Sur son ordinateur perso sous Linux</summary>

Ouvrir l'application *Terminal* et rentrer la commande `cd ~/intro-python && xdg-open .`. Le terminal est désormais dans le dossier de travail, et le navigateur de fichiers s'est ouvert pour afficher le contenu du répertoire.
</details>


### J'ai une erreur me disant que `conda` n'existe pas

Message d'erreur type : 
- sur windows: `conda : The term 'conda' is not recognized as the name of a cmdlet, function, script file, or operable program.`
- sur mac/linux : `conda: command not found`

Solution : il faut (ré)installer Miniconda, cf. [Setup](#configuration-de-lordinateur-setup)

