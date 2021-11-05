# History handling
if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Emacs
    # Set-PSReadLineKeyHandler -Key Tab -Function Complete
}

# Git handling
Import-Module posh-git
# $env:POSH_GIT_ENABLED = $true

# Init oh-my-posh
oh-my-posh --init --shell pwsh --config ~/.powershell/oh-my-posh.json | Invoke-Expression

# Icons in dir
Import-Module -Name Terminal-Icons

. $PSScriptRoot\aliases.ps1
