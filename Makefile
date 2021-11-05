all: up

up:
	docker-compose up --remove-orphans

down:
	docker-compose down --volumes