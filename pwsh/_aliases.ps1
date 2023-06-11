function lsd_all() {
  lsd.exe -a $args
}

function lsd_list() {
  lsd.exe -l $args
}

function lsd_list_all() {
  lsd.exe -la $args
}
Set-Alias ls lsd_list_all
Set-Alias la lsd_all
Set-Alias ll lsd_list
Set-Alias lla lsd

# open in windows explorer
function xr() {
  explorer $args
}
Set-Alias open xr

# which posh check
function which_in_posh() {
    (gcm $args).Definition
}
Set-Alias which_omp which_in_posh

# pwsh version of which
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
# touch cmd for windows
function crt() {
  New-Item $args
}
Set-Alias touch crt

# change directory and list files
function C() {
  $path = $args -join ' '
  Set-Location $path
  ls
}

# create directory and cd
function mk() {
  $directoryName = $args -join ' '
  mkdir -p $directoryName
  Set-Location $directoryName
}

# remove files/folder
function rmf() {
  rm -Force $args
}

# windows symlink
function New-Link ($path, $target) {
  New-Item -ItemType SymbolicLink -Path $path -Value $target
}

# alterative to waifu-2x
Set-Alias w2x waifu2x-ncnn-vulkan

# notepad++ 
function npp {
    param (
        [string]$FilePath = $null
    )
    $nppPath = 'F:\Notepad++\notepad++.exe'
    if (Test-Path $nppPath) {
        if ($FilePath) {
            Start-Process $nppPath $FilePath
        } else {
            Start-Process $nppPath
        }
    } else {
        Write-Host "Notepad++ is not installed on this computer."
    }
}

# Set-Alias v fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim
