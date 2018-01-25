project ?= ci-tool-stack
env ?= dev
sudo ?= sudo -E

compose_args += -f docker-compose.yml
compose_args += $(shell [ -f  docker-compose.$(env).yml ] && echo "-f docker-compose.$(env).yml")

all: stop rm clean build up
clean:
	echo $(sudo) docker system prune -f
build:
	$(sudo) docker-compose $(compose_args) pull
up:
	$(sudo) docker-compose $(compose_args) up
rm:
	$(sudo) docker-compose $(compose_args) rm -f
stop:
	$(sudo) docker-compose $(compose_args) stop

test:
	echo $(compose_args)

