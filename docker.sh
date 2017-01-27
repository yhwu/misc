# docker ps
docker ps -a
docker ps -a -f status=running
docker ps -aq
docker rm $(docker ps -aq -f status=exited)

# docker images
docker images


