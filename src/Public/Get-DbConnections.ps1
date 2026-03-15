function Get-DbConnections {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SqlInstance,

        [Parameter(Mandatory)]
        [string]$Database
    )

    $Query = @"
SELECT 
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    s.last_request_start_time,
    s.last_request_end_time
FROM sys.dm_exec_sessions s
JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
WHERE s.database_id = DB_ID('$Database')
ORDER BY s.session_id;
"@

    Invoke-DbQuery -SqlInstance $SqlInstance -Database $Database -Query $Query
}
