all: up

up:
	docker-compose down --volumes
	docker-compose up -d --remove-orphans

down:
	docker-compose down --volumes