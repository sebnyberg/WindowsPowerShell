# WindowsPowerShell
A collection of PowerShell scripts which facilitate renaming etc.

## Rename within all files

```PowerShell
$filter = "*"
$files = Get-ChildItem . $filterRegex -Recurse -File
$before = "MyStringToReplace"
$after = "MyReplacedString"

foreach ($file in $files)
{
  (Get-Content $file).replace($before, $after) 
  | Set-Content $file.PSPath
}
```

Short version
```PowerShell
# gci = Get-ChildItem
# gc = Get-Content
# sc = Set-Content
# % = foreach
# $_ = current item in the foreach loop

gci . * -recurse -file | %{ (gc $_).replace('myName', 'Sebastian') | sc $_.PSPath }
```
