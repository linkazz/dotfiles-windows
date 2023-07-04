
$browserPath = 'C:\Program Files\Mozilla Firefox\firefox.exe'

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

# function fpath {
#   $processName = Get-Process | fzf
#   if ($processName) {
#     $processPath = $processName.Path | Select-Object -unique
#     Write-Host $processPath
#   } else {
#     Write-Host "Path Failed"
#   }
# } 
