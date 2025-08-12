#!/bin/bash

# Enhanced Monorepo Template Generator v2.0
# Creates a complete full-stack monorepo with React + Astro + FastAPI
# Usage: ./generate-monorepo-v2.sh [project-name] [scope]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
PROJECT_NAME=${1:-"my-monorepo"}
SCOPE=${2:-"my"}
TARGET_DIR="${PROJECT_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${PURPLE}🚀 Enhanced Monorepo Template Generator v2.0${NC}"
echo -e "${PURPLE}================================================${NC}"
echo ""
echo -e "📁 Project Name: ${GREEN}${PROJECT_NAME}${NC}"
echo -e "📦 Package Scope: ${GREEN}@${SCOPE}${NC}"
echo -e "📂 Target Directory: ${GREEN}${TARGET_DIR}${NC}"
echo ""

# Check if directory exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${RED}❌ Directory ${TARGET_DIR} already exists!${NC}"
    echo -e "${YELLOW}💡 Choose a different name or remove the existing directory${NC}"
    exit 1
fi

# Check if template files exist
if [ ! -d "$SCRIPT_DIR/app" ] || [ ! -d "$SCRIPT_DIR/www" ] || [ ! -d "$SCRIPT_DIR/api" ] || [ ! -d "$SCRIPT_DIR/packages" ]; then
    echo -e "${RED}❌ Template files not found!${NC}"
    echo -e "${YELLOW}💡 Make sure app/, www/, api/, and packages/ directories exist in the template${NC}"
    exit 1
fi

echo -e "${BLUE}📁 Creating project structure...${NC}"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Initialize git
echo -e "${BLUE}🔧 Initializing Git repository...${NC}"
git init

echo -e "${BLUE}📋 Copying template files...${NC}"

# Copy all the template directories
echo -e "  ${CYAN}📱 Copying React app...${NC}"
cp -r "$SCRIPT_DIR/app" ./

echo -e "  ${CYAN}🚀 Copying Astro site...${NC}"
cp -r "$SCRIPT_DIR/www" ./

echo -e "  ${CYAN}🔥 Copying FastAPI backend...${NC}"
cp -r "$SCRIPT_DIR/api" ./

echo -e "  ${CYAN}📦 Copying shared packages...${NC}"
cp -r "$SCRIPT_DIR/packages" ./

echo -e "  ${CYAN}🔧 Copying configuration files...${NC}"
cp "$SCRIPT_DIR/dev.sh" ./
cp "$SCRIPT_DIR/.eslintrc.cjs" ./
cp -r "$SCRIPT_DIR/.husky" ./

# Copy and customize package.json
echo -e "${BLUE}📝 Setting up package.json...${NC}"
cat > package.json << EOF
{
  "name": "${PROJECT_NAME}",
  "private": true,
  "workspaces": [
    "app",
    "www",
    "packages/*"
  ],
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  },
  "packageManager": "npm@10.2.4",
  "keywords": [
    "monorepo",
    "react",
    "astro",
    "fastapi",
    "typescript",
    "tailwind"
  ],
  "scripts": {
    "dev": "./dev.sh",
    "start": "./dev.sh",
    "lint": "eslint \\"{app,www}/**/*.{js,jsx,ts,tsx,astro}\\"",
    "lint:fix": "npm run lint -- --fix",
    "lint:strict": "npm run lint -- --max-warnings 0",
    "lint:python": "cd api && source \\$HOME/.local/bin/env && source .venv/bin/activate && uv run black --check . && uv run isort --check-only . && uv run flake8 .",
    "lint:python:fix": "cd api && source \\$HOME/.local/bin/env && source .venv/bin/activate && uv run black . && uv run isort .",
    "typecheck": "npm run -w app typecheck && npm run -w www typecheck",
    "typecheck:python": "cd api && source \\$HOME/.local/bin/env && source .venv/bin/activate && uv run mypy .",
    "test:api": "cd api && ./test_api.sh",
    "prepare": "husky"
  },
  "lint-staged": {
    "**/*.{js,jsx,ts,tsx,astro}": [
      "eslint --fix"
    ],
    "api/**/*.py": [
      "cd api && source \\$HOME/.local/bin/env && source .venv/bin/activate && uv run black",
      "cd api && source \\$HOME/.local/bin/env && source .venv/bin/activate && uv run isort"
    ]
  },
  "dependencies": {
    "@radix-ui/colors": "^3.0.0"
  },
  "devDependencies": {},
  "overrides": {}
}
EOF

# Update package scopes in the shared components
echo -e "${BLUE}🔄 Updating package scopes...${NC}"

# Update packages/components/package.json
if [ -f "packages/components/package.json" ]; then
    sed -i.bak "s/@oshi\/ui/@${SCOPE}\/ui/g" packages/components/package.json
    rm packages/components/package.json.bak
fi

