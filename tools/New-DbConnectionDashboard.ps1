param(
    [Parameter(Mandatory)]
    [string]$SqlInstance,

    [Parameter(Mandatory)]
    [string]$Database,

    [Parameter(Mandatory)]
    [string]$OutputPath
)

if (-not (Get-Command Get-DbConnections -ErrorAction SilentlyContinue)) {
    Import-Module "$PSScriptRoot\..\src\KSMonMSSQL.psd1"
}

$rows = Get-DbConnections -SqlInstance $SqlInstance -Database $Database

$templatePath = "$PSScriptRoot\..\dashboards\connections.html"
if (-not (Test-Path $templatePath)) {
    throw "Dashboard template not found at $templatePath"
}

$template = Get-Content -Path $templatePath -Raw

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$rowHtml = ""

foreach ($r in $rows) {
    $rowHtml += "<tr>" +
        "<td>$($r.session_id)</td>" +
        "<td>$($r.login_name)</td>" +
        "<td>$($r.host_name)</td>" +
        "<td>$($r.program_name)</td>" +
        "<td>$($r.status)</td>" +
        "<td>$($r.last_request_start_time)</td>" +
        "<td>$($r.last_request_end_time)</td>" +
        "</tr>`r`n"
}

$output = $template.Replace('{{timestamp}}', $timestamp).Replace('{{rows}}', $rowHtml)

$output | Out-File -FilePath $OutputPath -Encoding utf8

Write-Host "Dashboard written to $OutputPath"
