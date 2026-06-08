GREEN  = \033[0;32m
BLUE   = \033[0;34m
YELLOW = \033[0;33m
RED    = \033[0;31m
RESET  = \033[0m

COMPOSE  = docker compose -f srcs/docker-compose.yml

all:
	@echo -e "$(GREEN)Building and starting containers...$(RESET)"
	@mkdir -p /home/thmaitre--/data/mariadb_volume/
	@mkdir -p /home/thmaitre--/data/wp_volume/
	@$(COMPOSE) up --build -d
	@echo -e "$(GREEN)Containers are up and running!$(RESET)"

down:
	@echo -e "$(YELLOW)Stopping containers...$(RESET)"
	@$(COMPOSE) down
	@echo -e "$(YELLOW)Containers stopped.$(RESET)"

exec-mariadb:
	@echo -e "$(BLUE)Opening shell in mariadb container...$(RESET)"
	@docker exec -it mariadb sh

exec-wordpress:
	@echo -e "$(BLUE)Opening shell in wordpress container...$(RESET)"
	@docker exec -it wordpress sh

exec-nginx:
	@echo -e "$(BLUE)Opening shell in nginx container...$(RESET)"
	@docker exec -it nginx sh

logs-mariadb:
	@echo -e "$(BLUE)Showing logs for mariadb container...$(RESET)"
	@docker logs -f mariadb

logs-wordpress:
	@echo -e "$(BLUE)Showing logs for wordpress container...$(RESET)"
	@docker logs -f wordpress

logs-nginx:
	@echo -e "$(BLUE)Showing logs for nginx container...$(RESET)"
	@docker logs -f nginx

logs:
	@echo -e "$(BLUE)Showing logs for $(c) container...$(RESET)"
	@$(LOGS) -f $(c)

re: down all

clean: down
	@echo -e "$(RED)Cleaning docker system...$(RESET)"
	@docker system prune -af
	@echo -e "$(RED)Docker system cleaned.$(RESET)"

fclean: clean
	@echo -e "$(RED)Removing volumes data...$(RESET)"
	@rm -rf /home/thmaitre--/data/mariadb_volume/*
	@rm -rf /home/thmaitre--/data/wp_volume/*
	@echo -e "$(RED)Volumes data removed.$(RESET)"

.PHONY: all down re clean fclean