# Update app/package.json dependencies
if [ -f "app/package.json" ]; then
    sed -i.bak "s/@oshi\/ui/@${SCOPE}\/ui/g" app/package.json
    rm app/package.json.bak
fi

# Update www/package.json dependencies  
if [ -f "www/package.json" ]; then
    sed -i.bak "s/@oshi\/ui/@${SCOPE}\/ui/g" www/package.json
    rm www/package.json.bak
fi

# Update import statements in app
echo -e "${BLUE}📝 Updating import statements...${NC}"
find app/src -name "*.tsx" -o -name "*.ts" | xargs sed -i.bak "s/@oshi\/ui/@${SCOPE}\/ui/g" || true
find app/src -name "*.bak" -delete || true

# Update import statements in www
find www/src -name "*.astro" -o -name "*.ts" | xargs sed -i.bak "s/@oshi\/ui/@${SCOPE}\/ui/g" || true
find www/src -name "*.bak" -delete || true

# Create README.md
echo -e "${BLUE}📖 Creating README.md...${NC}"
cat > README.md << EOF
# ${PROJECT_NAME}

A modern full-stack monorepo with React, Astro, and FastAPI.

## 🏗️ Repository Structure

\`\`\`
${PROJECT_NAME}/
├── app/                    # React + Vite web application
├── www/                    # Astro static site/marketing site
├── api/                    # FastAPI backend
├── packages/               # Shared packages and components
│   ├── components/         # Shared UI components (@${SCOPE}/ui)
│   ├── config/            # Shared configuration files
│   └── styles/            # Shared styling utilities
└── dev.sh                 # Development environment startup script
\`\`\`

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- npm 9+
- Python 3.11+ (for API)
- uv (Python package manager)

### Installation

\`\`\`bash
# Install frontend dependencies
npm install

# Set up FastAPI backend
cd api
uv venv
uv pip install -e ".[dev]"
cd ..
\`\`\`

### Development

\`\`\`bash
# Start all services
npm run dev

# Start specific services
./dev.sh app www          # Frontend only
./dev.sh api              # Backend only
./dev.sh app              # React only
\`\`\`

This will start:
- 🅰️ **React App** on http://localhost:5173
- 🚀 **Astro Site** on http://localhost:4321
- 🔥 **FastAPI Backend** on http://localhost:8000

## 🔧 Development Tools

\`\`\`bash
# Frontend linting
npm run lint
npm run lint:fix
npm run typecheck

# Backend linting
npm run lint:python
npm run lint:python:fix
npm run typecheck:python

# API testing
npm run test:api
\`\`\`

## 📋 Features

- ✅ **React 18 + TypeScript** - Modern frontend framework
- ✅ **Astro 5** - Fast static site generation
- ✅ **FastAPI + Python** - High-performance async backend
- ✅ **Shared UI Library** - Consistent components across apps
- ✅ **Tailwind CSS** - Utility-first styling
- ✅ **ESLint + Prettier** - Code quality for frontend
- ✅ **Black + flake8** - Python code formatting and linting
- ✅ **Husky Hooks** - Pre-commit and pre-push validation
- ✅ **Selective Development** - Start only the services you need
- ✅ **API Testing** - Automated endpoint discovery and testing
- ✅ **Structured Logging** - JSON logging with context

Generated with [Enhanced Monorepo Template Generator v2.0](https://github.com/carlaostmann/monorepo-template-generator)
EOF

# Create .gitignore
echo -e "${BLUE}📝 Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
/.pnp
.pnp.js

# Testing
/coverage

# Production builds
/build
dist/
.output/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
logs/
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# FastAPI
*.db
*.sqlite3

# MyPy
.mypy_cache/
.dmypy.json
dmypy.json

# API test results
api_test_results_*.json
EOF

# Make dev.sh executable
chmod +x dev.sh

echo ""
echo -e "${GREEN}✅ Monorepo template generated successfully!${NC}"
echo ""
echo -e "${PURPLE}🎯 Next steps:${NC}"
echo -e "  ${CYAN}1.${NC} cd ${PROJECT_NAME}"
echo -e "  ${CYAN}2.${NC} npm install                    ${YELLOW}# Install frontend dependencies${NC}"
echo -e "  ${CYAN}3.${NC} cd api && uv venv && uv pip install -e \".[dev]\" && cd ..  ${YELLOW}# Setup Python backend${NC}"
echo -e "  ${CYAN}4.${NC} npm run dev                    ${YELLOW}# Start all development servers${NC}"
echo ""
echo -e "${PURPLE}🌟 Available services:${NC}"
echo -e "  ${GREEN}•${NC} React App:     http://localhost:5173"
echo -e "  ${GREEN}•${NC} Astro Site:    http://localhost:4321"  
echo -e "  ${GREEN}•${NC} FastAPI:       http://localhost:8000"
echo -e "  ${GREEN}•${NC} API Docs:      http://localhost:8000/docs"
echo ""
echo -e "${PURPLE}🚀 Happy coding!${NC}"
