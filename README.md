# Full-Stack Monorepo Template Generator 🚀

A complete template generator that creates a professional full-stack monorepo with React, Astro, FastAPI, and comprehensive development tooling.

## 🎯 What it creates

- **React 18 + Vite** application (`/app`) with TypeScript
- **Astro 5** static site (`/www`) with TypeScript  
- **FastAPI** backend (`/api`) with Python 3.13 and uv
- **Shared UI components** (`/packages`) with Tailwind CSS
- **Professional development tooling** and workflows

## ✨ Features

- ⚛️ **React 18** with Vite and TypeScript
- 🚀 **Astro 5** for static sites and marketing
- 🔥 **FastAPI** with Python 3.13 and uv package manager
- 📦 **Shared components** library (@scope/ui)
- 🎨 **Tailwind CSS** with Radix colors
- 🔧 **Professional tooling** (ESLint, Black, flake8, Husky)
- 🧪 **Automated testing** (API endpoint discovery)
- 📱 **Mobile-first** responsive design
- ⚡ **Selective development** (start only needed services)

## 🚀 Quick Start

```bash
# Generate a complete full-stack monorepo
./generate-monorepo-v2.sh my-awesome-project my-scope

# Generated structure includes:
# - React 18 + Vite + TypeScript
# - Astro 5 + TypeScript  
# - FastAPI + Python 3.13
# - Shared UI components
# - Professional dev tooling
```

This creates a project structure like:

```
my-awesome-project/
├── app/                    # React application
├── www/                    # Astro static site  
├── api/                    # FastAPI backend
├── packages/               # Shared components
├── dev.sh                  # Development script
└── package.json           # Root configuration
```

## 🛠️ Generated Development Workflow

The generated monorepo includes a complete professional development setup:

### One-Command Development
```bash
cd my-awesome-project
npm install
cd api && uv venv && uv pip install -e ".[dev]" && cd ..
npm run dev  # Starts all services!
```

### Selective Development
```bash
./dev.sh app www    # Frontend only
./dev.sh api        # Backend only
./dev.sh app        # React only
```

### Quality Control
```bash
npm run lint:strict        # Frontend linting
npm run lint:python        # Backend linting  
npm run typecheck          # TypeScript checking
npm run test:api           # API endpoint testing
```

## 📦 Generated Services

- 🅰️ **React App**: http://localhost:5173
- 🚀 **Astro Site**: http://localhost:4321
- 🔥 **FastAPI**: http://localhost:8000
- 📖 **API Docs**: http://localhost:8000/docs

## 🔧 Included Tools

### Frontend
- **React 18** with TypeScript and Vite
- **Astro 5** with TypeScript
- **ESLint** with Airbnb configuration
- **Tailwind CSS** with Radix colors
- **Shared component library**

### Backend  
- **FastAPI** with async/await support
- **Python 3.13** with uv package manager
- **Black** code formatting
- **isort** import organization
- **flake8** linting
- **Structured logging** with JSON output
- **Auto-generated OpenAPI docs**

### Development
- **Husky** git hooks for quality control
- **lint-staged** for pre-commit formatting
- **Selective dev script** for flexible development
- **Automated API testing** with endpoint discovery
- **Professional project structure**

## 🚀 Usage

```bash
# Clone this repository
git clone https://github.com/carlaost/monorepo-template-generator.git
cd monorepo-template-generator

# Generate your monorepo
./generate-monorepo-v2.sh my-project my-scope

# Start developing
cd my-project
npm install
cd api && uv venv && uv pip install -e ".[dev]" && cd ..
npm run dev
```

## 📋 Generated Scripts

The generated monorepo includes these npm scripts:

| Script | Description |
|--------|-------------|
| `npm run dev` | Start all development servers |
| `./dev.sh [services]` | Start specific services |
| `npm run lint` | Lint frontend code |
| `npm run lint:python` | Lint Python code |
| `npm run test:api` | Test all API endpoints |
| `npm run typecheck` | TypeScript checking |

## 🎯 Perfect For

- **Full-stack applications** with React frontend and Python backend
- **Marketing sites** with Astro and shared components
- **Professional projects** requiring quality tooling
- **Team development** with consistent workflows
- **Rapid prototyping** with production-ready structure

## 📄 License

MIT License - feel free to use for your projects!

---

**Generate a complete professional monorepo in seconds!** 🚀