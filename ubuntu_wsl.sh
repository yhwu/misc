# install ubuntu from windows store

## sudo visudo, add line 
# $user ALL=NOPASSWD: /usr/bin/apt-get*, /usr/sbin/sshd*, /usr/sbin/service*
# note this line must be after all other lines.

## 1 openssh-server

sudo apt-get install openssh-server
sudo dpkg-reconfigure openssh-server