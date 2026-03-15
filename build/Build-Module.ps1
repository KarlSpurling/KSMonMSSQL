param(
    [string]$OutputPath = "$PSScriptRoot\output"
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
}

$moduleRoot = Join-Path $PSScriptRoot '..\src'
$destModuleRoot = Join-Path $OutputPath 'KSMonMSSQL'

if (Test-Path $destModuleRoot) {
    Remove-Item -Recurse -Force $destModuleRoot
}

Copy-Item -Path $moduleRoot -Destination $destModuleRoot -Recurse

Write-Host "Module copied to $destModuleRoot"
