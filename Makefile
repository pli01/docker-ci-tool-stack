project = ci-tool-stack
all: stop rm clean build up
clean:
	echo sudo -E docker system prune -f
build:
	sudo -E docker-compose pull
up:
	sudo -E docker-compose up
rm:
	sudo -E docker-compose rm -f
stop:
	sudo -E docker-compose stop
