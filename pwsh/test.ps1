<# hashtable
creating custom $Var = @{
  Name = Value
}
#>

$scriptPath = "$HOME\.config\pwsh\scripts"

function Get-Scripts {
  $scriptPath | fzfb
}
