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

        Clear-Host
        Write-Host "Active connections as of $(Get-Date):`n"

        if ($Current) {
            $Current | Format-Table -AutoSize
        } else {
            Write-Host "No active connections."
        }

        $New = $null
        if ($Previous) {
            $New = Compare-Object -ReferenceObject $Previous -DifferenceObject $Current -Property session_id -PassThru |
                   Where-Object { $_.SideIndicator -eq '=>' }
        } elseif ($Current) {
            $New = $Current
        }

        if ($New) {
            Write-Host "`n*** NEW CONNECTION(S) DETECTED ***" -ForegroundColor Yellow
            $New | Format-Table -AutoSize
        }

        $Previous = $Current
        Start-Sleep -Seconds $IntervalSeconds
    }
}
