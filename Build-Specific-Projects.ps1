# Build-Specific-Projects.ps1
# Build only the projects that were modified

Write-Host "Building specific projects with AssemblyConfiguration updates..." -ForegroundColor Cyan
Write-Host ""

$msbuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"

if (-not (Test-Path $msbuildPath)) {
    Write-Host "ERROR: MSBuild not found!" -ForegroundColor Red
    exit 1
}

$projects = @(
    "SafeExamBrowser.Runtime\SafeExamBrowser.Runtime.csproj",
    "SafeExamBrowser.Client\SafeExamBrowser.Client.csproj",
    "SafeExamBrowser.Service\SafeExamBrowser.Service.csproj",
    "SafeExamBrowser.Monitoring\SafeExamBrowser.Monitoring.csproj"
)

$failed = $false

foreach ($project in $projects) {
    Write-Host "Building $project..." -ForegroundColor Yellow
    
    $buildArgs = @(
        $project,
        "/p:Configuration=Relaxed",
        "/p:Platform=x64",
        "/t:Build",
        "/v:minimal",
        "/nologo"
    )
    
    & $msbuildPath $buildArgs
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  FAILED!" -ForegroundColor Red
        $failed = $true
    } else {
        Write-Host "  SUCCESS!" -ForegroundColor Green
    }
    Write-Host ""
}

if (-not $failed) {
    Write-Host "All projects built successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Run .\Verify-RelaxedBuild.ps1 to verify the build." -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "Some projects failed to build." -ForegroundColor Red
    Write-Host ""
    Write-Host "Note: If you see 'file is locked' errors, close any PowerShell windows" -ForegroundColor Yellow
    Write-Host "that have run Verify-RelaxedBuild.ps1, then try again." -ForegroundColor Yellow
    exit 1
}
