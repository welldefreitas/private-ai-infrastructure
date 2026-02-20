# 🛡️ Threat Model & Security Architecture

## 📌 Scope
This document outlines the security controls implemented to protect the Private LLM endpoint (`private_llm_engine`) operating behind the Nginx reverse proxy. The primary goal is to ensure absolute data privacy, mitigate exfiltration risks, and prevent unauthorized access.

## 📦 Assets Protected
- **User Prompts:** Sensitive text inputs sent to the AI.
- **Model Responses:** Proprietary or confidential generated outputs.
- **Model Weights:** The localized `.bin`/`.gguf` files stored in the volume.
- **Infrastructure:** The host machine running the Docker daemon.

---

## 🛑 Threats & Mitigations

### 1. Data Exfiltration via Prompt Injection
- **Threat:** Malicious prompts instructing the LLM to send HTTP requests to external attacker-controlled servers.
- **Mitigation:** The `ai_secure_net` Docker network is configured with `internal: true`. The container is physically isolated and **cannot** route traffic to the public internet.

### 2. Unauthorized Endpoint Access
- **Threat:** Unauthenticated users scanning or querying the LLM endpoint.
- **Mitigation:** Nginx acts as the sole entry point (Ports 80/443). The API is restricted to the `/api/` path. (Basic Auth can be easily toggled in `nginx.conf`).

### 3. DoS / Brute Force Attacks
- **Threat:** High-volume requests aimed at exhausting GPU VRAM or CPU resources.
- **Mitigation:** Nginx implements `limit_req_zone` (5 requests/second burstable to 10) to drop abusive traffic before it reaches the Ollama engine.

### 4. Privacy Breach via Logging
- **Threat:** Sensitive user prompts being saved in plaintext within proxy access logs.
- **Mitigation:** `access_log off;` is explicitly set in Nginx. The LLM processes prompts ephemerally in memory.

### 5. Transport Layer Interception (MITM)
- **Threat:** Packet sniffing capturing prompts in transit over the local network.
- **Mitigation:** Nginx enforces HTTPS (TLS 1.2/1.3) and automatically redirects port 80 traffic to 443.

### 6. Container Breakout
- **Threat:** Attacker exploiting a vulnerability in the Ollama runtime to access the host.
- **Mitigation:** Volumes are mapped using specific restricted paths. (Future roadmap: implement `read_only: true` and drop Linux capabilities).
