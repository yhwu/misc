# take ownership of files and grant permission
takeown /F <filename>
takeown /f <foldername> /r /d y
takeown /r /d y /f f:\backup 
icacls f:\backup /t /grant Everyone:(OI)(CI)F

# enable disable hibernation, run elevated
powercfg -h on
powercfg -h off

# permanantly disable windows firewall on windows 10
netsh advfirewall set allprofiles state off

# by registry
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\Standard Profile]
"DisableNotifications"=dword:00000001
"DoNotAllowExceptions"=dword:00000001
"EnableFirewall"=dword:00000000


# permanantly disable windows defender in windows 10
# use Local Group Policy Editor,  gpedit.msc, C:\Windows\System32\gpedit.msc
# go to Computer Configuration/Administrative Templates/Windows Components/Windows Defender


# disable password experiration
net accounts /maxpwage:unlimited

# fix quick access working on it 
# http://www.thewindowsclub.com/quick-access-in-windows-10-is-not-working
# clear the following folders and reboot
%AppData%\Microsoft\Windows\Recent\AutomaticDestinations
%AppData%\Microsoft\Windows\Recent\CustomDestinations

