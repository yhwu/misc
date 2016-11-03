#!/bin/bash

# ssh reverse tunnel
# the following script makes a windwos desktop behind a firewall available at publichost
#
# make sure that the folliwng is enabled in /etc/ssh/sshd_config on publichost
# GatewayPorts yes
# ClientAliveInterval 300
# ClientAliveCountMax 2
#
# to check if the tunnel is active or not, run the following on publichost
#  netstat -an | grep 3389
#
# to use a different port on publichost change port in 0.0.0.0:3389
#
# to connect to a non-standard port, use publichost:3489 for remote desktop client

COMMAND="ssh -fqgN -R 0.0.0.0:3489:localhost:3389 user@host.com"                              
                                                                                                            
while true; do                                                                                              
    n=$(ssh -q user@host.com  "netstat -an | grep 3489 | wc -l")                                      
    if [ -z "$n" ]; then n=0; fi                                                                            
    if [ "$n" -ge "1" ]; then                                                                               
        :                                                                                                   
        echo  [$(date)]  "connected"                                                                        
    else                                                                                                    
        echo [$(date)] "tunnel broken"                                                                      
        pid=$(awk '{ split(FILENAME,f,"/") ; printf "%s: %s\n", f[3],$0 }' /proc/[0-9]*/cmdline | grep --tex
t ssh.*fqgN.*0.0.0.0.*3389 | cut -d: -f1)                                                                   
        echo "deadpid=$pid"                                                                                 
        if [[ ! -z "$pid" ]]; then                                                                          
            echo "kill $pid"                                                                                
            kill $pid                                                                                       
        fi                                                                                                  
        echo [$(date)] $COMMAND                                                                             
        $COMMAND                                                                                            
    fi                                                                                                      
    sleep 200                                                                                               
done                                                                                                        
                                                                                                            
exit                                                                                                        