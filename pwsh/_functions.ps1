function checkFont($font) {
  [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
  $families = (New-Object System.Drawing.Text.InstalledFontCollection).Families
  $families -contains $font
}

# function fzfb { fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' $args }
function fzfb { fzf --multi --height=50% --margin=2%,2%,2%,2% --layout=reverse-list --border=double --info=inline --pointer='→' --marker='♡' --header='CTRL-c or ESC to quit' --preview 'bat --color=always --style=numbers --theme=gruvbox-dark --line-range=:500 {}' $args }
Set-Alias f fzfb

# folder bookmarks 
function dev { Set-Location ~/Projects }
function dev2 { Set-Location -Path H:\programming\projects }
function conf { Set-Location ~/.config }
function pwshconf { Set-Location -Path "$HOME/.config/pwsh" }
function pwshscripts { Set-Location -Path "$HOME/.config/pwsh/_scripts" }

# checks if module is imported to pwsh session
# function Add-Module ($m) {
#   if (Get-Module $m) {
#     Write-Output "Module $m is already imported."
#   }
#   else {
#     try {
#       Import-Module $m -ErrorAction Stop
#     }
#     catch {
#       Write-Output "Module $m not found locally or error while importing"
#       # Find the module online
#       if (Find-Module -Name $m | Where-Object { $_.Name -eq $m }) {
#         Install-Module -Name $m -Force -Verbose -Scope CurrentUser -AllowClobber
#         Import-Module $m -Verbose
#       }
#       else {
#         Write-Output "Module $m not available"
#       }
#     }
#   }
# }

# function Reload-Path {
# $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
# }

# ======================================================================================================

# function runRiot {
# Write-Output "Starting Riot Client..."
# Get-Process -Id (Start-Process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Riot Games\Riot Client.lnk" -passthru).ID
#
# }
#
# Set-Alias riot runRiot
