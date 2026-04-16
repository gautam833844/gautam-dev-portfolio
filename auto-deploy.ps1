param([switch]$Watch = $false)

$repoPath = "d:\poatfolio"
Set-Location $repoPath

# Configure git
git config user.email "gautamreddy833@gmail.com"
git config user.name "Gautam Reddy"

if ($Watch) {
    Write-Host "🚀 Auto-Deploy Monitor Started" -ForegroundColor Green
    Write-Host "Watching for changes in $repoPath" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
    Write-Host ""

    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $repoPath
    $watcher.Filter = "*.html"
    $watcher.IncludeSubdirectories = $false
    $watcher.EnableRaisingEvents = $true

    $lastUpdate = Get-Date

    $action = {
        $currentTime = Get-Date
        if (($currentTime - $global:lastUpdate).TotalSeconds -gt 2) {
            $global:lastUpdate = $currentTime
            
            Write-Host "📝 Change detected" -ForegroundColor Yellow
            Write-Host "⏳ Auto-deploying..." -ForegroundColor Cyan
            
            try {
                Set-Location $repoPath
                git add .
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                git commit -m "Auto-update: $timestamp" *>$null
                git push origin main
                Write-Host "✅ Deployed! Live site updated" -ForegroundColor Green
            }
            catch {
                Write-Host "Note: No changes or push failed" -ForegroundColor Gray
            }
        }
    }

    $global:lastUpdate = $lastUpdate
    Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action | Out-Null

    while ($true) { Start-Sleep -Seconds 1 }
}
