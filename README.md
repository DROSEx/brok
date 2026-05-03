# BROK — DROSEx Offline AI

> 

**Built by Daniel Paola (DROSEx)** — Melbourne-based AI engineer and cybersecurity architect.

## What is Brok?

Brok is a fully offline, locally-hosted AI assistant running on an Oppo A38 Android phone via Termux and Ollama. No cloud. No API costs. No data leaving the device.

Built as part of the **Colosseum Project** — a production-grade AI + cybersecurity portfolio built entirely on a mobile device.

## Stack

- **Runtime:** Ollama (llama3.2:1b base)
- **Interface:** Single-file HTML served via Python http.server
- **Environment:** Termux / Android 15 / ARM64
- **Personality:** Custom system prompt fusing Claude, Perplexity and DeepSeek traits

## Features

- Custom Brok persona with anti-hallucination rules
- Cyberpunk web UI with boot sequence animation
- OpenAI-compatible API via Ollama localhost
- Rolling 20-message context window
- Quick action buttons for common queries
- Zero cloud dependency — fully air-gappable

## Quick Start

```bash
# Start Ollama
ollama serve &

# Serve UI
cd ~ && python -m http.server 8080 &

# Open in browser
# http://127.0.0.1:8080/brok.html

[200~ls -la ~/projects/brok/~
exit
cd~
pwd
ls
