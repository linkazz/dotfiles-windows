#  set ohmyposh theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/1_shell.omp.json" | Invoke-Expression
# Import-Module CompletionPredictor

# import pwsh modules
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
    Import-Module Terminal-Icons
    Import-Module PSFzf
    Import-Module z
}

# loop and source all .ps1 files in the directory
$scriptFiles = Get-ChildItem -Path "$HOME\.config\pwsh" -Filter "*.ps1"
foreach ($file in $scriptFiles) {
    . $file.FullName
}

# set env variables
$env:FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git --color=always --strip-cwd-prefix"
$env:FZF_CTRL_T_COMMAND=$env:FZF_DEFAULT_COMMAND
$env:FZF_DEFAULT_OPTS= "--height=80% --layout=reverse --ansi --info=inline --tabstop=2 -m --cycle --scroll-off=4"
$env:XDG_CONFIG_HOME = "$HOME/.config"

# set psreadline options
$PSReadLineOptions = @{
    EditMode = "Windows"
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    PredictionSource = "HistoryAndPlugin"
    PredictionViewStyle = "ListView"
    BellStyle = "Visual"
    Colors = @{
        "InlinePrediction" = "#606060"
        "Emphasis" = "#d580ff"
        # "ContinuationPrompt" = "#"
        # "Error" = "#"
        # "Selection" = "#"
        # "Default" = "#"
        # "Comment" = "#"
        # "Keyword" = "#"
        # "String" = "#"
        # "Operator" = "#"
        # "Variable" = "#"
        # "Command" = "#"
        # "Parameter" = "#"
        # "Type" = "#"
        # "Number" = "#"
        # "Member" = "#"
        # "ListPrediction" = "#"
        # "ListPredictionSelected" = "#"
      }
  }
  Set-PSReadLineOption @PSReadLineOptions

# set psfzf (fzf) options
$PsFzfOptions = @{
    TabExpansion = $true
    PSReadlineChordProvider = 'Ctrl+t'
    PSReadlineChordReverseHistory = 'Ctrl+r'
    # PSReadlineChordSetLocation = ''
    # PSReadlineChordReverseHistoryArgs = ''
    # GitKeyBindings = $true
    # EnableAliasFuzzyEdit = $true #fe
    # EnableAliasFuzzyFasd = $true #ff (fasdr)
    # EnableAliasFuzzyHistory = $true #fh
    # EnableAliasFuzzySetLocation = $true #fd
    # EnableAliasFuzzySetEverything = $true #cde
    # EnableAliasFuzzyZLocation = $true #fz
    EnableAliasFuzzyKillProcess = $true #fkill
    EnableAliasFuzzyScoop = $true #fs 
    EnableAliasFuzzyGitStatus = $true #fgs
    EnableFd = $true
    # AltCCommand = 'Alt+c'
  }
  Set-PsFzfOption @PsFzfOptions

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete




# ======================================================================================================
#$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
#$ENV:STARSHIP_DISTRO = "者"
#Invoke-Expression (&starship init powershell)
