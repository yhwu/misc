# get process
Get-Process python
Get-Process | where{$_.ProcessName -match 'py'}
Get-Process | where{$_.ProcessName -match 'python'  -and $_.cpu -gt 10 }
(Get-Process | where{$_.ProcessName -match 'python'  -and $_.cpu -gt 10 }).count

Get-Process python | Stop-Process
Get-WmiObject Win32_Process |  where{$_.processname -match 'python'}
Get-WmiObject Win32_Process |  where{$_.processname -match 'python'}  | select -first 2
Get-WmiObject Win32_Process |  where{$_.processname -match 'python'}  | select -first 2 | select commandline


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

# set PATH
setx PYTHONPATH "$env:PYTHONPATH;$pwd"

# open current folder with file explorer
Invoke-Item .
ii .


# open a file
Invoke-Item a.csv
ii a.csv

