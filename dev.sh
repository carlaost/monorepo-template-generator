#!/bin/bash

# Oshima Development Environment Startup Script
# Starts development servers for the monorepo
# Usage: ./dev.sh [services...]
# Examples:
#   ./dev.sh              # Start all services
#   ./dev.sh app www       # Start only React and Astro
#   ./dev.sh api           # Start only FastAPI

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} ✅ $1"
}

print_error() {
    echo -e "${RED}[$(date +'%H:%M:%S')]${NC} ❌ $1"
}

print_warning() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')]${NC} ⚠️  $1"
}

# Function to check if port is available
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

# Function to wait for port to be ready
wait_for_port() {
    local port=$1
    local service=$2
    local max_attempts=60
    local attempt=1

    print_status "Waiting for ${service} on port ${port}..."
    
    while [ $attempt -le $max_attempts ]; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            print_success "${service} is ready on port ${port}"
            return 0
        fi
        
        sleep 1
        attempt=$((attempt + 1))
    done
    
    print_error "${service} failed to start on port ${port} after ${max_attempts} seconds"
    
    # Show last few lines of the relevant log file
    case ${service} in
        "React App")
            print_status "Last few lines of React log:"
            tail -5 logs/react.log 2>/dev/null || echo "No React log found"
            ;;
        "Astro Site")
            print_status "Last few lines of Astro log:"
            tail -5 logs/astro.log 2>/dev/null || echo "No Astro log found"
            ;;
        "FastAPI Backend")
            print_status "Last few lines of FastAPI log:"
            tail -5 logs/api.log 2>/dev/null || echo "No API log found"
            ;;
    esac
    
    return 1
}

# Function to cleanup background processes on exit
cleanup() {
    print_status "Shutting down development servers..."
    
    # Kill all background jobs
    jobs -p | xargs -r kill 2>/dev/null || true
    
    # Kill specific ports if they're still running
    pkill -f "vite.*5173" 2>/dev/null || true
    pkill -f "astro.*4321" 2>/dev/null || true
    pkill -f "uvicorn.*8000" 2>/dev/null || true
    

    
    print_success "Development servers stopped"
    exit 0
}

# Set up cleanup trap
trap cleanup SIGINT SIGTERM EXIT

# Parse command line arguments
REQUESTED_SERVICES=("$@")
if [ ${#REQUESTED_SERVICES[@]} -eq 0 ]; then
    REQUESTED_SERVICES=("app" "www" "api")
fi

# Validate requested services
VALID_SERVICES=("app" "www" "api")
for service in "${REQUESTED_SERVICES[@]}"; do
    if [[ ! " ${VALID_SERVICES[@]} " =~ " ${service} " ]]; then
        echo -e "${RED}❌ Invalid service: ${service}${NC}"
        echo -e "${YELLOW}Valid services: ${VALID_SERVICES[*]}${NC}"
        exit 1
    fi
done

# Main execution
clear
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════╗"
echo "║        🚀 Oshima Development         ║"
echo "║           Environment                ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

print_status "Starting services: ${REQUESTED_SERVICES[*]}"

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -d "app" ] || [ ! -d "www" ]; then
    print_error "Please run this script from the root of the Oshima repository"
    exit 1
fi

# Check for required tools
print_status "Checking prerequisites..."

if ! command -v npm &> /dev/null; then
    print_error "npm is required but not installed"
    exit 1
fi

if ! command -v node &> /dev/null; then
    print_error "Node.js is required but not installed"
    exit 1
fi

print_success "Prerequisites check passed"

# Check if dependencies are installed
if [ ! -d "node_modules" ] || [ ! -d "app/node_modules" ] || [ ! -d "www/node_modules" ]; then
    print_warning "Dependencies not found. Installing..."
    npm install
    print_success "Dependencies installed"
fi

# Check port availability for requested services
print_status "Checking port availability..."

REACT_PORT=5173
ASTRO_PORT=4321
API_PORT=8000

for service in "${REQUESTED_SERVICES[@]}"; do
    case $service in
        "app")
            if ! check_port $REACT_PORT; then
                print_error "Port ${REACT_PORT} is already in use (needed for React app)"
                print_status "Please stop the process using port ${REACT_PORT} and try again"
                exit 1
            fi
            ;;
        "www")
            if ! check_port $ASTRO_PORT; then
                print_error "Port ${ASTRO_PORT} is already in use (needed for Astro site)"
                print_status "Please stop the process using port ${ASTRO_PORT} and try again"
                exit 1
            fi
            ;;
        "api")
            if ! check_port $API_PORT; then
                print_error "Port ${API_PORT} is already in use (needed for FastAPI)"
                print_status "Please stop the process using port ${API_PORT} and try again"
                exit 1
            fi
            ;;
    esac
