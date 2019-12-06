project ?= ci-tool-stack
env ?= dev
#sudo ?= sudo -E
sudo ?=

compose_build_args = --force-rm
compose_up_args = --no-build
#compose_build_args += --no-cache
compose_args += -f docker-compose.yml
compose_args += $(shell [ -f  docker-compose.$(env).yml ] && echo "-f docker-compose.$(env).yml")

compose_out ?= docker-compose.out.yml

default: help
	
help:
	@echo "make pull build stop up clean logs restart SERVICE='service-config'"

all: stop rm up

.PHONY: clean config build pull up restart rm stop logs
# Build
clean:
	$(sudo) docker system prune -f
	$(sudo) docker network prune -f
	$(sudo) docker volume prune -f
config:
	$(sudo) docker-compose -p $(project) $(compose_args) config
services:
	$(sudo) docker-compose -p $(project) $(compose_args) config --services
build: config
	$(sudo) docker-compose -p $(project) $(compose_args) build $(SERVICE)
pull:
	$(sudo) docker-compose -p $(project) $(compose_args) pull $(SERVICE)
pre-up:
	$(sudo) mkdir -p /opt/gitlab /opt/nexus-data /opt/jenkins
	$(sudo) chown 200 /opt/nexus-data
	$(sudo) chown 1000 /opt/jenkins
# Run
up: config
	$(sudo) docker-compose -p $(project) $(compose_args) up $(compose_up_args) -d $(SERVICE)
restart:
	$(sudo) docker-compose -p $(project) $(compose_args) restart $(SERVICE)
rm:
	$(sudo) docker-compose -p $(project) $(compose_args) rm -f $(SERVICE)
stop:
	$(sudo) docker-compose -p $(project) $(compose_args) stop $(SERVICE)
logs:
	$(sudo) docker-compose -p $(project) $(compose_args) logs $(SERVICE)

gitlab_backup_dir = /opt/gitlab/data/backups
jenkins_backup_dir = /opt/jenkins/backups

backup: backup-gitlab backup-jenkins copy-backup-file-gitlab copy-backup-file-jenkins swift-upload clean-backup

backup-gitlab:
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c 'gitlab-ctl status'
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c 'gitlab-rake gitlab:backup:create'
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c 'umask 0077; tar -cf /var/opt/gitlab/backups/$$(date "+etc-gitlab-%s.tar") -C / etc/gitlab'
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c 'ls -l /var/opt/gitlab/backups/'

backup-jenkins:
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T jenkins /bin/bash -c '( cd $$HOME ; umask 0077; mkdir -p backups ; tar -zcvf backups/jenkins-credentials.tar.gz secret* credentials.xml)'

mkdir-backups:
	mkdir -p backups
copy-backup-file-gitlab: mkdir-backups
	etcfile=$$(sudo ls -1r $(gitlab_backup_dir)/ |grep etc-gitlab |head -1) ; \
           gitlabfile=$$(sudo ls -1r $(gitlab_backup_dir)/ |grep gitlab_backup |head -1) ; \
         sudo cp $(gitlab_backup_dir)/$$etcfile backups ; \
         sudo cp $(gitlab_backup_dir)/$$gitlabfile backups ; \
         ( cd backups && sudo chown $$USER. *.tar )
copy-backup-file-jenkins: mkdir-backups
	jenkins_credentials=$$(sudo ls -1r $(jenkins_backup_dir)/ |grep jenkins-credentials |head -1) ; \
         sudo cp $(jenkins_backup_dir)/$$jenkins_credentials backups ; \
         ( cd backups && sudo chown $$USER. $$jenkins_credentials )

swift-upload:
	swift list backup -l --lh -p $$(date "+%Y-%m-%d")
	( cd backups && swift upload backup/$$(date "+%Y-%m-%d") *.tar *.tar.gz )
	swift list backup -l --lh -p $$(date "+%Y-%m-%d")

clean-backup:
	if [ -d backups ] ;then  rm -rf backups ; fi

restore: swift-download copy-restore-file

RESTORE_DATE ?= #$(shell date "+%Y-%m-%d")

mkdir-restore:
	mkdir -p restore

