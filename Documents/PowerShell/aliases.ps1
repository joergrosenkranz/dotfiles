# Alias definitions

function MsBuild2026 {
    & "C:\Program Files\Microsoft Visual Studio\18\Professional\MSBuild\Current\Bin\amd64\MSBuild.exe" -nologo -m -P:VI_PROJECTDIR="$(git rev-parse --show-toplevel)" @args
}

function Get-GitRoot () {
    return $(git rev-parse --show-toplevel)
}

Set-Alias -Name msbuild -Value MsBuild2026

function Alias-Hierarchy {
    $root = Get-GitRoot
    $current = $(git rev-parse --show-prefix).Replace('/', '\').Replace('.', '_').TrimEnd('\')
    msbuild "$root\Build\Hierarchy.proj" "-P:PostBuildEvent=" "-T:$current" @args
}
Set-Alias -Name hierarchy -Value Alias-Hierarchy
Set-Alias -Name buildrel -Value Alias-Hierarchy

function Alias-HierarchyPreview {
    $root = Get-GitRoot
    $current = $(git rev-parse --show-prefix).Replace('/', '\').Replace('.', '_').TrimEnd('\')
    msbuildpreview "$root\Build\Hierarchy.proj" "-P:PostBuildEvent=" "-T:$current" @args
}
Set-Alias -Name hierarchypreview -Value Alias-HierarchyPreview

function Alias-BuildDbg {
    hierarchy "-P:VICFG=DEBUG" "-P:BUILD_WEB=no" @args
}
Set-Alias -Name builddbg -Value Alias-BuildDbg

function Alias-BuildDbgPreview {
    hierarchypreview "-P:VICFG=DEBUG" "-P:BUILD_WEB=no" @args
}
Set-Alias -Name builddbgpreview -Value Alias-BuildDbgPreview

function Alias-BuildDbgWeb {
    hierarchy "-P:VICFG=DEBUG" @args
}
Set-Alias -Name builddbgweb -Value Alias-BuildDbgWeb

# ----

function Alias-HierarchyNC {
    $root = Get-GitRoot
    $current = $(git rev-parse --show-prefix).Replace('/', '\').Replace('.', '_').TrimEnd('\')
    msbuild "$root\Build\Hierarchy.netcore.proj" "-P:PostBuildEvent=" "-P:NetCore=true" "-T:$current" @args
}
Set-Alias -Name hierarchync -Value Alias-HierarchyNC
Set-Alias -Name buildrelnc -Value Alias-HierarchyNC

function Alias-BuildDbgNC {
    hierarchync "-P:VICFG=DEBUG" "-P:BUILD_WEB=no" @args
}
Set-Alias -Name builddbgnc -Value Alias-BuildDbgNC

function Alias-BuildDbgWebNC {
    hierarchync "-P:VICFG=DEBUG" @args
}
Set-Alias -Name builddbgwebnc -Value Alias-BuildDbgWebNC

# ----

function Alias-All {
    $root = Get-GitRoot
    msbuild "$root\Build\Build.proj" "-P:PostBuildEvent=" "-nodeReuse:False" @args
}
Set-Alias -Name all -Value Alias-All
Set-Alias -Name allrel -Value Alias-All

function Alias-AllDbg {
    all "-P:VICFG=DEBUG" "-P:BUILD_WEB=no" "-P:BuildInParallel=true" @args
}
Set-Alias -Name alldbg -Value Alias-AllDbg

function Alias-AllDbgWeb {
    all "-P:VICFG=DEBUG" "-P:BuildInParallel=true" @args
}
Set-Alias -Name alldbgweb -Value Alias-AllDbgWeb

# ----

function Alias-AllNC {
    $root = Get-GitRoot
    msbuild "$root\Build\Build.proj" "-P:PostBuildEvent=" "-P:NetCore=true" "-nodeReuse:False" @args
}
Set-Alias -Name allnc -Value Alias-AllNC
Set-Alias -Name allrelnc -Value Alias-AllNC

function Alias-AllDbgNC {
    allnc "-P:VICFG=DEBUG" "-P:BUILD_WEB=no" "-P:BuildInParallel=true" @args
}
Set-Alias -Name alldbgnc -Value Alias-AllDbgNC

function Alias-AllDbgWebNC {
    allnc "-P:VICFG=DEBUG" "-P:BuildInParallel=true" @args
}
Set-Alias -Name alldbgwebnc -Value Alias-AllDbgWebNC

# ----

function Alias-SourceQuode {
    $root = Get-GitRoot

    & "$root\Assemblies\SourceQode.exe" "--LoadHotfix=$($root.Replace('/', '\'))"
}

Set-Alias -Name sc -Value Alias-SourceQuode

function Alias-SourceQuodeNC {
    $root = Get-GitRoot

    & "$root\Assemblies\SourceQodeNC.exe" "--LoadHotfix=$($root.Replace('/', '\'))"
}

Set-Alias -Name scnc -Value Alias-SourceQuodeNC

function Alias-ResxEditor {
    $root = Get-GitRoot

    & "$root\Assemblies\ResXLanguageEditor.exe" "$($root.Replace('/', '\'))"
}

Set-Alias -Name re -Value Alias-ResxEditor

function Alias-Root() {
    Set-Location $(Get-GitRoot)
}
Set-Alias -Name root -Value Alias-Root

function Get-GitLastBranch {
    $match = git reflog | select-string -Pattern 'checkout: moving from (.*) to' | Select-Object -ExpandProperty Matches -First 1
    return $match.groups[1].Value
}

function Alias-RemoveLastBranch {
    $lastBranch = Get-GitLastBranch
    git branch -d "$lastBranch" @args
}
Set-Alias -Name rm-lastbranch -Value Alias-RemoveLastBranch

function Run-Mono {
    $P = $PWD.Path.Replace('\', '/')
    docker run -it --rm -v "$($P):/asm" -w /asm mono:latest @args
}

function Run-Core {
    $P = $PWD.Path.Replace('\', '/')
    docker run -it --rm -v "$($P):/asm" -w /asm mcr.microsoft.com/dotnet/core/runtime:latest @args
}


# function _WorkTreeCompleter{
#     param ( $commaName,
#             $parameterName,
#             $wordToComplete,
#             $commandAst,
#             $fakeBoundParameters )

#     $(& git worktree list | % { $_.Split(' ')[0] })
# }

function Change-Branch {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Branch
    )

	if ( ! $Branch ) {
		Write-Output "You need to provide a branch name"
		return 1
    }

	$BranchRoot = $(& git worktree list | select-string "[$Branch]" -SimpleMatch | % { $_.Line.Split(' ')[0] })
	$RelativePath="$(& git rev-parse --show-prefix)"

	$NewPath = "$BranchRoot\$RelativePath"

	Set-Location "$NewPath"
}

Microsoft.PowerShell.Core\Register-ArgumentCompleter -CommandName Change-Branch -ParameterName Branch -ScriptBlock {
    param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

    if ( $WordToComplete ) {
        $matching = git worktree list | select-string -Pattern '$WordToComplete' -SimpleMatch
    } else {
        $matching = git worktree list | select-string -Pattern '.*'
    }

    $result =  $matching | ForEach-Object{ [regex]::matches($_.Line, '\[([^\]]+)\]').groups[1].value | Sort-Object }
    # $result =  $matching | ForEach-Object {
    #     $branch = [regex]::matches($_.Line, '\[([^\]]+)\]').groups[1].value
    #     $dir = $_.Line.Split(' ')[0]

    #     New-Object -Type System.Management.Automation.CompletionResult -ArgumentList $branch, $branch, "ParameterValue", $dir
    # }

    $result
}

Set-Alias -Name cb -Value Change-Branch

function frg {
    $result = rg --ignore-case --color=always --line-number --no-heading @Args |
        fzf --ansi `
            --color 'hl:-1:underline,hl+:-1:underline:reverse' `
            --delimiter ':' `
            --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" `
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
    if ($result) {
        $parts = $result.Split(':')
        & code -g "$($parts[0]):$($parts[1])"
    }
}

