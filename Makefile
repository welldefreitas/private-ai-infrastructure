# Enterprise Private AI - Management Commands

.PHONY: certs up down logs pull-models test-api test-nginx lint

certs:
	@bash scripts/generate-certs.sh

up: certs
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

test-nginx:
	@echo "[*] Validating Nginx configuration..."
	docker-compose exec nginx nginx -t

test-api:
	@echo "[*] Testing Private HTTPS Endpoint..."
	curl -k -X POST https://localhost/api/generate -d '{"model": "mistral", "prompt": "Status check", "stream": false}'

lint:
	@echo "[*] Running local YamlLint and ShellCheck..."
	docker run --rm -v $(PWD):/data cytopia/yamllint .
	shellcheck scripts/*.sh
