#requires -module DynamicTitle

function StartDTStatusBar2 {
    $modulePath = (Get-Module DynamicTitle).Path

    #update every 30 minutes
    $weatherJob = Start-DTJobBackgroundThreadTimer -ScriptBlock {
        $weather = Invoke-RestMethod https://wttr.in/?format="%c%t\n"
        $weather
    } -IntervalMilliseconds 1800000

    #update every 2 seconds
    $systemInfoJob = Start-DTJobBackgroundThreadTimer -ScriptBlock {
        $cpuUsage = (Get-Counter -Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
        $cpuUsage
    } -IntervalMilliseconds 2000

    #test every 15 minutes
    $DiskInfoJob = Start-DTJobBackgroundThreadTimer -ScriptBlock {
        $c = Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DeviceID = "C:"' -Property Size, FreeSpace
        ($c.FreeSpace / $c.size)
    } -IntervalMilliseconds 900000

    #update every 30 seconds
    $memInfoJob = Start-DTJobBackgroundThreadTimer -ScriptBlock {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -Property FreePhysicalMemory, TotalVisibleMemorySize
        ($os.FreePhysicalMemory / $os.TotalVisibleMemorySize)
    } -IntervalMilliseconds 30000

    $initializationScript = {
        param ($modulePath)
        Import-Module $modulePath
    }

    $scriptBlock = {
        param($weatherJob, $systemInfoJob, $diskInfoJob, $memInfoJob)

        $weather = Get-DTJobLatestOutput $weatherJob
        $cpuUsage = Get-DTJobLatestOutput $systemInfoJob
        $diskInfo = Get-DTJobLatestOutput $DiskInfoJob
        $memInfo = Get-DTJobLatestOutput $memInfoJob
        $date = Get-Date -Format 'MMM dd HH:mm:ss'

        '📆 {0} {1} - 🔥CPU:{2:f1}% 💽{3:p2} free 💻{4:p2} free' -f $date, $weather, [double]$cpuUsage, [double]$DiskInfo, [double]$Meminfo
    }

    $params = @{
        ScriptBlock                          = $scriptBlock
        ArgumentList                         = $weatherJob, $systemInfoJob, $DiskInfoJob, $memInfoJob
        InitializationScript                 = $initializationScript
        InitializationArgumentList           = $modulePath
        HorizontalScrollFrameWidth           = 30
        HorizontalScrollIntervalMilliseconds = 200
    }

    Start-DTTitle @params
}

StartDTStatusBar2
