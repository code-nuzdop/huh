param([int]$TimeoutSec = 300)
$log = 'C:\r6esp\r6esp.log'
if (-not (Test-Path $log)) { Write-Host "no log at $log" -ForegroundColor Red; exit 1 }

$m = Select-String -Path $log -Pattern 'r6esp started' | Select-Object -Last 1
if (-not $m) { Write-Host "no session marker yet" -ForegroundColor Red; exit 1 }

$all = @(Get-Content $log)
$start = $m.LineNumber - 1
$end = [Math]::Min($start + 40, $all.Count - 1)
Write-Host "--- bring-up ---" -ForegroundColor Cyan
$all[$start..$end] | ForEach-Object { Write-Host $_ }

$open = $all[$start..$end] | Where-Object { $_ -match 'open\+probe ok' }
if (-not $open) {
    Write-Host ""
    Write-Host "handle did NOT come up - reboot and retry, or check driver state" -ForegroundColor Red
    exit 2
}
Write-Host ""
Write-Host "handle held. launch Siege now; watching..." -ForegroundColor Yellow

$pos = $all.Count
$deadline = (Get-Date).AddSeconds($TimeoutSec)
$stop = $false
while (-not $stop -and (Get-Date) -lt $deadline) {
    Start-Sleep -Milliseconds 700
    $cur = @(Get-Content $log)
    for ($i = $pos; $i -lt $cur.Count; $i++) {
        Write-Host $cur[$i]
        if ($cur[$i] -match 'EL=0x|VM=0x|no module|not in list|kernel handle lost|open failed|inert|no CR3') { $stop = $true }
    }
    $pos = $cur.Count
    if (-not (Get-Process -Name 'Overlay3*' -ErrorAction SilentlyContinue)) { Write-Host "Overlay3 exited" -ForegroundColor Red; break }
}
if (-not $stop) { Write-Host "timeout after ${TimeoutSec}s" -ForegroundColor Yellow }

Write-Host ""
Write-Host "--- key lines ---" -ForegroundColor Cyan
@(Get-Content $log)[$start..([Math]::Max($start, @(Get-Content $log).Count - 1))] |
    Where-Object { $_ -match 'APL=|EPROCESS=|CR3=|IMG|rpmprobe|PEB=|EL=|VM=|no module|not in list' } |
    ForEach-Object { Write-Host $_ }
