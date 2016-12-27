# Display only the current folder instead of the full path
# set windows title to current path
function prompt {
  $host.ui.RawUI.WindowTitle = $(get-location)
  '[PS ' + ($pwd -split '\\')[0]+' '+$(($pwd -split '\\')[-1] -join '\') + '] '
}

# permanant change
notepad++.exe $PROFILE

# git for powershell
https://github.com/dahlbyk/posh-git

# ls -lst
ls | sort -Descending -property LastWriteTime

# head, tail
Get-Content .\stdout.txt -Head 5
Get-Content .\stdout.txt -Wait
Get-Content .\stdout.txt -Tail 5

