#requires -module DynamicTitle

<#
DTPSInfo.ps1
Display the PowerShell version and how long the session has been running.
#>

$ProcessJob = Start-DTJobBackgroundThreadTimer -ScriptBlock {
    $ProcessRun = '{0:d\.hh\:mm\:ss}' -f (New-TimeSpan -Start ((Get-Process -Id $pid).StartTime) -End (Get-Date))
    $ProcessRun
} -IntervalMilliseconds 1000

$scriptBlock = {
    Param($ProcessJob)
    $ProcessRun = Get-DTJobLatestOutput $ProcessJob
    "PS {0} ⏱️{1}" -f $PSVersionTable.PSVersion,$ProcessRun
}
$params = @{
    ScriptBlock                = $scriptBlock
    ArgumentList               = $ProcessJob
    HorizontalScrollFrameWidth = 30
}

Start-DTTitle @params
