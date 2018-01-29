project ?=
env ?= dev
sudo ?= sudo -E

compose_args += -f docker-compose.yml
compose_args += $(shell [ -f  docker-compose.$(env).yml ] && echo "-f docker-compose.$(env).yml")

all: stop rm up
clean:
	$(sudo) docker system prune -f
build:
	$(sudo) docker-compose $(compose_args) build
pull:
	$(sudo) docker-compose $(compose_args) pull
up:
	$(sudo) docker-compose $(compose_args) up -d
restart:
	$(sudo) docker-compose $(compose_args) restart
rm:
	$(sudo) docker-compose $(compose_args) rm -f
stop:
	$(sudo) docker-compose $(compose_args) stop
logs:
	$(sudo) docker-compose $(compose_args) logs

test:
	echo $(compose_args)

