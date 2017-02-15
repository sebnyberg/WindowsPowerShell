param(
    [Parameter(Mandatory=$true)][string] $filterRegex = "*", 
    [Parameter(Mandatory=$true)][string] $before,
    [Parameter(Mandatory=$true)][string] $after
)
if (!$filterRegex) 
{
    $filterRegex = "*"
}
$files = Get-ChildItem . $filterRegex -Recurse

foreach ($file in $files) 
{
    (Get-Content $file.PSPath) |
    ForEach-Object { $_ -replace $before, $after } |
    Set-Content $file.PSPath
} 
