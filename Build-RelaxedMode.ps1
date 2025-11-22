# Build-RelaxedMode.ps1
# Build script for Relaxed Mode configuration

Write-Host "Building Relaxed Mode Configuration..." -ForegroundColor Cyan
Write-Host ""

# Find MSBuild
$msbuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"

if (-not (Test-Path $msbuildPath)) {
    # Try other common locations
    $msbuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
}

if (-not (Test-Path $msbuildPath)) {
    $msbuildPath = "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
}

if (-not (Test-Path $msbuildPath)) {
    Write-Host "ERROR: MSBuild not found!" -ForegroundColor Red
    Write-Host "Please ensure Visual Studio 2022 is installed." -ForegroundColor Yellow
    exit 1
}

Write-Host "Using MSBuild: $msbuildPath" -ForegroundColor Green
Write-Host ""

# Build the solution
Write-Host "Building SafeExamBrowser.sln with Relaxed configuration..." -ForegroundColor Yellow

$buildArgs = @(
    "SafeExamBrowser.sln",
    "/p:Configuration=Relaxed",
    "/p:Platform=x64",
    "/t:Build",
    "/m",
    "/v:minimal",
    "/nologo"
)

& $msbuildPath $buildArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Run .\Verify-RelaxedBuild.ps1 to verify the build." -ForegroundColor Cyan
    exit 0
} else {
    Write-Host ""
    Write-Host "Build failed with exit code: $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}
