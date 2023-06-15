function checkFont($font) {
  [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
  $families = (New-Object System.Drawing.Text.InstalledFontCollection).Families
  $families -contains $font
}

# preview files in directory with fzf 
function fzfb {
  fzf --multi --height=50% --margin=2%,2%,2%,2% --layout=reverse-list --border=double --info=inline --pointer='→' --marker='♡' --header='CTRL-c or ESC to quit' --preview 'bat --color=always --style=numbers --theme=gruvbox-dark --line-range=:500 {}' $args
  }
Set-Alias f fzfb

# directory and app bookmarks 
function dev { 
  Set-Location ~/Projects 
  }

function dev2 { 
  Set-Location -Path H:\programming\projects 
  }

function conf {
  Set-Location ~/.config 
  }

function pwshconf {
  Set-Location -Path "$HOME/.config/pwsh" 
  }

function pwshscripts {
  Set-Location -Path "$HOME/.config/pwsh/_scripts" 
  }

function edge {
  & "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
  # & "${$env:Program Files (x86)}\Microsoft\Edge\Application\msedge.exe"
  }

# open windows settings
function settings {
    Start-Process ms-settings:
  }

function newLink ($target, $link) {
	New-Item -ItemType SymbolicLink -Path $link -Value $target
  }
set-alias ln newLink

# unix touch in pwsh
# Remove-Alias touch
function touch($file) {
	if ( Test-Path $file ) {
		Set-FileTime $file
	} else {
		New-Item $file -type file
	}
}

# looks any process running in the folder/subdirectories (fuser)
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



# ======================================================================================================

# function runRiot {
# Write-Output "Starting Riot Client..."
# Get-Process -Id (Start-Process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Riot Games\Riot Client.lnk" -passthru).ID
#
# }
#
# Set-Alias riot runRiot
