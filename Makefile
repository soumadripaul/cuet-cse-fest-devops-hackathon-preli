# ============================================
# E-commerce Microservices - Makefile
# ============================================
# Docker Services:
#   up - Start services (use: make up [service...] or make up MODE=prod, ARGS="--build" for options)
#   down - Stop services (use: make down [service...] or make down MODE=prod, ARGS="--volumes" for options)
#   build - Build containers (use: make build [service...] or make build MODE=prod)
#   logs - View logs (use: make logs [service] or make logs SERVICE=backend, MODE=prod for production)
#   restart - Restart services (use: make restart [service...] or make restart MODE=prod)
#   shell - Open shell in container (use: make shell [service] or make shell SERVICE=gateway, MODE=prod, default: backend)
#   ps - Show running containers (use MODE=prod for production)
#
# Convenience Aliases (Development):
#   dev-up - Alias: Start development environment
#   dev-down - Alias: Stop development environment
#   dev-build - Alias: Build development containers
#   dev-logs - Alias: View development logs
#   dev-restart - Alias: Restart development services
#   dev-shell - Alias: Open shell in backend container
#   dev-ps - Alias: Show running development containers
#   backend-shell - Alias: Open shell in backend container
#   gateway-shell - Alias: Open shell in gateway container
#   mongo-shell - Open MongoDB shell
#
# Convenience Aliases (Production):
#   prod-up - Alias: Start production environment
#   prod-down - Alias: Stop production environment
#   prod-build - Alias: Build production containers
#   prod-logs - Alias: View production logs
#   prod-restart - Alias: Restart production services
#
# Backend:
#   backend-build - Build backend TypeScript
#   backend-install - Install backend dependencies
#   backend-type-check - Type check backend code
#   backend-dev - Run backend in development mode (local, not Docker)
#
# Database:
#   db-reset - Reset MongoDB database (WARNING: deletes all data)
#   db-backup - Backup MongoDB database
#
# Cleanup:
#   clean - Remove containers and networks (both dev and prod)
#   clean-all - Remove containers, networks, volumes, and images
#   clean-volumes - Remove all volumes
#
# Utilities:
#   status - Alias for ps
#   health - Check service health
#
# Help:
#   help - Display this help message

# ============================================
# Variables
# ============================================
.DEFAULT_GOAL := help
MODE ?= dev
SERVICE ?= backend
ARGS ?=
COMPOSE_FILE_DEV = docker/compose.development.yaml
COMPOSE_FILE_PROD = docker/compose.production.yaml
COMPOSE_FILE = $(if $(filter prod,$(MODE)),$(COMPOSE_FILE_PROD),$(COMPOSE_FILE_DEV))
DOCKER_COMPOSE = docker compose -f $(COMPOSE_FILE) --env-file .env
ENV_FILE = .env

# Colors for output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# ============================================
# Help
# ============================================
.PHONY: help
help:
	@echo "$(CYAN)════════════════════════════════════════════════════════════════$(NC)"
	@echo "$(CYAN)  E-commerce Microservices - Makefile Commands$(NC)"
	@echo "$(CYAN)════════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(GREEN)Quick Start:$(NC)"
	@echo "  make setup              - Initial setup (create .env from .env.example)"
	@echo "  make dev-up             - Start development environment"
	@echo "  make prod-up            - Start production environment"
	@echo ""
	@echo "$(GREEN)Docker Services:$(NC)"
	@echo "  make up [MODE=dev|prod] [ARGS=\"--build\"]  - Start services"
	@echo "  make down [MODE=dev|prod]                  - Stop services"
	@echo "  make build [MODE=dev|prod]                 - Build containers"
	@echo "  make logs [SERVICE=name] [MODE=dev|prod]   - View logs"
	@echo "  make restart [MODE=dev|prod]               - Restart services"
	@echo "  make shell [SERVICE=name] [MODE=dev|prod]  - Open shell"
	@echo "  make ps [MODE=dev|prod]                    - Show containers"
	@echo ""
	@echo "$(GREEN)Development Aliases:$(NC)"
	@echo "  make dev-up             - Start dev environment"
	@echo "  make dev-down           - Stop dev environment"
	@echo "  make dev-build          - Build dev containers"
	@echo "  make dev-logs           - View dev logs"
	@echo "  make dev-restart        - Restart dev services"
	@echo "  make backend-shell      - Shell into backend"
	@echo "  make gateway-shell      - Shell into gateway"
	@echo "  make mongo-shell        - MongoDB shell"
	@echo ""
	@echo "$(GREEN)Production Aliases:$(NC)"
	@echo "  make prod-up            - Start prod environment"
	@echo "  make prod-down          - Stop prod environment"
	@echo "  make prod-build         - Build prod containers"
	@echo "  make prod-logs          - View prod logs"
	@echo ""
	@echo "$(GREEN)Backend Operations:$(NC)"
	@echo "  make backend-build      - Build TypeScript"
	@echo "  make backend-install    - Install dependencies"
	@echo "  make backend-type-check - Type check code"
	@echo ""
	@echo "$(GREEN)Database Operations:$(NC)"
	@echo "  make db-reset           - Reset database (⚠️  deletes all data)"
	@echo "  make db-backup          - Backup database"
	@echo ""
	@echo "$(GREEN)Cleanup:$(NC)"
	@echo "  make clean              - Remove containers & networks"
	@echo "  make clean-all          - Remove everything (⚠️  including volumes)"
	@echo "  make clean-volumes      - Remove all volumes"
	@echo ""
	@echo "$(GREEN)Utilities:$(NC)"
	@echo "  make health             - Check service health"
	@echo "  make status             - Show container status"
	@echo "  make test-api           - Test API endpoints"
	@echo ""
	@echo "$(CYAN)════════════════════════════════════════════════════════════════$(NC)"

