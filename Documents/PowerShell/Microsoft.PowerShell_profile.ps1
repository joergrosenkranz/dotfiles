# History handling
$isInteractiveConsole =
    $Host.Name -eq 'ConsoleHost' -and
    $Host.UI -and $Host.UI.RawUI -and
    $Host.UI.SupportsVirtualTerminal -and
    -not [Console]::IsOutputRedirected -and
    -not [Console]::IsInputRedirected

$isWindowsTerminal = [bool]$env:WT_SESSION
$isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or [bool]$env:VSCODE_PID

if ($isInteractiveConsole) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    if ($isVSCode) {
        Set-PSReadLineOption -PredictionViewStyle InlineView
    } elseif ($isWindowsTerminal) {
        Set-PSReadLineOption -PredictionViewStyle ListView
    } else {
        Set-PSReadLineOption -PredictionViewStyle ListView
    }
    Set-PSReadLineOption -EditMode Emacs
    # Set-PSReadLineKeyHandler -Key Tab -Function Complete
}

# Git handling
Import-Module posh-git
# $env:POSH_GIT_ENABLED = $true

# Init oh-my-posh
oh-my-posh --init --shell pwsh --config $PSScriptRoot\oh-my-posh.json | Invoke-Expression

# Icons in dir
Import-Module -Name Terminal-Icons

. $PSScriptRoot\aliases.ps1

