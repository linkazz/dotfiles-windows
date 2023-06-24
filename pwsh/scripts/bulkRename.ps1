# Prompt the user for the directory path, file extension, and base file name
$dir = Read-Host "Enter the directory path: "
$ext = Read-Host "Enter the file extension: "
$baseName = Read-Host "Enter the base file name: "

# retrieve and count all files to be renamed in the directory
# track number of files renamed to break loop  
$files = Get-ChildItem -Path $dir -Filter $ext
$totalRename = $files.Count
$renamedFiles = 0 

# loop through each file and rename it with new baseName + incremental number
$i = 1
foreach ($file in $files) {
    $newName = $baseName + $i + $file.Extension
    Rename-Item -Path $file.FullName -NewName $newName
    $i++
    $renamedFiles++

    if ($renamedFiles -eq $totalRename) {
        Get-ChildItem -Path $dir
        Write-Host # output blank line
        Write-Host "Rename complete!" -ForegroundColor Green -NoNewline
        Write-Host "`e[1m"
        break
      }
}

# list contents of dir wonce renaming is complete
# Get-ChildItem -Path $dir 
