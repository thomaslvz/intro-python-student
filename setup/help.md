## Machine UGA

### en cas de double install de conda

- désinstallation via les paramètres, cocher toutes les cases de fichiers temporaires
- run du script de setup
- vérifier le PATH : aller dans "modifier les variables d'environnement pour votre compte"

## Machine perso Windows

### Script non sécurisé (`ExecutionPolicy` error)

On ajoute la commande `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force` avant le reste.

Exemple (adapter les flags du script à la fin) :

```powershel
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
$ScriptPath = Join-Path $env:TEMP "script.ps1"
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/check-setup.ps1' -OutFile $ScriptPath
& $ScriptPath -BootstrapTD "03"
```

On peut aussi essayer `Unblock-File $ScriptPath`.

### Ajouter conda au PATH

- run du script de setup pour localiser conda
  ```powershell
  $script = Join-Path $env:TEMP 'intro-python-setup.ps1'
  Invoke-WebRequest 'https://raw.githubusercontent.com/thomaslvz/intro-python-student/refs/heads/main/setup/setup.ps1' -OutFile $script
  Unblock-File $script
  & $script --SkipDir
  ```
- ajout manuel dans le PATH : aller dans "modifier les variables d'environnement pour votre compte"

## Machine perso Mac/Linux

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
