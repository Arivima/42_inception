NAME=Inception

all:	
	@ docker-compose -f srcs/docker-compose.yml up -d

down:
	@ docker-compose -f srcs/docker-compose.yml down

stop:
		@ docker-compose -f srcs/docker-compose.yml stop

clean:	stop
		@ docker-compose -f srcs/docker-compose.yml down --volume --rmi all
		

fclean:	clean
		sudo rm -rf /home/$(USER)/data/wp_db/* /home/$(USER)/data/wp_files/*
		docker system prune -a -f

re:		fclean all
		@ sh srcs/requirements/tools/configure.sh
		@ docker-compose -f srcs/docker-compose.yml up --build

.PHONY:	all stop clean fclean re
