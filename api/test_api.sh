#!/bin/bash
# Convenience script to run API endpoint tests

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Running API Endpoint Tests...${NC}"

# Check if we're in the API directory
if [ ! -f "ping_endpoints.py" ]; then
    echo "❌ Please run this script from the api directory"
    exit 1
fi

# Check if virtual environment exists
if [ ! -f ".venv/bin/activate" ]; then
    echo "❌ Virtual environment not found. Please run: uv venv && uv pip install -e ."
    exit 1
fi

# Activate virtual environment and run tests
source .venv/bin/activate
python ping_endpoints.py

echo -e "${GREEN}✅ API tests completed!${NC}"
