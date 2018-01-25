project ?= ci-tool-stack
env ?= dev

compose_args += -f docker-compose.yml
compose_args += $(shell [ -f  docker-compose.$(env).yml ] && echo "-f docker-compose.$(env).yml")

all: stop rm clean build up
clean:
	echo sudo -E docker system prune -f
build:
	sudo -E docker-compose $(compose_args) pull
up:
	sudo -E docker-compose $(compose_args) up
rm:
	sudo -E docker-compose $(compose_args) rm -f
stop:
	sudo -E docker-compose $(compose_args) stop

test:
	echo $(compose_args)