swift-download: mkdir-restore
	if [ -z "$(RESTORE_DATE)" ] ;then  exit 1; fi
	swift list backup -l --lh -p $(RESTORE_DATE)
	( cd restore && swift download backup -p $(RESTORE_DATE) )
	( cd restore && find $(RESTORE_DATE) -type f )

copy-restore-file: copy-restore-file-gitlab copy-restore-file-jenkins

copy-restore-file-gitlab:
	etcfile=$$(ls -1r restore/$(RESTORE_DATE) |grep etc-gitlab |head -1) ; \
           gitlabfile=$$(ls -1r restore/$(RESTORE_DATE) |grep gitlab_backup |head -1) ; \
         sudo cp restore/$(RESTORE_DATE)/$$etcfile $(gitlab_backup_dir)/$$etcfile; \
         sudo cp restore/$(RESTORE_DATE)/$$gitlabfile $(gitlab_backup_dir)/$$gitlabfile ; \
         ( sudo chown 998.998 $(gitlab_backup_dir)/$$gitlabfile $(gitlab_backup_dir)/$$etcfile )

restore-gitlab:
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c 'gitlab-ctl stop unicorn ; gitlab-ctl stop sidekiq'
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c '(cd /var/opt/gitlab/backups/ ; backup=$$(ls -r1 *_gitlab_backup.tar | head -1) ; gitlab-rake gitlab:backup:restore force=yes BACKUP=$$(basename $$backup _gitlab_backup.tar) )'
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c '(cd /var/opt/gitlab/backups/ ; etc=$$(ls -r1 /var/opt/gitlab/backups/etc-gitlab-*.tar | head -1) ; tar -xvf $$etc -C / )'
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c 'gitlab-ctl restart'
	$(sudo) docker-compose -p $(project) $(compose_args) exec -T gitlab /bin/bash -c 'gitlab-rake gitlab:check SANITIZE=true'


copy-restore-file-jenkins: mkdir-restore
	[ -d "$(jenkins_backup_dir)" ] || mkdir $(jenkins_backup_dir)
	sudo chown 1000 $(jenkins_backup_dir)
	if [ -d "restore/$(RESTORE_DATE)" ] ;then \
          jenkins_credentials=$$(ls -1r restore/$(RESTORE_DATE) |grep jenkins-credentials |head -1) ; \
          [ -z "$$jenkins_credentials" ] && exit 1 ; \
           sudo cp restore/$(RESTORE_DATE)/$$jenkins_credentials $(jenkins_backup_dir)/$$jenkins_credentials; \
           sudo chown 1000.1000 $(jenkins_backup_dir)/$$jenkins_credentials ; \
       fi

restore-jenkins:
	$(sudo) docker-compose -p $(project) $(compose_args) stop jenkins
	$(sudo) mv /opt/jenkins/identity.key.enc /opt/jenkins/identity.key.enc.backup
	$(sudo) tar -zxvf $(jenkins_backup_dir)/jenkins-credentials.tar.gz -C /opt/jenkins/
	$(sudo) docker-compose -p $(project) $(compose_args) up -d jenkins

.PHONY: template build-template pull-template up-template restart-template stop-template rm-template
# template: generate docker-compose -p $(project).out.yml from all docker-compose -p $(project) args (docker-compose -p $(project).yml + docker-compose.$env.yml)
# Build
template:
	$(sudo) docker-compose -p $(project) $(compose_args) config | tee $(compose_out)
config-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) config
services-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) config --services
build-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) build $(compose_build_args) $(SERVICE)
pull-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) pull $(SERVICE)
up-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) up -d $(SERVICE)
restart-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) restart $(SERVICE)
stop-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) stop $(SERVICE)
rm-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) rm -f $(SERVICE)
logs-template: $(compose_out)
	$(sudo) docker-compose -p $(project) -f $(compose_out) logs --tail=100 $(SERVICE)


.PHONY: package test publish clean-package
package:
	bash ./tools/package.sh
clean-package:
	rm -rf dist || true
test:
	bash ./tools/test.sh
publish:
	bash ./tools/publish.sh $(compose_args)
