## Machine UGA

### Enlever miniconda

- désinstallation via les paramètres, cocher toutes les cases de fichiers temporaires
- run du script de setup avec `--SkipDir`

  ```powershell
  $script="$env:TEMP\intro-python-setup.ps1"; Invoke-WebRequest "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup-uga.ps1" -OutFile $script; Unblock-File $script; & $script --SkipDir
  ```

- vérifier le PATH : aller dans "modifier les variables d'environnement pour votre compte"

## Machine perso Windows

### Ajouter conda au PATH

- run du script de setup pour localiser conda
  ```powershell
  powershell -ExecutionPolicy Bypass -Command "$script='$env:TEMP\intro-python-setup.ps1'; Invoke-WebRequest 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup-uga.ps1' -OutFile $script; Unblock-File $script; & $script --SkipDir"
  ```
- ajout manuel dans le PATH : aller dans "modifier les variables d'environnement pour votre compte"

## Machine perso Mac/Linux

### Lancement du script de config

Flags disponibles : `--SkipEnv`, `SkipCheck`, `--SkipDir`

```bash
#Exemple pour le check uniquement
  curl -fsSL "https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup.sh" | bash -s -- --SkipDir --SkipEnv
```

### Ajouter conda au PATH

- vérifier que miniconda est installé
  ```
  ls ~/miniconda3
  ```
- si installé,
  ```bash
  ~/miniconda3/bin/conda init zsh #ajout au path
  source ~/.zshrc #reload zsh
  #verification
  conda --version
  which conda
  ```
- si non présent, le chercher :
  ```bash
  find ~ -type f -path "*/bin/conda" 2>/dev/null
  ```
