function Write-DbConnectionTable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SqlInstance,

        [Parameter(Mandatory)]
        [string]$Database,

        [Parameter(Mandatory)]
        [string]$TableName
    )

    $Rows = Get-DbConnections -SqlInstance $SqlInstance -Database $Database

    if (-not $Rows) {
        return
    }

    foreach ($Row in $Rows) {
        $login   = $Row.login_name.Replace("'", "''")
        $host    = $Row.host_name.Replace("'", "''")
        $program = $Row.program_name.Replace("'", "''")
        $status  = $Row.status.Replace("'", "''")

        $lastStart = if ($Row.last_request_start_time) { $Row.last_request_start_time.ToString("yyyy-MM-dd HH:mm:ss.fff") } else { $null }
        $lastEnd   = if ($Row.last_request_end_time)   { $Row.last_request_end_time.ToString("yyyy-MM-dd HH:mm:ss.fff") } else { $null }

        $Insert = @"
INSERT INTO $TableName
    (session_id, login_name, host_name, program_name, status, last_request_start_time, last_request_end_time, [timestamp])
VALUES
    ($($Row.session_id),
     '$login',
     '$host',
     '$program',
     '$status',
     $(if ($lastStart) { "CONVERT(datetime2,'$lastStart',121)" } else { "NULL" }),
     $(if ($lastEnd)   { "CONVERT(datetime2,'$lastEnd',121)" } else { "NULL" }),
     SYSDATETIME());
"@

        Invoke-DbQuery -SqlInstance $SqlInstance -Database $Database -Query $Insert
    }
}
