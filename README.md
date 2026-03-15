\# KSMonMSSQL



KSMonMSSQL is a lightweight, standalone PowerShell module for monitoring SQL Server database connections \*\*without requiring sysadmin rights\*\*.



It provides:



\- `Get-DbConnections` — snapshot of active sessions  

\- `Watch-DbConnections` — live monitor with change detection  

\- `Export-DbConnectionLog` — historical CSV logging  

\- `Show-DbConnectionToast` — toast notifications for new sessions  

\- `Write-DbConnectionTable` — log to SQL table  

\- Optional HTML dashboard



\---



\## Features



\- \*\*No sysadmin required\*\* — uses `VIEW DATABASE STATE` to monitor only your database.  

\- \*\*Modular\*\* — clean separation of public/private functions.  

\- \*\*Real-time monitoring\*\* — detects new sessions and highlights them.  

\- \*\*Logging\*\* — CSV, SQL table, or HTML dashboard.  

\- \*\*Cross-platform\*\* — works on Windows, Linux, macOS (toast only on Windows).



\---



\## Installation



```powershell

Import-Module ./src/KSMonMSSQL.psd1

Usage
powershell
# Snapshot
Get-DbConnections -SqlInstance SQL01 -Database MyDB

# Live monitor
Watch-DbConnections -SqlInstance SQL01 -Database MyDB -IntervalSeconds 5

# Log to CSV
Export-DbConnectionLog -SqlInstance SQL01 -Database MyDB -Path C:\Logs\DbConnections.csv

# Toast notifications (Windows only)
Show-DbConnectionToast -SqlInstance SQL01 -Database MyDB

# Log to SQL table
Write-DbConnectionTable -SqlInstance SQL01 -Database MyDB -TableName DbConnectionLog

CI
A GitHub Actions workflow is included under .github/workflows/ci.yml to run Pester tests on push and PR.

License
MIT License — see LICENSE.


