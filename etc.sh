# batch convert image file names
exiv2 -r '%Y.%m.%d--%H-%M-%S' -F rename *

# mount ecryptfs
sudo mount -t ecryptfs ~/.Private tmpp -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=n,ecryptfs_sig=xxxxxxxxxx
