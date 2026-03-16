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
        # Parse instance and port
        if ($SqlInstance -match ',') {
            $parts = $SqlInstance.Split(',')
            $server = $parts[0]
            $port   = $parts[1]
            $dataSource = "$server,$port"
        }
        else {
            $dataSource = $SqlInstance
        }

        $connString = "Server=$dataSource;Database=$Database;Trusted_Connection=True;Encrypt=False;"
        Write-Log "Connecting using: $connString"

        $conn = New-Object System.Data.SqlClient.SqlConnection $connString
        $conn.Open()

        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $Query

        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $cmd
        $table = New-Object System.Data.DataTable
        $adapter.Fill($table) | Out-Null

        $conn.Close()

        return $table
    }
    catch {
        $msg = "SQL connection/query failed: $($_.Exception.Message)"
        Write-Log $msg
        Write-Warning $msg
        throw
    }
}
