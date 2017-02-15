param(
    [Parameter(Mandatory=$true)][string] $before,
    [Parameter(Mandatory=$true)][string] $after
)

Get-ChildItem -Filter "*$before*" -Recurse | 
Rename-Item -NewName {$_.name -replace $before, $after }
