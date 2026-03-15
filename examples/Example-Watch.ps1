Import-Module "$PSScriptRoot\..\src\KSMonMSSQL.psd1"

$SqlInstance = "SQL01"
$Database    = "MyDB"

Watch-DbConnections -SqlInstance $SqlInstance -Database $Database -IntervalSeconds 5
