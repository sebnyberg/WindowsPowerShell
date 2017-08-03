# Imports
Import-Module posh-git

# For nice colors when using ls and l
Import-Module Get-ChildItemColor
Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope

# The PowerShell alias cd runs Set-LocationWithGCI
# Let's remove the alias and run ls after each cd by default
function Set-LocationWithGCI {
    param($path)

    if(Test-Path $path) {
        $path = Resolve-Path $path
        Set-Location $path
        Get-ChildItemColor
    } else {
        "Could not find path $path"
    }
}

Remove-Item Alias:\cd
Set-Alias cd Set-LocationWithGCI

##################################################################################
# PSReadline makes PS behave more like zsh https://github.com/lzybkr/PSReadLine
##################################################################################
Import-Module PSReadline

Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000
# history substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
##########################################################################


# z lets you jump to frequently used directories.
# for example, if you have previously visited a folder called abc/def
# you can type 
# > z def 
# to enter the folder from any location
Import-Module z
Set-Alias z Search-NavigationHistory


##########################################################################
# Color settings for the prompt
##########################################################################
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

$global:GitPromptSettings.BeforeText = '['
$global:GitPromptSettings.AfterText  = '] '

function prompt {
    $origLastExitCode = $LASTEXITCODE
    Write-VcsStatus

    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($curPath.ToLower().StartsWith($Home.ToLower()))
    {
        $curPath = "~" + $curPath.SubString($Home.Length)
    }

    Write-Host $curPath -ForegroundColor Green
    $LASTEXITCODE = $origLastExitCode
    "$('>' * ($nestedPromptLevel + 1)) "
}

$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:Path += ";$ProfileRoot\Scripts"