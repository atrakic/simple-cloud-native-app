MAKEFLAGS += --silent
ARGS = $(filter-out $@,$(MAKECMDGOALS))

APP := cloud-native-app-demo

.PHONY: up logs status stop mkdocs test clean

up:
	docker-compose up --no-deps --remove-orphans -d

logs:
	docker-compose logs -f

status:
	docker-compose ps -a

stop:
	docker-compose stop

mkdocs:
	mkdocs serve

test: up
	sleep 1
	[ -f ./tests/test.sh ] && ./tests/test.sh || true

clean: stop
	docker-compose down --volumes --remove-orphans

-include include.mk
