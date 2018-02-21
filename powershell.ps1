#### $PROFILE ####
# set policy
Set-ExecutionPolicy RemoteSigned
set-ExecutionPolicy Unrestricted
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass # run as admin once

# Display only the current folder instead of the full path, set windows title to current path
function prompt {
  $host.ui.RawUI.WindowTitle = $(get-location)
  '[PS ' + ($pwd -split '\\')[0]+' '+$(($pwd -split '\\')[-1] -join '\') + '] '
}

# alias
If (Test-Path Alias:ssh) {Remove-Item Alias:ssh}
If (Test-Path Alias:scp) {Remove-Item Alias:scp}
If (Test-Path Alias:wget) {Remove-Item Alias:wget}

New-Alias ssh "C:\opt\msys64\usr\bin\ssh.exe"
New-Alias scp "C:\opt\msys64\usr\bin\scp.exe"
New-Alias wget "C:\opt\msys64\usr\bin\wget.exe"
New-Alias which get-command

# set conda env; tips from https://github.com/Liquidmantis/PSCondaEnvs
activate.ps1 elmapy

#### END OF $PROFILE ####


# mount/unmount network share
net use X: \\server\share /persistent:yes
net use X: /delete
Remove-PSDrive X


# get process
Get-Process python
Get-Process | where{$_.ProcessName -match 'py'}
Get-Process | where{$_.ProcessName -match 'python'  -and $_.cpu -gt 10 }
(Get-Process | where{$_.ProcessName -match 'python'  -and $_.cpu -gt 10 }).count

Get-Process python | Stop-Process
Get-WmiObject Win32_Process |  where{$_.processname -match 'python'}
Get-WmiObject Win32_Process |  where{$_.processname -match 'python'}  | select -first 2
Get-WmiObject Win32_Process |  where{$_.processname -match 'python'}  | select -first 2 | select commandline


# git for powershell
https://github.com/dahlbyk/posh-git

# ls -lst
ls | sort -Descending -property LastWriteTime
# remvoe folder
rm -Recurse -Force
# get full path of a file
ls .\python.ini | Select-Object FullName

# head, tail
Get-Content .\stdout.txt -Head 5
gc .\stdout.txt | select -first 5
Get-Content .\stdout.txt -Wait
Get-Content .\stdout.txt -Tail 5
gc .\stdout.txt | select -last 5

# grep 
cat C:\Windows\win.ini | Select-String ext
cat C:\Windows\win.ini | sls ext
cat C:\Windows\win.ini | sls -pattern "m.*ext"


# set PATH
setx PYTHONPATH "$env:PYTHONPATH;$pwd"

# open folder or files
Invoke-Item .
ii .
ii a.csv

