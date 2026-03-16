function Watch-DbConnections {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SqlInstance,

        [Parameter(Mandatory)]
        [string]$Database,

        [int]$IntervalSeconds = 5
    )

    Write-Host "Watching connections to '$Database' on $SqlInstance..."
    Write-Host "Press Ctrl+C to stop.`n"

    $Previous = @()

    while ($true) {
        $Current = Get-DbConnections -SqlInstance $SqlInstance -Database $Database

        # Detect new connections
        $New = $null
        if ($Previous) {
            $New = Compare-Object -ReferenceObject $Previous -DifferenceObject $Current -Property session_id -PassThru |
                   Where-Object { $_.SideIndicator -eq '=>' }
        }
        elseif ($Current) {
            # First run: treat all as new
            $New = $Current
        }

        # Log only NEW connections
        if ($New) {
            foreach ($conn in $New) {
                $msg = "NEW CONNECTION: session_id=$($conn.session_id) login=$($conn.login_name) host=$($conn.host_name) program=$($conn.program_name)"
                Write-Log $msg
            }
        }

        # Display table
        Clear-Host
        Write-Host "Active connections as of $(Get-Date):`n"

        if ($Current) {
            $Current | Format-Table -AutoSize
        } else {
            Write-Host "No active connections."
        }

        if ($New) {
            Write-Host "`n*** NEW CONNECTION(S) DETECTED ***" -ForegroundColor Yellow
            $New | Format-Table -AutoSize
        }

        $Previous = $Current
        Start-Sleep -Seconds $IntervalSeconds
    }
}
