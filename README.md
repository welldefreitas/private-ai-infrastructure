<h1 align="center">🛡️ Enterprise Private AI Infrastructure</h1>

<p align="center">
  <img src="[https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)" alt="Docker">
  <img src="[https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)" alt="Linux">
  <img src="[https://img.shields.io/badge/NVIDIA-CUDA-76B900?style=for-the-badge&logo=nvidia&logoColor=white](https://img.shields.io/badge/NVIDIA-CUDA-76B900?style=for-the-badge&logo=nvidia&logoColor=white)" alt="Nvidia">
  <img src="[https://img.shields.io/badge/Security-Zero_Trust-red?style=for-the-badge](https://img.shields.io/badge/Security-Zero_Trust-red?style=for-the-badge)" alt="Security">
</p>

> **Secure, Air-gapped, and GPU-Accelerated Private LLM deployment using Docker and Linux.**

This repository provides a production-ready architecture for deploying Large Language Models (LLMs) locally. It eliminates the reliance on external APIs (such as OpenAI or Anthropic), ensuring absolute data sovereignty for enterprise environments.

Designed for organizations requiring strict adherence to **GDPR, LGPD, and HIPAA** compliance.

---

## 🏗️ Architecture & Traffic Flow

The infrastructure is built on a containerized, zero-trust model. Traffic is securely routed through a reverse proxy, and the AI engine remains completely isolated from the public internet.

```mermaid
graph TD
    A[Client / Internal App] -->|HTTPS / Port 443| B(Nginx Reverse Proxy)
    B -->|Rate Limited & Basic Auth| C{Docker Internal Network}
    C -->|Port 11434| D[LLM Engine: Ollama / vLLM]
    D -->|GPU Inference| E[(Local Weights: Llama 3 / Mistral)]
    
    classDef proxy fill:#2d3436,stroke:#00b894,stroke-width:2px,color:#fff;
    classDef secure fill:#2d3436,stroke:#d63031,stroke-width:2px,color:#fff;
    class B proxy
    class C,D,E secure
```
---
## 🛑 Core Security Principles

- **Zero External API Calls:** 100% of the inference runs locally on the host server.
- **No Data Retention:** Ephemeral prompt processing. Context is destroyed after the session.
- **Complete Isolation:** The inference container has no outbound internet access.
- **Edge Security:** Nginx acts as the gatekeeper, handling SSL/TLS termination and DDoS mitigation.

---

## 💻 Hardware Requirements

To achieve real-time inference latency, the following baseline is recommended:
- **OS:** Ubuntu 22.04 LTS / Debian 12
- **GPU:** NVIDIA RTX 3090 / 4090 or Enterprise A10G/A100 (Minimum 8GB vRAM for 7B parameters).
- **Dependencies:** `docker`, `docker-compose`, and `nvidia-container-toolkit`.

---
📂 Project Structure
```
 private-ai-infrastructure/
├── docker-compose.yml       # Infrastructure orchestration
├── nginx/
│   ├── nginx.conf           # Proxy, Rate Limits, and Security Headers
│   └── certs/               # SSL Certificates (Volume)
├── scripts/
│   └── pull-models.sh       # Automated script to download weights safely
└── README.md
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

⚡ API Usage & Testing
Once deployed, the infrastructure acts as a drop-in replacement for OpenAI's API. You can test the local inference engine using curl:
```
curl -X POST https://your-secure-server.com/api/generate -d '{
  "model": "mistral",
  "prompt": "Explain the importance of zero-trust architecture in 3 bullet points.",
  "stream": false
}'
```
---

<p align="center">
<b>Author:</b> <a href="https://github.com/welldefreitas">Wellington de Freitas</a> | <i>AI Security Specialist & Cloud Architect</i>
</p>
