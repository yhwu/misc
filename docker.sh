# docker ps
docker ps -a
docker ps -a -f status=running
docker ps -aq

# docker rm
docker rm $(docker ps -aq -f status=exited)
docker rmi $(docker images -aq)
 
# docker images
docker images


