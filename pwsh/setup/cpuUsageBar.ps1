$bar = @(
    '🟦🟦🟦🟦🟦🟦',
    '🟩🟦🟦🟦🟦🟦',
    '🟩🟩🟦🟦🟦🟦',
    '🟩🟩🟨🟦🟦🟦',
    '🟩🟩🟨🟨🟦🟦',
    '🟩🟩🟨🟨🟧🟦',
    '🟩🟩🟨🟨🟧🟥'
)
$cpuUsageBar = $bar[[Math]::Min([Int]$cpuUsage, 5)] # 6% max
'CPU: {0}' -f $cpuUsageBar
