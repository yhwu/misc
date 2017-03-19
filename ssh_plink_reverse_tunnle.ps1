# ssh reverse tunnel using putty plink
# The reason to use plink from putty is that openssh would always end up using 100% cpu after sometime, a bug that's known for long time.
# Here we want to access localhost:port by accessing remotehost:remoteport through a ssh reverse tunnel.
# The following script periodically checks if the connection is established, and if not start it.
# To start this script in background:
#     Start-Process powershell -ArgumentList "-File C:\Users\bob\thepath\ssh_plink_reverse_tunnel.ps1" -WindowStyle hidden
# To stop the script, it takes 2 steps: 
#     kill (Get-WmiObject Win32_Process | where CommandLine -Match 'ssh_plink_reverse').ProcessID
#     kill (Get-WmiObject Win32_Process | where CommandLine -Match 'plink.*localhost').ProcessID
#
$key = 'C:\Users\bob\.ssh\id_rsa.ppk'
$remoteport = '3489'
$remoteaccount = 'bob@bobcompu.com'
$localport = '3389'
$plinkargs = "-i $key -N -R 0.0.0.0:${remoteport}:localhost:$localport $remoteaccount"
$log = 'C:\Users\bob\log.ssh.txt'
do {
    $n = plink.exe -i $key $remoteaccount  'netstat -an' | sls $remoteport | Measure-Object
    if ($n.Count -ge 1 ) { (date) + ' : connected' | Add-Content $log }
    else {
        (date) + ' : broken' | Add-Content $log
        $processes = Get-WmiObject Win32_Process | where CommandLine -Match 'plink.*localhost:'
        ForEach ($p In $processes) { kill $p.ProcessID } 
        'plink ' + $plinkargs | Add-Content $log
        Start-Process -WindowStyle Hidden plink.exe -ArgumentList $plinkargs
    }
    Start-Sleep -Seconds 300
} While( 1 )
