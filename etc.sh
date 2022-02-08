# video downloader
# https://github.com/iawia002/lux
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
sudo apt-get install ffmpeg
go install github.com/iawia002/lux@latest

ulimit -S -n 4096 

~/go/bin/lux  -i -p "https://www.bilibili.com/video/BV1b7411z7EP"
~/go/bin/lux -f 32-7 -p -start 2 -end 2 "https://www.bilibili.com/video/BV1b7411z7EP"
~/go/bin/lux -f 32-7 -p -eto -items 1,2,3 "https://www.bilibili.com/video/BV1b7411z7EP"


# change refresh rate
xrandr -r 75

# batch convert image file names
exiv2 -r '%Y.%m.%d--%H-%M-%S' -F rename *

# mount ecryptfs
sudo mount -t ecryptfs ~/.Private tmpp -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=n,ecryptfs_sig=xxxxxxxxxx

# openvpn
sudo apt-get install openvpn
sudo openvpn --config /path/to/config.ovpn

# /boot full
dpkg -l linux-{image,headers}-"[0-9]*" | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e '[0-9]' | xargs sudo apt-get -y purge  

# in case above failed follow instructions from
# https://gist.github.com/ipbastola/2760cfc28be62a5ee10036851c654600

# nomachine headless
sudo systemctl stop lightdm
sudo systemctl restart nxserver.service

# nomachine back to physical display, when video card is active
sudo service nxserver stop 
sudo service nxserver start

# ssh auto completion
# https://unix.stackexchange.com/questions/136351/autocomplete-server-names-for-ssh-and-scp
# ./ssh/config
# Host *
#    HashKnownHosts no


# ConEmu setting for wsl
# set "PATH=%ConEmuBaseDirShort%\wsl;%PATH%" & %ConEmuBaseDirShort%\conemu-cyg-64.exe --wsl -cur_console:pm:/mnt -cur_console:p
