SHELL := /bin/sh

DEV_COMPOSE := docker/dev/docker-compose.yml
STAGING_COMPOSE := docker/staging/docker-compose.yml
PROD_COMPOSE := docker/prod/docker-compose.yml

.PHONY: help dev dev-build dev-down staging staging-build staging-down prod prod-build prod-down

help:
	@echo "Available targets:"
	@echo "  make dev"
	@echo "  make dev-build"
	@echo "  make dev-down"
	@echo "  make staging"
	@echo "  make staging-build"
	@echo "  make staging-down"
	@echo "  make prod"
	@echo "  make prod-build"
	@echo "  make prod-down"

dev:
	docker compose -f $(DEV_COMPOSE) up

dev-build:
	docker compose -f $(DEV_COMPOSE) up --build

dev-down:
	docker compose -f $(DEV_COMPOSE) down

staging:
	docker compose -f $(STAGING_COMPOSE) up

staging-build:
	docker compose -f $(STAGING_COMPOSE) up --build

staging-down:
	docker compose -f $(STAGING_COMPOSE) down

prod:
	docker compose -f $(PROD_COMPOSE) up

prod-build:
	docker compose -f $(PROD_COMPOSE) up --build

prod-down:
	docker compose -f $(PROD_COMPOSE) down