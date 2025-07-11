NAME = inception

DOCKER_COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml

VOLUMES = mariadb_data wordpress_data

GREEN = \033[0;32m
RESET = \033[0m

.PHONY: all up down build clean fclean re

all: up

up:
	@echo "$(GREEN)🔼 Starting containers...$(RESET)"
	mkdir -p /home/clouaint/data/mariadb
	mkdir -p /home/clouaint/data/wordpress
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

delete:
	rm -rf /home/clouaint/data/*

down:
	@echo "$(GREEN)🔽 Stopping containers...$(RESET)"
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

build:
	@echo "$(GREEN)🏗️  Building all images...$(RESET)"
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

clean:
	@echo "$(GREEN)🧹 Removing containers...$(RESET)"
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

fclean: clean delete
	@echo "$(GREEN)🧨 Removing volumes...$(RESET)"
	docker rmi -f mariadb wordpress nginx 2>/dev/null || true

re: fclean build up