# ============================================
# Setup
# ============================================
.PHONY: setup
setup:
	@echo "$(CYAN)Setting up environment...$(NC)"
	@if [ ! -f $(ENV_FILE) ]; then \
		cp .env.example $(ENV_FILE); \
		echo "$(GREEN)✓ Created .env file from .env.example$(NC)"; \
		echo "$(YELLOW)⚠  Please edit .env and set your credentials$(NC)"; \
	else \
		echo "$(YELLOW)⚠  .env file already exists$(NC)"; \
	fi

# ============================================
# Docker Compose Commands
# ============================================
.PHONY: up
up:
	@echo "$(CYAN)Starting $(MODE) environment...$(NC)"
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED)✗ .env file not found. Run 'make setup' first$(NC)"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) up -d $(ARGS)
	@echo "$(GREEN)✓ Services started in $(MODE) mode$(NC)"
	@echo "$(CYAN)Run 'make logs' to view logs$(NC)"

.PHONY: down
down:
	@echo "$(CYAN)Stopping $(MODE) environment...$(NC)"
	$(DOCKER_COMPOSE) down $(ARGS)
	@echo "$(GREEN)✓ Services stopped$(NC)"

.PHONY: build
build:
	@echo "$(CYAN)Building $(MODE) containers...$(NC)"
	$(DOCKER_COMPOSE) build --no-cache $(ARGS)
	@echo "$(GREEN)✓ Build complete$(NC)"

.PHONY: logs
logs:
	@echo "$(CYAN)Viewing logs for $(SERVICE) in $(MODE) mode...$(NC)"
	$(DOCKER_COMPOSE) logs -f $(SERVICE)

.PHONY: restart
restart:
	@echo "$(CYAN)Restarting $(MODE) services...$(NC)"
	$(DOCKER_COMPOSE) restart
	@echo "$(GREEN)✓ Services restarted$(NC)"

.PHONY: shell
shell:
	@echo "$(CYAN)Opening shell in $(SERVICE) container...$(NC)"
	$(DOCKER_COMPOSE) exec $(SERVICE) sh

.PHONY: ps
ps:
	@echo "$(CYAN)Running containers ($(MODE) mode):$(NC)"
	$(DOCKER_COMPOSE) ps

.PHONY: status
status: ps

# ============================================
# Development Aliases
# ============================================
.PHONY: dev-up
dev-up:
	@$(MAKE) up MODE=dev ARGS="--build"

.PHONY: dev-down
dev-down:
	@$(MAKE) down MODE=dev

.PHONY: dev-build
dev-build:
	@$(MAKE) build MODE=dev

.PHONY: dev-logs
dev-logs:
	@$(MAKE) logs MODE=dev SERVICE=""

.PHONY: dev-restart
dev-restart:
	@$(MAKE) restart MODE=dev

.PHONY: dev-shell
dev-shell:
	@$(MAKE) shell MODE=dev SERVICE=backend

