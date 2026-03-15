Describe "Export-DbConnectionLog" {
    It "Accepts a path parameter" {
        $cmd = Get-Command Export-DbConnectionLog
        $cmd.Parameters.Keys | Should -Contain 'Path'
    }
}
