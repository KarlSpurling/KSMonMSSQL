function Invoke-DbQuery {
    param(
        [Parameter(Mandatory)]
        [string]$SqlInstance,

        [Parameter(Mandatory)]
        [string]$Database,

        [Parameter(Mandatory)]
        [string]$Query
    )

    try {
        # Detect host,port format
        if ($SqlInstance -match ',') {
            $parts = $SqlInstance.Split(',')
            $server = $parts[0]
            $port   = $parts[1]

            $conn = "Server=tcp:$server,$port;Database=$Database;Trusted_Connection=True;"
            Write-Log "Connecting using connection string: $conn"

            return Invoke-Sqlcmd -ConnectionString $conn -Query $Query -ErrorAction Stop
        }
        else {
            Write-Log "Connecting using ServerInstance=$SqlInstance Database=$Database"
            return Invoke-Sqlcmd -ServerInstance $SqlInstance -Database $Database -Query $Query -ErrorAction Stop
        }
    }
    catch {
        $msg = "SQL connection failed: $($_.Exception.Message)"
        Write-Log $msg
        Write-Warning $msg
        throw
    }
}
