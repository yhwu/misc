# docker ps
docker ps -a
docker ps -a -f status=running
docker ps -aq

# docker rm
docker rm $(docker ps -aq -f status=exited)
docker rmi $(docker images -aq)
 
# docker images
docker images

# aws repo
aws ecr get-login --region us-east-1
docker login -u AWS -p xxxx
docker pull 123.dkr.ecr.us-east-1.amazonaws.com/adocker:latest

# mount aws s3, s3fs
docker run --rm --privileged -ti ubuntu
apt-get install -y s3fs
echo id:key > /root/.passwd-s3fs
chmod 600 /root/.passwd-s3fs

mkdir /tmp/cache
mkdir /s3mnt
chmod 777 /tmp/cache /s3mnt
s3fs -o use_cache=/tmp/cache abucket /s3mnt
# really slow performance, do not use

# mount aws s3, with https://github.com/skoobe/riofs
docker run --rm --privileged -ti ubuntu
apt-get update
apt-get install -y build-essential gcc make automake autoconf libtool pkg-config intltool libglib2.0-dev libfuse-dev libxml2-dev libevent-dev libssl-dev
wget https://github.com/skoobe/riofs/archive/master.zip
unzip master.zip
cd riofs-master
./autogen.sh
./configure
make
make install
mkdir ~/.config/riofs
export AWS_ACCESS_KEY_ID=Axxxxx
export AWS_SECRET_ACCESS_KEY=sxxxxx
mkdir -p /root/s3
riofs [bucketname] /root/s3
# this is much faster than s3fs
