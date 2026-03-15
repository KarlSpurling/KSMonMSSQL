Describe "Get-DbConnections" {
    It "Runs without error with dummy parameters (integration tests should override)" {
        { Get-DbConnections -SqlInstance "localhost" -Database "master" } | Should -Not -Throw
    }
}
