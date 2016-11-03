#!/bin/bash                                                                       

# disable firewall                                                                
sudo ufw disable                                                                  
sudo ufw reset --force                                                            

# set default rules: deny all incoming traffic, allow all outgoing traffic        
sudo ufw default deny incoming                                                  
sudo ufw default allow outgoing

# allow local                                                 
sudo ufw allow from 127.0.0.0/24                                                  
sudo ufw allow from 192.168.1.0/24                                                

# host names                                                                      
trusted="name1                                                      
name2                                                           
name3"                                                          

for h in $trusted; do                                                             
    echo $h                                                                       
    ip=`host $h | awk '{print $NF}'`                                              
    sudo ufw allow from $ip                                                       
done                                                                              

# allow ips                                                                        
sudo ufw allow from 71.244.96.24

# enable firewall                                                                 
sudo ufw enable                                                                   
sudo ufw status verbose                                                           

# note for ssh, remember /etc/hosts.allow                                         