project ?= ci-tool-stack
env ?= dev
sudo ?= sudo -E

compose_build_args = --force-rm
# compose_build_args += --no-cache
compose_args += -f docker-compose.yml
compose_args += $(shell [ -f  docker-compose.$(env).yml ] && echo "-f docker-compose.$(env).yml")

compose_out ?= docker-compose.out.yml

all: stop rm up
clean:
	$(sudo) docker system prune -f
config:
	$(sudo) docker-compose $(compose_args) config
build: config
	$(sudo) docker-compose $(compose_args) build $(SERVICE)
pull:
	$(sudo) docker-compose $(compose_args) pull $(SERVICE)
up: config
	$(sudo) docker-compose $(compose_args) up -d $(SERVICE)
restart:
	$(sudo) docker-compose $(compose_args) restart $(SERVICE)
rm:
	$(sudo) docker-compose $(compose_args) rm -f $(SERVICE)
stop:
	$(sudo) docker-compose $(compose_args) stop $(SERVICE)
logs:
	$(sudo) docker-compose $(compose_args) logs $(SERVICE)
# generate docker-compose.out.yml from all compose args (default + env)
template:
	$(sudo) docker-compose $(compose_args) config | tee $(compose_out)
build-template: $(compose_out)
	$(sudo) docker-compose -f $(compose_out) build $(compose_build_args) $(SERVICE)
up-template: $(compose_out)
	$(sudo) docker-compose -f $(compose_out) up -d $(SERVICE)
restart-template: $(compose_out)
	$(sudo) docker-compose -f $(compose_out) restart $(SERVICE)
stop-template: $(compose_out)
	$(sudo) docker-compose -f $(compose_out) stop $(SERVICE)
rm-template: $(compose_out)
	$(sudo) docker-compose -f $(compose_out) rm $(SERVICE)
test:
	echo $(compose_args)
