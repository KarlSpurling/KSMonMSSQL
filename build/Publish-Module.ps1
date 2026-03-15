param(
    [Parameter(Mandatory)]
    [string]$NuGetApiKey,

    [string]$Repository = 'PSGallery',

    [string]$ModulePath = "$PSScriptRoot\output\KSMonMSSQL"
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $ModulePath)) {
    throw "Module path not found: $ModulePath. Run Build-Module.ps1 first."
}

$manifest = Get-ChildItem -Path $ModulePath -Filter '*.psd1' | Select-Object -First 1
if (-not $manifest) {
    throw "No module manifest (.psd1) found under $ModulePath"
}

Write-Host "Publishing module from: $($manifest.FullName)"
Write-Host "Repository: $Repository"

Publish-Module `
    -Path $ModulePath `
    -NuGetApiKey $NuGetApiKey `
    -Repository $Repository `
    -Verbose
