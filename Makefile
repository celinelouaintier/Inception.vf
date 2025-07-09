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
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

down:
	@echo "$(GREEN)🔽 Stopping containers...$(RESET)"
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

build:
	@echo "$(GREEN)🏗️  Building all images...$(RESET)"
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

clean:
	@echo "$(GREEN)🧹 Removing containers...$(RESET)"
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

fclean: clean
	@echo "$(GREEN)🧨 Removing volumes...$(RESET)"
	docker volume rm $(VOLUMES) 2>/dev/null || true

re: fclean build up
