.PHONY: up down restart build ps logs test ansible-deploy

up:
	docker-compose up -d --build

down:
	docker-compose down

restart:
	docker-compose restart

build:
	docker-compose build

ps:
	docker-compose ps

logs:
	docker-compose logs --tail=50

test:
	./scripts/smoke-test.sh

ansible-deploy:
	ansible-playbook -i ansible/hosts ansible/site.yml -K
