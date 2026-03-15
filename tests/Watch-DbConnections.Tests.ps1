Describe "Watch-DbConnections" {
    It "Has the expected parameters" {
        $cmd = Get-Command Watch-DbConnections
        $cmd.Parameters.Keys | Should -Contain 'SqlInstance'
        $cmd.Parameters.Keys | Should -Contain 'Database'
        $cmd.Parameters.Keys | Should -Contain 'IntervalSeconds'
    }
}
