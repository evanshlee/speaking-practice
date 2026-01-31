#!/bin/bash

# Speaking Practice Aid - Start Script
# Runs Vite client and FastAPI backend simultaneously.

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Project directories
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLIENT_DIR="$PROJECT_DIR/client"
SERVER_DIR="$PROJECT_DIR/server"
VENV_DIR="$PROJECT_DIR/venv"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Speaking Practice Aid${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Cleanup all background processes on exit
cleanup() {
    echo ""
    echo -e "${RED}Shutting down servers...${NC}"
    kill $CLIENT_PID 2>/dev/null
    kill $SERVER_PID 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# Start backend server
echo -e "${GREEN}[1/2] Starting Backend Server (FastAPI)...${NC}"
cd "$SERVER_DIR"
source "$VENV_DIR/bin/activate"
python main.py &
SERVER_PID=$!
echo -e "      Backend PID: $SERVER_PID"
echo -e "      Backend URL: http://localhost:8000"
echo ""

# Start client server
echo -e "${GREEN}[2/2] Starting Client Server (Vite)...${NC}"
cd "$CLIENT_DIR"
npm run dev &
CLIENT_PID=$!
echo -e "      Client PID: $CLIENT_PID"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Both servers are running!${NC}"
echo -e "  Frontend: ${BLUE}http://localhost:5173${NC}"
echo -e "  Backend:  ${BLUE}http://localhost:8000${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Press ${RED}Ctrl+C${NC} to stop both servers."
echo ""

# Wait until processes terminate
wait
