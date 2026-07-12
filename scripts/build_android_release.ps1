Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$envFilePath = Join-Path $PSScriptRoot 'release.env.ps1'
$flutterProjectPath = Join-Path $repoRoot 'yelena_inventory'
$pubspecPath = Join-Path $flutterProjectPath 'pubspec.yaml'
$aabPath = Join-Path $flutterProjectPath 'build\app\outputs\bundle\release\app-release.aab'
$originalPubspecContent = $null
$pubspecWasUpdated = $false

try {
    if (!(Test-Path $envFilePath)) {
        throw "Release environment file was not found: $envFilePath"
    }

    if (!(Test-Path $pubspecPath)) {
        throw "pubspec.yaml was not found: $pubspecPath"
    }

    . $envFilePath
    Write-Host 'Release environment loaded.'

    $supabaseUrl = $env:SUPABASE_URL
    $supabasePublishableKey = $env:SUPABASE_PUBLISHABLE_KEY

    if ([string]::IsNullOrWhiteSpace($supabaseUrl)) {
        throw 'SUPABASE_URL is missing from scripts\release.env.ps1.'
    }

    if ([string]::IsNullOrWhiteSpace($supabasePublishableKey)) {
        throw 'SUPABASE_PUBLISHABLE_KEY is missing from scripts\release.env.ps1.'
    }

    $originalPubspecContent = Get-Content $pubspecPath -Raw
    $versionMatch = [regex]::Match($originalPubspecContent, '(?m)^version:\s*(?<semantic>\d+\.\d+\.\d+)\+(?<build>\d+)\s*$')

    if (!$versionMatch.Success) {
        throw 'Could not find a Flutter version in pubspec.yaml in the expected format: version: x.y.z+build'
    }

    $previousVersion = "$($versionMatch.Groups['semantic'].Value)+$($versionMatch.Groups['build'].Value)"
    $newBuildNumber = [int]$versionMatch.Groups['build'].Value + 1
    $newVersion = "$($versionMatch.Groups['semantic'].Value)+$newBuildNumber"

    Write-Host "Previous version: $previousVersion"
    Write-Host "New version: $newVersion"

    $updatedPubspecContent = [regex]::Replace(
        $originalPubspecContent,
        '(?m)^version:\s*\d+\.\d+\.\d+\+\d+\s*$',
        "version: $newVersion",
        1
    )

    [System.IO.File]::WriteAllText(
        $pubspecPath,
        $updatedPubspecContent,
        [System.Text.UTF8Encoding]::new($false)
    )
    $pubspecWasUpdated = $true

    Write-Host 'Build started.'
    Write-Host "Expected AAB path: $aabPath"

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
}
catch {
    if ($pubspecWasUpdated -and $null -ne $originalPubspecContent) {
        [System.IO.File]::WriteAllText(
            $pubspecPath,
            $originalPubspecContent,
            [System.Text.UTF8Encoding]::new($false)
        )
        Write-Host 'pubspec.yaml was restored to the previous version after build failure.'
    }

    Write-Host 'Android release AAB build failed.' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    throw
}
