param(
    [Parameter(Mandatory)]
    [string]$Message,

    [string]$Path = "$PSScriptRoot\..\..\logs\module.log"
)

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"$Timestamp $Message" | Out-File -FilePath $Path -Append -Encoding utf8
