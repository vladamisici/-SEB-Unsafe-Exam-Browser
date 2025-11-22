# Get-SEBDiagnostics.ps1
# Diagnostic script to verify Safe Exam Browser processes and configuration

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Safe Exam Browser Diagnostics" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for running SEB processes
Write-Host "Running SEB Processes:" -ForegroundColor Yellow
Write-Host "---------------------"
$sebProcesses = Get-Process | Where-Object { $_.Name -like "*SafeExamBrowser*" }

if ($sebProcesses) {
    foreach ($proc in $sebProcesses) {
        Write-Host "Process Name: $($proc.Name)" -ForegroundColor Green
        Write-Host "  PID: $($proc.Id)"
        Write-Host "  Path: $($proc.Path)"
        Write-Host "  Start Time: $($proc.StartTime)"
        Write-Host ""
    }
} else {
    Write-Host "No Safe Exam Browser processes found." -ForegroundColor Red
    Write-Host ""
}

# Check explorer.exe status
Write-Host "Windows Explorer Status:" -ForegroundColor Yellow
Write-Host "-----------------------"
$explorer = Get-Process -Name "explorer" -ErrorAction SilentlyContinue

if ($explorer) {
    Write-Host "Explorer.exe: RUNNING" -ForegroundColor Green
    Write-Host "  PID: $($explorer.Id)"
    Write-Host "  Path: $($explorer.Path)"
} else {
    Write-Host "Explorer.exe: NOT RUNNING" -ForegroundColor Red
    Write-Host "  WARNING: Alt+Tab task switching will not work!" -ForegroundColor Red
}
Write-Host ""

# Search for .seb configuration files
Write-Host "Configuration Files (.seb):" -ForegroundColor Yellow
Write-Host "---------------------------"

# Search common locations for .seb files
$searchPaths = @(
    $env:USERPROFILE,
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Documents",
    "$env:LOCALAPPDATA\SafeExamBrowser"
)

$sebFiles = @()
foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Filter "*.seb" -ErrorAction SilentlyContinue
        if ($files) {
            $sebFiles += $files
        }
    }
}

if ($sebFiles) {
    foreach ($file in $sebFiles) {
        Write-Host "  $($file.FullName)" -ForegroundColor Green
        Write-Host "    Size: $($file.Length) bytes"
        Write-Host "    Modified: $($file.LastWriteTime)"
        Write-Host ""
    }
} else {
    Write-Host "  No .seb configuration files found in common locations." -ForegroundColor Gray
}
Write-Host ""

# Check for SEB log files
Write-Host "Log Files:" -ForegroundColor Yellow
Write-Host "----------"
$logPath = "$env:LOCALAPPDATA\SafeExamBrowser\Logs"

if (Test-Path $logPath) {
    $logFiles = Get-ChildItem -Path $logPath -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 5
    
    if ($logFiles) {
        Write-Host "  Recent log files (latest 5):"
        foreach ($log in $logFiles) {
            Write-Host "    $($log.Name)" -ForegroundColor Green
            Write-Host "      Path: $($log.FullName)"
            Write-Host "      Modified: $($log.LastWriteTime)"
            Write-Host ""
        }
    } else {
        Write-Host "  No log files found." -ForegroundColor Gray
    }
} else {
    Write-Host "  Log directory not found: $logPath" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Diagnostics Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
