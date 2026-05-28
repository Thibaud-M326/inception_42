COMPOSE_FILE	:= srcs/docker-compose.yml
ENV_FILE		:= srcs/.env
COMPOSE			:= docker compose -f $(COMPOSE_FILE)
SECRETS			:= secrets/db_root_password.txt \
				   secrets/db_password.txt \
				   secrets/wp_admin_password.txt \
				   secrets/wp_user_password.txt

ifneq (,$(wildcard $(ENV_FILE)))
include $(ENV_FILE)
export
endif

DATA_PATH		?= /home/$(LOGIN)/data

.PHONY: all up build down stop start restart logs ps clean fclean re prepare check-secrets init-secrets

all: up

up: check-secrets prepare
	$(COMPOSE) up --build -d

build: check-secrets prepare
	$(COMPOSE) build

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down --remove-orphans

fclean:
	$(COMPOSE) down -v --remove-orphans
	rm -rf "$(DATA_PATH)"

re: fclean up

prepare:
	mkdir -p "$(DATA_PATH)/mariadb" "$(DATA_PATH)/wordpress"

check-secrets:
	@missing=0; \
	for file in $(SECRETS); do \
		if [ ! -f "$$file" ]; then \
			echo "Missing $$file"; \
			missing=1; \
		fi; \
	done; \
	if [ "$$missing" -ne 0 ]; then \
		echo "Create the missing files or run 'make init-secrets', then replace the placeholder values."; \
		exit 1; \
	fi

init-secrets:
	mkdir -p secrets
	[ -f secrets/db_root_password.txt ] || printf "replace_db_root_password\n" > secrets/db_root_password.txt
	[ -f secrets/db_password.txt ] || printf "replace_db_password\n" > secrets/db_password.txt
	[ -f secrets/wp_admin_password.txt ] || printf "replace_wp_admin_password\n" > secrets/wp_admin_password.txt
	[ -f secrets/wp_user_password.txt ] || printf "replace_wp_user_password\n" > secrets/wp_user_password.txt
	chmod 600 $(SECRETS)
	@echo "Secrets created in ./secrets. Edit every file before running make."
