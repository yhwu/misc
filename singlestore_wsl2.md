# Installation WSL2

1. Turn on windows features:
   * Virtual Machine Platform
   * Windows Subsystem for Linux

2. Update WSL2 core
   ```
   Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi  -OutFile wsl_update_x64.msi
   Start-Process wsl_update_x64.msi
   wsl --set-default-version 2
   ```

3. Install ubuntu to non default folder
    ```
    mkdir D:\WSL2
    cd D:\WSL2
   Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
   Rename-Item .\Ubuntu.appx Ubuntu.zip
   Expand-Archive .\Ubuntu.zip -Verbose
   cd .\Ubuntu
   ./ubuntu2004.exe
   wsl -l -v
    ``` 

4. Remove a distro
    ```
    wsl -l -v
    wsl --unregister Ubuntu-test
    ```

5. Backup & restore
    ```
   wsl --shutdown
   wsl --export Ubuntu-20.04  F:\Ubuntu-20.04.tar
   wsl --import Ubuntu-20.04  D:\WSL2\ubuntu F:\Ubuntu-20.04.tar
   ```
    Remember to change registration key under  
    ```HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss```

6. Resize WSL partition to 512GB
   - Following Microsoft guideline https://docs.microsoft.com/en-us/windows/wsl/vhd-size
   ```commandline
   wsl --shutdown
   wsl -l -v
   cmd 
   diskpart
   DISKPART> Select vdisk file="D:\WSL2\Ubuntu\ext4.vhdx"
   DISKPART> detail vdisk
   DISKPART> expand vdisk maximum=512000
   DISKPART> exit
   # note run cmd as admin, size is specified in MB.
   ```
   - Inside wsl
   ```commandline
   sudo mount -t devtmpfs none /dev
   mount | grep ext4
   sudo resize2fs /dev/sdb 512000M
   ```

# Installation SingleStore
1. Installation
    ```commandline
    sudo su
    apt-get update
    apt install -y apt-transport-https
    
    wget -O - 'https://release.memsql.com/release-aug2018.gpg'  2>/dev/null | apt-key add -
    apt-key list
    echo "deb [arch=amd64] https://release.memsql.com/production/debian memsql main" | tee /etc/apt/sources.list.d/memsql.list
    apt-get update
    apt install -y memsql-toolbox memsql-client memsql-studio
    ssh-keygen -A
    service ssh status
    service ssh start
    exit
   ```
   
   run the following as user
   ```
   export LICENSE_KEY=xxxxxxxxxxx
   export PASSWORD=xxxxxxxxxxxx
   memsql-deploy cluster-in-a-box --license $LICENSE_KEY --password $PASSWORD
   ```

2. Start/stop database  
   - run as user
    ```
    memsql-admin list-nodes
    memsql-admin start-node --all
    memsql-admin stop-node --all
    ```

3. start singlestore studio
    - run as root 
    ```
    sudo su
    memsql-studio &>/tmp/memsql-studio.log &
    ```
    
# SingleStore MISC

1. set sync variable
    ```
    SELECT @@snapshot_trigger_size;
    SET CLUSTER snapshot_trigger_size = 1073741824;
    ```

2. take snapshot to truncate log
    ```
   SNAPSHOT DATABASE dbname;
    ```

# Expose port 3306
   * Singlestore installed binding to WSL2 ubuntu's 127.0.0.1
   * WSL2 automatically forwards windows 127.0.0.1 ports to ubuntu's 127.0.0.1
   * We only need to forward window's 0.0.0.0's port to window's 127.0.0.1 to expose a ubuntu's port
   * run the following as administrator and make sure firewall is not blocking port 3306
   ```
   netsh interface portproxy add v4tov4 listenport=3306 listenaddress=0.0.0.0 connectport=3306 connectaddress=127.0.0.1
   ```

