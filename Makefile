SHELL := /bin/bash

.PHONY: help up down logs status certs pull-models lint scan trivy ci-smoke

help:
	@echo "Targets:"
	@echo "  up               - Start stack (Docker Compose)"
	@echo "  down             - Stop stack and remove volumes"
	@echo "  logs             - Follow logs"
	@echo "  status           - Show containers"
	@echo "  certs            - Generate local TLS certs (dev/test)"
	@echo "  pull-models      - Download LLM weights into the Docker volume"
	@echo "  ci-smoke         - Validate CI compose config"
	@echo "  lint             - Run local lint checks (yamllint + shellcheck)"
	@echo "  trivy            - Run security scan (Trivy container)"
	@echo "  scan             - Alias for trivy"

up:
	docker compose up -d

down:
	docker compose down -v

logs:
	docker compose logs -f --tail=200

status:
	docker compose ps

certs:
	bash scripts/generate-certs.sh

pull-models:
	bash scripts/pull-models.sh

ci-smoke:
	docker compose -f docker-compose.ci.yml config -q

lint:
	yamllint -d "{extends: relaxed, rules: {line-length: {max: 140}}}" .
	shellcheck scripts/*.sh

trivy:
	docker run --rm -v "$$PWD:/repo" aquasec/trivy:latest fs \
	  --security-checks vuln,config,secret \
	  --severity HIGH,CRITICAL \
	  --exit-code 1 \
	  /repo

scan: trivy
