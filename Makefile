# Enterprise Private AI - Management Commands

.PHONY: up down logs pull-models test-api

up:
	@echo "[*] Starting Secure AI Infrastructure..."
	docker-compose up -d --build

down:
	@echo "[*] Shutting down and cleaning up..."
	docker-compose down

logs:
	docker-compose logs -f nginx

pull-models:
	@echo "[*] Pulling default models securely..."
	bash scripts/pull-models.sh

test-api:
	@echo "[*] Testing Private Endpoint..."
	curl -X POST http://localhost/api/generate -d '{"model": "mistral", "prompt": "Status check", "stream": false}'
