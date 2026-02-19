#!/bin/bash
# ------------------------------------------------------------------
# Automated script to securely download AI weights into the volume.
# Author: Wellington de Freitas
# ------------------------------------------------------------------

echo "[*] Connecting to Secure Private LLM Engine..."

# Define the models to be pulled
MODELS=("mistral" "llama3")

for MODEL in "${MODELS[@]}"; do
    echo "[+] Pulling model: $MODEL..."
    docker exec -it private_llm_engine ollama pull $MODEL
done

echo "[✓] All models downloaded successfully and secured in the local volume."
echo "[*] Ready for offline inference."
