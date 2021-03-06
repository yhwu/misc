# some issues and solutions https://low.bi/p/Pd19w2jwRO0#h3-17

# install ubuntu from windows store
# run powershell elevated
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

## sudo visudo, add line 
# $user ALL=NOPASSWD: /usr/bin/apt-get*, /usr/sbin/sshd*, /usr/sbin/service*
# note this line must be after all other lines.

## 0 disable update, too many dangerous side effects
sudo apt remove unattended-upgrades

## 1 openssh-server, remember to open port in firewall, remember to allow password
sudo apt-get install openssh-server
sudo dpkg-reconfigure openssh-server

## 2 add user to sudoers
sudo visudo
# paste at the end of file, replace $USER with user name
$USER ALL=(ALL) NOPASSWD: ALL 

# https://gist.github.com/dentechy/de2be62b55cfd234681921d5a8b6be11
# Register a scheduled task to start ubuntu services at system startup.
# Make sure windows version is 1903 and above
# run powershell elevated
$jobname = "StartUbuntu"
$script =  "Start Ubuntu services"
$action = New-ScheduledTaskAction –Execute "C:\Windows\System32\wsl.exe" -Argument  "-u root service ssh start; service cron start"
$trigger = New-ScheduledTaskTrigger -AtStartup
$Description="start ubuntu services"
$msg = "Enter the username and password that will run the task"; 
$credential = $Host.UI.PromptForCredential("Task username and password",$msg,"$env:userdomain\$env:username",$env:userdomain)
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -RunLevel Highest -User $username -Password $password -Settings $settings -Description $Description


