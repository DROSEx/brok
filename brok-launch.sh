#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
#  BROK LAUNCHER — DROSEx Offline AI
#  Run this to start Brok's full stack
# ============================================================

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${RED}"
echo "  ██████╗ ██████╗  ██████╗ ██╗  ██╗"
echo "  ██╔══██╗██╔══██╗██╔═══██╗██║ ██╔╝"
echo "  ██████╔╝██████╔╝██║   ██║█████╔╝ "
echo "  ██╔══██╗██╔══██╗██║   ██║██╔═██╗ "
echo "  ██████╔╝██║  ██║╚██████╔╝██║  ██╗"
echo "  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${CYAN}  DROSEx Offline AI — Built by Daniel${NC}"
echo ""

# Check ollama is installed
if ! command -v ollama &> /dev/null; then
  echo -e "${RED}✗ Ollama not found.${NC}"
  echo "  Install via: pkg install tur-repo && pkg install ollama"
  exit 1
fi

# Check brok model exists
if ! ollama list | grep -q "brok"; then
  echo -e "${YELLOW}⚠ Brok model not found. Creating now...${NC}"
  
  cat > /tmp/brok.modelfile << 'MODELEOF'
FROM llama3.2:1b

SYSTEM """
You are BROK — Daniel's offline AI right-hand man. Built by Daniel (DROSEx), Melbourne-based AI engineer and cybersecurity architect.

You are a fusion of three AI philosophies made street-smart:
- CLAUDE traits: deep reasoning, step-by-step thinking, architectural, honest
- PERPLEXITY traits: factual, evidence-based, cite sources when known
- DEEPSEEK traits: precise code, production-grade, no fluff, debug aggressively

ANTI-HALLUCINATION RULES — NON-NEGOTIABLE:
1. NEVER invent commands, file paths, package names, or tool syntax
2. NEVER fabricate CVE numbers or security facts
3. If you don't know: say "I ain't got that locked down bro"
4. For code: only write what you can explain line by line
5. Only give Termux-compatible commands you are certain about
6. Never pretend to search the web — you are offline

HOW YOU TALK:
- Casual, direct, street-smart — use slang naturally
- Short answers first, expand if asked  
- Never say "As an AI"
- Sign off completed tasks with: ✊

DOMAINS: Cybersecurity, AI engineering, Termux, Python, Bash, career strategy
"""

PARAMETER temperature 0.7
PARAMETER top_p 0.9
PARAMETER num_ctx 2048
PARAMETER num_predict 512
PARAMETER repeat_penalty 1.1
MODELEOF

  ollama create brok -f /tmp/brok.modelfile
  echo -e "${GREEN}✓ Brok model created${NC}"
fi

# Start ollama server if not running
if ! curl -s http://127.0.0.1:11434 > /dev/null 2>&1; then
  echo -e "${CYAN}Starting Ollama server...${NC}"
  ollama serve > /tmp/ollama.log 2>&1 &
  OLLAMA_PID=$!
  sleep 3
  
  if curl -s http://127.0.0.1:11434 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Ollama server running (PID: $OLLAMA_PID)${NC}"
  else
    echo -e "${RED}✗ Server failed to start. Check /tmp/ollama.log${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}✓ Ollama server already running${NC}"
fi

# Serve the web UI
BROK_UI="$HOME/brok.html"
PORT=8080

if [ ! -f "$BROK_UI" ]; then
  echo -e "${YELLOW}⚠ brok.html not found at $BROK_UI${NC}"
  echo "  Copy brok.html to your home directory first"
else
  echo -e "${GREEN}✓ Brok UI found${NC}"
  echo ""
  echo -e "${CYAN}Starting web server on port $PORT...${NC}"
  
  # Use python to serve
  cd "$HOME"
  python -m http.server $PORT > /tmp/brok-web.log 2>&1 &
  WEB_PID=$!
  sleep 1
  
  echo ""
  echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║        BROK IS ONLINE ✊            ║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${CYAN}Web UI:${NC}     http://127.0.0.1:$PORT/brok.html"
  echo -e "  ${CYAN}Ollama:${NC}     http://127.0.0.1:11434"
  echo -e "  ${CYAN}Terminal:${NC}   ollama run brok"
  echo ""
  echo -e "  ${YELLOW}Open the Web UI URL in your phone browser${NC}"
  echo ""
  echo -e "  Press ${RED}Ctrl+C${NC} to stop all services"
  echo ""

  # Cleanup on exit
  trap "kill $WEB_PID 2>/dev/null; echo -e '${RED}Brok offline.${NC}'" EXIT
  
  # Keep running
  wait $WEB_PID
fi
