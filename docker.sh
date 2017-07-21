# docker run
docker run -it --name image-dev ubuntu:16.04 /bin/bash
docker run --rm -it --name image-dev ubuntu:16.04 /bin/bash # remove after exit
docker start -i 18ff6cec386a # attach to a quited docker
docker exec -i -t 665b4a1e17b6 /bin/bash # attach to a running docker

# dock stop
docker stop --time=30 foo
docker kill --signal=SIGINT foo
docker rm --force foo

# docker ps
docker ps -a
docker ps -a -f status=running
docker ps -aq

# docker rm
docker rm $(docker ps -aq -f status=exited)
docker rmi $(docker images -aq)
 
# docker images
docker images
docker diff image-dev
docker save -o <save image to path> <image name>
docker load -i <path to image file>

# docker commit
docker commit -m 'something' 1xxxxxxa ubuntu-a1

# tag an image
docker tag yhwu/docker-whale 5xxxxxx9.dkr.ecr.us-east-1.amazonaws.com/adocker:latest

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
# much faster than s3fs, but better use it for backup than normal read and write
