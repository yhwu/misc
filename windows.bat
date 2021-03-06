# chrome remote desktop curtain mode
# https://support.google.com/chrome/a/answer/2799701?hl=en
# run cmd as administrator
reg add HKLM\Software\Policies\Google\Chrome /v RemoteAccessHostRequireCurtain /d 1 /t REG_DWORD /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /d 0 /t REG_DWORD /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v SecurityLayer /d 1 /t REG_DWORD /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /d 0 /t REG_DWORD /f  
net stop chromoting  
net start chromoting


# program has stopped working, close the program, disable it
# https://www.raymond.cc/blog/disable-program-has-stopped-working-error-dialog-in-windows-server-2008/
1. run gpedit.msc as administrator, 
Computer Configuration > 
Administrative Templates > 
Windows Components > 
Windows Error Reporting >
"Prevent display of the user interface for critical errors", enable

2. regedit
HKEY_CURRENT_USER\Software\Microsoft\Windows\Windows Error Reporting
set DontShowUI to 1

3. Control Panel > Action Center > Change Action Center settings (top left) > Problem reporting settings
Select "Never check for solutions"


# take ownership of files and grant permission
takeown /F <filename>
takeown /f <foldername> /r /d y
takeown /r /d y /f f:\backup 
icacls f:\backup /t /grant Everyone:(OI)(CI)F

# unlock bitlocker encrypted drives
manage-bde -unlock D: -rk C:\tmp\D.BEK

# enable disable hibernation, run elevated
powercfg -h on
powercfg -h off


# permanantly disable windows firewall on windows 10
netsh advfirewall set allprofiles state off
netsh firewall set notifications mode = disable profile = profile


# disable password experiration
net accounts /maxpwage:unlimited


# start ubuntu WSL services, save the following as vbs, and put in shell:startup 
set ws=wscript.createobject("wscript.shell")
ws.run "C:\Windows\System32\bash.exe -c 'sudo service cron start; sudo /usr/sbin/sshd -D'",0


# by registry
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\Standard Profile]
"DisableNotifications"=dword:00000001
"DoNotAllowExceptions"=dword:00000001
"EnableFirewall"=dword:00000000


# permanantly disable windows defender in windows 10
# use Local Group Policy Editor,  gpedit.msc, C:\Windows\System32\gpedit.msc
# go to Computer Configuration/Administrative Templates/Windows Components/Windows Defender


# disable windows autoupdate
gpedit.msc
Navigate to Computer Configuration\Administrative Templates\Windows Components\Windows Update


# fix quick access working on it 
# http://www.thewindowsclub.com/quick-access-in-windows-10-is-not-working
# clear the following folders and reboot
%AppData%\Microsoft\Windows\Recent\AutomaticDestinations
%AppData%\Microsoft\Windows\Recent\CustomDestinations


# rsync, ssh in powershell
# install msys2, follow the instructions https://msys2.github.io/
# use pacman to install openssh, rsync
# note msys2 pacman.exe interferes with mactype, add the following to mactype's default.ini
[UnloadDll]
gpg.exe
pacman.exe
# rsync, ssh, make sure ssh can login without password in msys64 console
C:\Opt\msys64\usr\bin\rsync.exe -av -e "C:\Opt\msys64\usr\bin\ssh.exe" /c/Users/bob/etc 192.168.1.2:~/tmp/