done

print_success "All requested ports are available"

# Create logs directory if it doesn't exist
mkdir -p logs

# Start development servers
print_status "Starting development servers..."

# Start requested services
PIDS=()
WAIT_PORTS=()

for service in "${REQUESTED_SERVICES[@]}"; do
    case $service in
        "app")
            print_status "Starting React app on port ${REACT_PORT}..."
            cd app
            npm run dev > ../logs/react.log 2>&1 &
            REACT_PID=$!
            PIDS+=($REACT_PID)
            WAIT_PORTS+=("$REACT_PORT:React App")
            cd ..
            ;;
        "www")
            print_status "Starting Astro site on port ${ASTRO_PORT}..."
            cd www
            npm run dev > ../logs/astro.log 2>&1 &
            ASTRO_PID=$!
            PIDS+=($ASTRO_PID)
            WAIT_PORTS+=("$ASTRO_PORT:Astro Site")
            cd ..
            ;;
        "api")
            print_status "Starting FastAPI backend on port ${API_PORT}..."
            cd api
            if [ -f .venv/bin/activate ]; then
                $HOME/.local/bin/uv run uvicorn app.main:app --reload --port ${API_PORT} > ../logs/api.log 2>&1 &
                API_PID=$!
                PIDS+=($API_PID)
                WAIT_PORTS+=("$API_PORT:FastAPI Backend")
            else
                print_error "FastAPI virtual environment not found. Please run: cd api && uv venv && uv pip install -e ."
                exit 1
            fi
            cd ..
            ;;
    esac
done

# Wait for services to be ready
for port_info in "${WAIT_PORTS[@]}"; do
    port=${port_info%%:*}
    service=${port_info#*:}
    wait_for_port $port "$service" &
done

# Wait for all background waits to complete
wait

# Display status
echo ""
echo -e "${GREEN}🎉 All requested development servers are running!${NC}"
echo ""
echo -e "${CYAN}📱 Running Applications:${NC}"

for service in "${REQUESTED_SERVICES[@]}"; do
    case $service in
        "app")
            echo -e "  • ${YELLOW}React App${NC}:    http://localhost:${REACT_PORT}"
            ;;
        "www")
            echo -e "  • ${YELLOW}Astro Site${NC}:   http://localhost:${ASTRO_PORT}"
            ;;
        "api")
            echo -e "  • ${YELLOW}FastAPI${NC}:      http://localhost:${API_PORT}/docs"
            ;;
    esac
done

echo ""
echo -e "${CYAN}📝 Active Logs:${NC}"
for service in "${REQUESTED_SERVICES[@]}"; do
    case $service in
        "app")
            echo -e "  • ${YELLOW}logs/react.log${NC}  React development server"
            ;;
        "www")
            echo -e "  • ${YELLOW}logs/astro.log${NC}  Astro development server"
            ;;
        "api")
            echo -e "  • ${YELLOW}logs/api.log${NC}    FastAPI server"
            ;;
    esac
done
echo ""
echo -e "${CYAN}🛠️  Development Commands:${NC}"
echo -e "  • ${YELLOW}npm run lint${NC}      Run ESLint on all packages"
echo -e "  • ${YELLOW}npm run typecheck${NC} Run TypeScript checks"
echo -e "  • ${YELLOW}npm run build${NC}     Build all applications"
echo ""
echo -e "${RED}Press Ctrl+C to stop all servers${NC}"
echo ""

# Keep script running and monitor processes
while true; do
    for pid in "${PIDS[@]}"; do
        if ! kill -0 $pid 2>/dev/null; then
            print_error "A development server stopped unexpectedly (PID: $pid)"
            break 2
        fi
    done
    
    sleep 5
done

# If we get here, something went wrong
print_error "One or more services stopped unexpectedly"
cleanup
