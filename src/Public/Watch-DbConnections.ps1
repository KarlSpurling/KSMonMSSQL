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

        # Get current snapshot
        $Current = Get-DbConnections -SqlInstance $SqlInstance -Database $Database

        # Detect NEW connections
        $New = $null
        if ($Previous) {
            $New = Compare-Object -ReferenceObject $Previous -DifferenceObject $Current -Property session_id -PassThru |
                   Where-Object { $_.SideIndicator -eq '=>' }
        }
        elseif ($Current) {
            # First run: treat all as new
            $New = $Current
        }

        # Detect DROPPED connections
        $Dropped = $null
        if ($Previous) {
            $Dropped = Compare-Object -ReferenceObject $Previous -DifferenceObject $Current -Property session_id -PassThru |
                       Where-Object { $_.SideIndicator -eq '<=' }
        }

        # Log NEW connections
        if ($New) {
            foreach ($conn in $New) {
                $msg = "NEW CONNECTION: session_id=$($conn.session_id) login=$($conn.login_name) host=$($conn.host_name) program=$($conn.program_name)"
                Write-Log $msg
            }
        }

        # Log DROPPED connections
        if ($Dropped) {
            foreach ($conn in $Dropped) {
                $msg = "DROPPED CONNECTION: session_id=$($conn.session_id) login=$($conn.login_name) host=$($conn.host_name) program=$($conn.program_name)"
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

        # Display NEW connections
        if ($New) {
            Write-Host "`n*** NEW CONNECTION(S) DETECTED ***" -ForegroundColor Yellow
            $New | Format-Table -AutoSize
        }

        # Display DROPPED connections
        if ($Dropped) {
            Write-Host "`n*** DROPPED CONNECTION(S) DETECTED ***" -ForegroundColor Red
            $Dropped | Format-Table -AutoSize
        }

        # Prepare for next loop
        $Previous = $Current
        Start-Sleep -Seconds $IntervalSeconds
    }
}