.PHONY: dev-ps
dev-ps:
	@$(MAKE) ps MODE=dev

.PHONY: backend-shell
backend-shell:
	@$(MAKE) shell MODE=dev SERVICE=backend

.PHONY: gateway-shell
gateway-shell:
	@$(MAKE) shell MODE=dev SERVICE=gateway

.PHONY: mongo-shell
mongo-shell:
	@echo "$(CYAN)Opening MongoDB shell...$(NC)"
	@docker compose -f $(COMPOSE_FILE_DEV) --env-file .env exec mongodb mongosh -u $${MONGO_INITDB_ROOT_USERNAME} -p $${MONGO_INITDB_ROOT_PASSWORD} --authenticationDatabase admin


# Production Aliases

.PHONY: prod-up
prod-up:
	@$(MAKE) up MODE=prod ARGS="--build"

.PHONY: prod-down
prod-down:
	@$(MAKE) down MODE=prod

.PHONY: prod-build
prod-build:
	@$(MAKE) build MODE=prod

.PHONY: prod-logs
prod-logs:
	@$(MAKE) logs MODE=prod SERVICE=""

.PHONY: prod-restart
prod-restart:
	@$(MAKE) restart MODE=prod

.PHONY: prod-shell
prod-shell:
	@$(MAKE) shell MODE=prod SERVICE=backend

.PHONY: prod-ps
prod-ps:
	@$(MAKE) ps MODE=prod


# Backend Operations

.PHONY: backend-build
backend-build:
	@echo "$(CYAN)Building backend TypeScript...$(NC)"
	cd backend && npm run build
	@echo "$(GREEN)✓ Backend built successfully$(NC)"

.PHONY: backend-install
backend-install:
	@echo "$(CYAN)Installing backend dependencies...$(NC)"
	cd backend && npm install
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

.PHONY: backend-type-check
backend-type-check:
	@echo "$(CYAN)Type checking backend code...$(NC)"
	cd backend && npm run type-check
	@echo "$(GREEN)✓ Type check passed$(NC)"

.PHONY: backend-dev
backend-dev:
	@echo "$(CYAN)Running backend in development mode (local)...$(NC)"
	cd backend && npm run dev


# Database Operations

.PHONY: db-reset
db-reset:
	@echo "$(RED)⚠️  WARNING: This will delete all database data!$(NC)"
	@read -p "Are you sure? (yes/no): " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo "$(CYAN)Resetting database...$(NC)"; \
		docker compose -f $(COMPOSE_FILE_DEV) --env-file .env down -v; \
		docker volume rm -f ecommerce-mongodb-data-dev ecommerce-mongodb-config-dev 2>/dev/null || true; \
		echo "$(GREEN)✓ Database reset complete$(NC)"; \
	else \
		echo "$(YELLOW)Database reset cancelled$(NC)"; \
	fi

.PHONY: db-backup
db-backup:
	@echo "$(CYAN)Backing up database...$(NC)"
	@mkdir -p backups
	@TIMESTAMP=$$(date +%Y%m%d_%H%M%S); \
	docker compose -f $(COMPOSE_FILE_DEV) --env-file .env exec -T mongodb mongodump \
		-u $${MONGO_INITDB_ROOT_USERNAME} -p $${MONGO_INITDB_ROOT_PASSWORD} \
		--authenticationDatabase admin --db $${MONGO_DATABASE} \
		--archive=/tmp/backup_$$TIMESTAMP.archive; \
	docker compose -f $(COMPOSE_FILE_DEV) --env-file .env exec -T mongodb cat /tmp/backup_$$TIMESTAMP.archive > backups/backup_$$TIMESTAMP.archive; \
	echo "$(GREEN)✓ Backup saved to backups/backup_$$TIMESTAMP.archive$(NC)"

.PHONY: db-restore
db-restore:
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)✗ Please specify FILE=path/to/backup.archive$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)Restoring database from $(FILE)...$(NC)"
	@cat $(FILE) | docker compose -f $(COMPOSE_FILE_DEV) --env-file .env exec -T mongodb \
		mongorestore -u $${MONGO_INITDB_ROOT_USERNAME} -p $${MONGO_INITDB_ROOT_PASSWORD} \
		--authenticationDatabase admin --archive --drop
	@echo "$(GREEN)✓ Database restored$(NC)"


# Cleanup

