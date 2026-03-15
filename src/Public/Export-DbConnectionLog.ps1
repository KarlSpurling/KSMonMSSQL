function Export-DbConnectionLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SqlInstance,

        [Parameter(Mandatory)]
        [string]$Database,

        [Parameter(Mandatory)]
        [string]$Path
    )

    $Rows = Get-DbConnections -SqlInstance $SqlInstance -Database $Database

    if ($Rows) {
        $Rows |
            Select-Object *, @{Name = 'Timestamp'; Expression = { Get-Date }} |
            Export-Csv -Path $Path -Append -NoTypeInformation
    }
}
