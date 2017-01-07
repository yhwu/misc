# ssh reverse tunnel using plink
# The reason to use plink from putty is that openssh would always end up using 100% cpu after sometime, a bug that's known for long time.
# Here we want to access localhost:port from remotehost:remoteport by opening a reverse tunnel.
# The following script periodically checks if the connection is established, and if not start plink.
# To start this script in background:
#     Start-Process powershell -ArgumentList "-File C:\Users\bob\thepath\ssh_plink_reverse_tunnel.ps1" -WindowStyle hidden
# To stop the script, it takes 2 steps: 
#     kill (Get-WmiObject Win32_Process | where CommandLine -Match 'ssh_plink_reverse').ProcessID
#     kill (Get-WmiObject Win32_Process | where CommandLine -Match 'plink.*localhost').ProcessID
#
#
$key = 'C:\User\bob\.ssh\id_rsa.ppk'
$plinkargs = "-i $key -N -R 0.0.0.0:3489:localhost:3389 bob@bobscompu.com"
$log = 'C:\Users\bob\log.txt'
do {
    $n = plink.exe -i $key bob@bobscompu.com  'netstat -an' | sls 3489 | Measure-Object
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
