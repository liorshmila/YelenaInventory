Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$envFilePath = Join-Path $PSScriptRoot 'release.env.ps1'
$flutterProjectPath = Join-Path $repoRoot 'yelena_inventory'
$aabPath = Join-Path $flutterProjectPath 'build\app\outputs\bundle\release\app-release.aab'

if (!(Test-Path $envFilePath)) {
    throw "Release environment file was not found: $envFilePath"
}

. $envFilePath

$supabaseUrl = $env:SUPABASE_URL
$supabasePublishableKey = $env:SUPABASE_PUBLISHABLE_KEY

if ([string]::IsNullOrWhiteSpace($supabaseUrl)) {
    throw 'SUPABASE_URL is missing from scripts\release.env.ps1.'
}

if ([string]::IsNullOrWhiteSpace($supabasePublishableKey)) {
    throw 'SUPABASE_PUBLISHABLE_KEY is missing from scripts\release.env.ps1.'
}

Push-Location $flutterProjectPath
try {
    $arguments = @(
        'build'
        'appbundle'
        '--release'
        "--dart-define=SUPABASE_URL=$supabaseUrl"
        "--dart-define=SUPABASE_PUBLISHABLE_KEY=$supabasePublishableKey"
    )

    & flutter @arguments

    if ($LASTEXITCODE -ne 0) {
        throw "flutter build appbundle failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}

if (!(Test-Path $aabPath)) {
    throw "Release AAB was not found at expected path: $aabPath"
}

Write-Host 'Android release AAB built successfully.'
Write-Host "AAB: $aabPath"