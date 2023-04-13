#! bin/sh

# commands given in the correction to clean docker before starting the correction
docker stop $(docker ps -qa); 
docker rm $(docker ps -qa); 
docker rmi -f $(docker images -qa); 
docker volume rm $(docker volume ls -q);
docker network rm $(docker network ls -q) 2>/dev/null;

# not indicated in correction but it's necessary to clean this data
sudo rm -rf /home/$(USER)/data/wp_db/* /home/$(USER)/data/wp_files/*;
