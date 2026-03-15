
@{
    RootModule        = 'KSMonMSSQL.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'b2c7e8c1-5f3a-4c0e-9f2f-123456789abc'
    Author            = 'Karl'
    Description       = 'SQL Server connection monitoring toolkit'
    FunctionsToExport = @(
        'Get-DbConnections',
        'Watch-DbConnections',
        'Export-DbConnectionLog',
        'Show-DbConnectionToast',
        'Write-DbConnectionTable'
    )
    PrivateData       = @{
        PSData = @{
            Tags = @('SQL','Monitoring','PowerShell','KSMonMSSQL')
        }
    }
}
