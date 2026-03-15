function Show-DbConnectionToast {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SqlInstance,

        [Parameter(Mandatory)]
        [string]$Database
    )

    if (-not $IsWindows) {
        Write-Warning "Show-DbConnectionToast is only supported on Windows."
        return
    }

    $Current = Get-DbConnections -SqlInstance $SqlInstance -Database $Database

    if (-not $Current) {
        Write-Host "No active connections to show."
        return
    }

    Add-Type -AssemblyName 'Windows.UI'

    foreach ($Row in $Current) {
        $text = "User $($Row.login_name) from $($Row.host_name)"

        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(
            [Windows.UI.Notifications.ToastTemplateType]::ToastText02
        )

        $nodes = $template.GetElementsByTagName("text")
        $nodes.Item(0).AppendChild($template.CreateTextNode("New SQL Connection")) | Out-Null
        $nodes.Item(1).AppendChild($template.CreateTextNode($text)) | Out-Null

        $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("KSMonMSSQL")
        $toast    = [Windows.UI.Notifications.ToastNotification]::new($template)
        $notifier.Show($toast)
    }
}
