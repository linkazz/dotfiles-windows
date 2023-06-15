# https://github.com/mikemaccana/powershell-profile/blob/master/defaults.ps1

# Produce UTF-8 by default
# https://news.ycombinator.com/item?id=12991690
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$MaximumHistoryCount = 10000;

# environment variables / [environment]::getfolderpath("mydocuments")
$env:DOCUMENTS = [Environment]::GetFolderPath("mydocuments")
# $env:PSScriptRoot =  "${env:ProgramFiles(x86)}\SysInternals Suite"

# Unblock-File $PSScriptRoot\whois.ps1
# . $PSScriptRoot\whois.ps1

# $PSScriptRoot = Get-ChildItem -Path "C:\Program Files (x86)\SysInternals Suite"
# foreach ($file in $PSScriptRoot) {
    # . $file.FullName
# }


# Just a couple of things (sed, to interpret sed scripts) from http://unxutils.sourceforge.net/
# Add-PathVariable "${env:ProgramFiles}\UnxUtils"

# For dig, host, etc.
# Add-PathVariable "${env:ProgramFiles}\ISC BIND 9\bin"

