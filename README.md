<div align="center">

# 🛡️ Enterprise Private AI Infrastructure
### Secure, hardened, and GPU-accelerated **on-prem LLM** deployment with Docker + Nginx (TLS)

[![Enterprise CI/CD Pipeline](https://github.com/welldefreitas/private-ai-infrastructure/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/welldefreitas/private-ai-infrastructure/actions/workflows/ci.yml)
![Docker](https://img.shields.io/badge/Docker-ready-0db7ed?style=flat&logo=docker&logoColor=white)
![Security](https://img.shields.io/badge/Security-hardened-22c55e?style=flat)
![LLM](https://img.shields.io/badge/LLM-Ollama-111827?style=flat)
![Linux](https://img.shields.io/badge/Linux-production-111827?style=flat&logo=linux&logoColor=white)

**Goal:** run an enterprise-grade LLM **locally** (no public APIs) behind a **secure reverse proxy** with TLS, rate limiting, and CI security gates.

</div>

---

## ✅ What this repository delivers

- **Private LLM Engine (Ollama)** running inside an isolated Docker network (not exposed to the host)
- **Secure Nginx reverse proxy** with:
  - TLS (certs mounted via volume)
  - Rate limiting (basic anti-abuse / anti-DDoS)
  - Security headers
- **Automation scripts**:
  - Generate TLS certificates
  - Pull and store model weights locally (offline-ready)
- **Makefile** with “one-command” workflows
- **Security threat model** (`security.md`)
- **Enterprise CI**: yamllint + shellcheck + actionlint + trivy + compose smoke test

---

## 🧱 Architecture

> Rendered diagram:

<p align="center">
  <img src="diagrams/architecture.png" alt="Architecture" width="900" />
</p>

> Source diagram (Mermaid):
- `diagrams/architecture.mmd`

---

## 📦 Project structure

```text
private-ai-infrastructure/
├── .github/workflows/ci.yml          # CI: lint + security gates + compose smoke test
├── diagrams/                         # Architecture diagram (Mermaid + PNG export)
├── nginx/nginx.conf                  # Reverse proxy with TLS + rate limiting + headers
├── nginx/certs/                      # Certificates volume (placeholder tracked via .keep)
├── scripts/generate-certs.sh         # Local cert generation (dev/test)
├── scripts/pull-models.sh            # Pull weights into local volume (offline-ready)
├── docker-compose.yml                # Production-like compose
├── docker-compose.ci.yml             # CI-safe compose
├── .env.example                      # Environment template
├── Makefile                          # One-liners: up/down/logs/lint/scan/smoke
├── security.md                       # Threats + mitigations (security posture)
└── CHANGELOG.md                      # Release notes
```

---

🚀 Deployment Guide
1. Clone the repository and navigate to the directory:
```
git clone https://github.com/welldefreitas/private-ai-infrastructure.git
cd private-ai-infrastructure
```
2. Initialize the secure Docker environment:
```
docker-compose up -d --build
```
3. Pull the required model weights (e.g., Mistral 7B) into the secure volume:
```
docker exec -it private_llm_engine ollama run mistral
```
---

⚡ 3. API Usage (Drop-in replacement for OpenAI):
```
curl -X POST https://localhost/api/generate -d '{
  "model": "mistral",
  "prompt": "Explain zero-trust architecture.",
  "stream": false
}'
```
---

<p align="center">
<b>Author:</b> <a href="https://github.com/welldefreitas">Wellington de Freitas</a> | <i>AI Security Specialist & Cloud Architect</i>
</p>