.PHONY: clean
clean:
	@echo "$(CYAN)Cleaning up containers and networks...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) --env-file .env down 2>/dev/null || true
	docker compose -f $(COMPOSE_FILE_PROD) --env-file .env down 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

.PHONY: clean-all
clean-all:
	@echo "$(RED)⚠️  WARNING: This will remove all containers, networks, volumes, and images!$(NC)"
	@read -p "Are you sure? (yes/no): " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo "$(CYAN)Cleaning everything...$(NC)"; \
		docker compose -f $(COMPOSE_FILE_DEV) --env-file .env down -v --rmi all 2>/dev/null || true; \
		docker compose -f $(COMPOSE_FILE_PROD) --env-file .env down -v --rmi all 2>/dev/null || true; \
		docker volume rm -f ecommerce-mongodb-data-dev ecommerce-mongodb-config-dev 2>/dev/null || true; \
		docker volume rm -f ecommerce-backend-node-modules-dev ecommerce-gateway-node-modules-dev 2>/dev/null || true; \
		docker volume rm -f ecommerce-mongodb-data-prod ecommerce-mongodb-config-prod 2>/dev/null || true; \
		docker network rm ecommerce-network-dev ecommerce-network-prod 2>/dev/null || true; \
		echo "$(GREEN)✓ Deep cleanup complete$(NC)"; \
	else \
		echo "$(YELLOW)Cleanup cancelled$(NC)"; \
	fi

.PHONY: clean-volumes
clean-volumes:
	@echo "$(RED)⚠️  WARNING: This will delete all persistent data!$(NC)"
	@read -p "Are you sure? (yes/no): " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo "$(CYAN)Removing volumes...$(NC)"; \
		docker volume rm -f ecommerce-mongodb-data-dev ecommerce-mongodb-config-dev 2>/dev/null || true; \
		docker volume rm -f ecommerce-backend-node-modules-dev ecommerce-gateway-node-modules-dev 2>/dev/null || true; \
		docker volume rm -f ecommerce-mongodb-data-prod ecommerce-mongodb-config-prod 2>/dev/null || true; \
		echo "$(GREEN)✓ Volumes removed$(NC)"; \
	else \
		echo "$(YELLOW)Volume removal cancelled$(NC)"; \
	fi


# Utilities

.PHONY: health
health:
	@echo "$(CYAN)Checking service health...$(NC)"
	@echo ""
	@echo "$(CYAN)Gateway Health:$(NC)"
	@curl -s http://localhost:5921/health | jq . || echo "$(RED)✗ Gateway unreachable$(NC)"
	@echo ""
	@echo "$(CYAN)Backend Health (via Gateway):$(NC)"
	@curl -s http://localhost:5921/api/health | jq . || echo "$(RED)✗ Backend unreachable$(NC)"
	@echo ""

.PHONY: test-api
test-api:
	@echo "$(CYAN)Testing API endpoints...$(NC)"
	@echo ""
	@echo "$(CYAN)1. Gateway health check:$(NC)"
	curl -s http://localhost:5921/health | jq .
	@echo ""
	@echo "$(CYAN)2. Backend health check (via gateway):$(NC)"
	curl -s http://localhost:5921/api/health | jq .
	@echo ""
	@echo "$(CYAN)3. Creating a test product:$(NC)"
	curl -s -X POST http://localhost:5921/api/products \
		-H 'Content-Type: application/json' \
		-d '{"name":"Test Product","price":99.99}' | jq .
	@echo ""
	@echo "$(CYAN)4. Getting all products:$(NC)"
	curl -s http://localhost:5921/api/products | jq .
	@echo ""
	@echo "$(CYAN)5. Testing direct backend access (should fail):$(NC)"
	@curl -s --connect-timeout 2 http://localhost:3847/api/products || echo "$(GREEN)✓ Backend correctly not accessible directly$(NC)"
	@echo ""
	@echo "$(GREEN)✓ API tests complete$(NC)"

.PHONY: docker-stats
docker-stats:
	@echo "$(CYAN)Docker resource usage:$(NC)"
	@docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" \
		$$(docker ps --filter "name=ecommerce-" --format "{{.Names}}")

.PHONY: docker-images
docker-images:
	@echo "$(CYAN)Docker images:$(NC)"
	@docker images | grep -E "(ecommerce|mongo)" || echo "No ecommerce images found"


