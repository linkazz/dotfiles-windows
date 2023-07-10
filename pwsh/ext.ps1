
$browserPath = 'C:\Program Files\Mozilla Firefox\firefox.exe'
$tidalPath = 'C:\Users\linka\AppData\Local\TIDAL\app-2.34.2\TIDAL.exe'

function processPath ($processName){
  $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
  if ($process) {
    $processPath = $process.Path | Select-Object -unique
    # Write-Host -ForegroundColor Green "Path Found: " $processPath 
    Write-Host $processPath 
  } else {
    Write-Host "Process not found"
  }
}

function web ($websiteURL){
    Start-Process -Path $browserPath -ArgumentList $websiteURL
 }

function tidal {
  Start-Process -Path $tidalPath -WindowStyle Normal
}

# function fpath {
#   $processName = Get-Process | fzf
#   if ($processName) {
#     $processPath = $processName.Path | Select-Object -unique
#     Write-Host $processPath
#   } else {
#     Write-Host "Path Failed"
#   }
# } 
