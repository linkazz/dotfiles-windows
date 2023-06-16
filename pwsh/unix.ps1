# symlink 
function newLink ($target, $link) {
	New-Item -ItemType SymbolicLink -Path $link -Value $target
  }
set-alias ln newLink

# export
function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

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

