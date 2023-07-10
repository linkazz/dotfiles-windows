<#====================================================================
@ Powershell 
====================================================================#>
# add details to tab completion values 
$s = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $services = Get-Service | Where-Object {$_.Status -eq "Running" -and $_.Name -like "$wordToComplete*"}
    $services | ForEach-Object {
        New-Object -Type System.Management.Automation.CompletionResult -ArgumentList $_.Name,
            $_.Name,
            "ParameterValue",
            $_.Name
    }
}
Register-ArgumentCompleter -CommandName Stop-Service -ParameterName Name -ScriptBlock $s

<#====================================================================
@ File Hashes
====================================================================#>
# Compute file hashes - useful for checking successful downloads 
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

<#====================================================================
@ Unix  
====================================================================#>

function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host "$command does not exist"; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
} 

# editor
if (Test-CommandExists nvim) {
    $EDITOR='nvim'
} elseif (Test-CommandExists vim) {
    $EDITOR='vim'
} elseif (Test-CommandExists pvim) {
    $EDITOR='pvim'
} elseif (Test-CommandExists code) {
    $EDITOR='code'
} elseif (Test-CommandExists notepad++) {
    $EDITOR='notepad++'
} 
Set-Alias -Name vim -Value $EDITOR

# touch
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

# sudo
function sudo(){
Invoke-Elevated @args
}

# symlink 
function newLink ($target, $link) {
New-Item -ItemType SymbolicLink -Path $link -Value $target
}
set-alias ln newLink

# export
function export($name, $value) {
set-item -force -path "env:$name" -value $value;
}

# fuser - looks any process running in the folder/subdirectories
# https://stackoverflow.com/questions/39148304/fuser-equivalent-in-powershell/39148540#39148540
function fuser($relativeFile){
$file = Resolve-Path $relativeFile
foreach ( $Process in (Get-Process)) {
  foreach ( $Module in $Process.Modules) {
    if ( $Module.FileName -like "$file*" ) {
      $Process | select id, path
    }
  }
}
}

# Like a recursive sed
function edit-recursive($filePattern, $find, $replace) {
$files = get-childitem . "$filePattern" -rec # -Exclude
write-output $files
foreach ($file in $files) {
  (Get-Content $file.PSPath) |
  Foreach-Object { $_ -replace "$find", "$replace" } |
  Set-Content $file.PSPath
}
}

# pwsh version of which
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

<#====================================================================
@ OS MANAGEMENT & MAINTENANCE 
====================================================================#>

# open windows settings 
function settings {
    Start-Process ms-settings:
  }
  
function df {
    get-volume
}

function reboot {
	shutdown /r /t 0
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

<#====================================================================
@ CUSTOM FUNCTIONS & PLUGINS
====================================================================#>

# preview files in directory with fzf 
function fzfb {
  fzf --multi --height=50% --margin=2%,2%,2%,2% --layout=reverse-list --border=double --info=inline --ansi --cycle --pointer='→' --marker='☆' --header='ctrl-c or esc to quit' --preview 'bat {}' $args
  }
Set-Alias f fzfb

function Invoke-FuzzyEdit()
{
    $files = fzfb 

    $editor = $env:EDITOR
    if ($editor -eq $null) {
        if ($IsWindows) {
            $editor = 'nvim'
        } else {
            $editor = 'code'
        }
    }
    if ($files -ne $null) {
        Invoke-Expression -Command ("$editor {0}" -f ($files -join ' ')) 
    }
}
Set-Alias -Name fe -Value Invoke-FuzzyEdit

# magic-wormhole
function whs {
  wormhole send $args
}
function whr {
  wormhole receive $args
}

# which posh check
function which_in_posh() {
    (gcm $args).Definition
}
Set-Alias which_omp which_in_posh

<#====================================================================
@ FILE/DIRECTORY NAVIGATION
====================================================================#>

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

# open in explorer
function xr() {
  explorer $args
}
Set-Alias open xr

# cd and ls 
function c() {
  $path = $args -join ' '
  Set-Location $path
  ls
}

function dev { 
  Set-Location ~/Projects 
  }

function dev2 { 
  Set-Location -Path H:\programming\projects 
  }

function conf {
  Set-Location ~/.config 
  }

function cyberdl {
  Set-Location -Path "H:\cyberdrop-dl"
}

function pwshconf {
  Set-Location -Path "$HOME/.config/pwsh" 
  }

function pwshscripts {
  Set-Location -Path "$HOME/.config/pwsh/_scripts" 
  }

# app:edge
function edge {
  & "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
  # & "${$env:Program Files (x86)}\Microsoft\Edge\Application\msedge.exe"
  }

# app:notepad++ 
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

<#====================================================================
@ TODO/FIX
====================================================================#>

# function checkFont($font) {
#   [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
#   $families = (New-Object System.Drawing.Text.InstalledFontCollection).Families
#   $families -contains $font
# }
