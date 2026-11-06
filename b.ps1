$BIN = 'Overlay3.exe'
$ErrorActionPreference='Continue'
Get-Process -Name 'Overlay*','run_*' | Stop-Process -Force
taskkill /IM WerFault.exe /F 2>$null | Out-Null
Start-Sleep -Milliseconds 700
Get-ChildItem .\run_*.exe | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem .\run_*.exe | Rename-Item -NewName { $_.Name + '.old' } -ErrorAction SilentlyContinue
Get-ChildItem .\*.exe.old, .\Overlay_*.exe, .\Overlay2_*.exe | Remove-Item -Force -ErrorAction SilentlyContinue
Remove-Item ".\$BIN" -Force -ErrorAction SilentlyContinue
if (Test-Path ".\$BIN") { Write-Host "[!] $BIN is LOCKED" } else { Write-Host "[+] $BIN free" }
.\build.bat
