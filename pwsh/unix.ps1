# symlink 
function newLink ($target, $link) {
	New-Item -ItemType SymbolicLink -Path $link -Value $target
  }
set-alias ln newLink

# touch
function touch($file) {
	if ( Test-Path $file ) {
		Set-FileTime $file
	} else {
		New-Item $file -type file
	}
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

function sudo(){
	Invoke-Elevated @args
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

# https://gist.github.com/aroben/5542538
# function pstree {
# 	$ProcessesById = @{}
# 	foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
# 		$ProcessesById[$Process.ProcessId] = $Process
# 	}
#
# 	$ProcessesWithoutParents = @()
# 	$ProcessesByParent = @{}
# 	foreach ($Pair in $ProcessesById.GetEnumerator()) {
# 		$Process = $Pair.Value
#
# 		if (($Process.ParentProcessId -eq 0) -or !$ProcessesById.ContainsKey($Process.ParentProcessId)) {
# 			$ProcessesWithoutParents += $Process
# 			continue
# 		}
#
# 		if (!$ProcessesByParent.ContainsKey($Process.ParentProcessId)) {
# 			$ProcessesByParent[$Process.ParentProcessId] = @()
# 		}
# 		$Siblings = $ProcessesByParent[$Process.ParentProcessId]
# 		$Siblings += $Process
# 		$ProcessesByParent[$Process.ParentProcessId] = $Siblings
# 	}
#
# 	function Show-ProcessTree([UInt32]$ProcessId, $IndentLevel) {
# 		$Process = $ProcessesById[$ProcessId]
# 		$Indent = " " * $IndentLevel
# 		if ($Process.CommandLine) {
# 			$Description = $Process.CommandLine
# 		} else {
# 			$Description = $Process.Caption
# 		}
#
# 		Write-Output ("{0,6}{1} {2}" -f $Process.ProcessId, $Indent, $Description)
# 		foreach ($Child in ($ProcessesByParent[$ProcessId] | Sort-Object CreationDate)) {
# 			Show-ProcessTree $Child.ProcessId ($IndentLevel + 4)
# 		}
# 	}
#
# 	Write-Output ("{0,6} {1}" -f "PID", "Command Line")
# 	Write-Output ("{0,6} {1}" -f "---", "------------")
#
# 	foreach ($Process in ($ProcessesWithoutParents | Sort-Object CreationDate)) {
# 		Show-ProcessTree $Process.ProcessId 0
# 	}
# }

function find-file($name) {
	get-childitem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach-object {
		write-output($PSItem.FullName)
	}
}

set-alias find find-file
set-alias find-name find-file

function reboot {
	shutdown /r /t 0
}
