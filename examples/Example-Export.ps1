Import-Module "$PSScriptRoot\..\src\KSMonMSSQL.psd1"

$SqlInstance = "SQL01"
$Database    = "MyDB"
$Path        = "C:\Logs\DbConnections.csv"

Export-DbConnectionLog -SqlInstance $SqlInstance -Database $Database -Path $Path
