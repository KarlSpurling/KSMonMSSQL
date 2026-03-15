param(
    [Parameter(Mandatory)]
    [string]$SqlInstance,

    [Parameter(Mandatory)]
    [string]$Database,

    [Parameter(Mandatory)]
    [string]$Query
)

Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Database -Query $Query
