Import-Module "$PSScriptRoot\..\src\KSMonMSSQL.psd1"

$SqlInstance = "SQL01"
$Database    = "MyDB"

Show-DbConnectionToast -SqlInstance $SqlInstance -Database $Database
