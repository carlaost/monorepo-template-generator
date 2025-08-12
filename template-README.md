# Oshima

A modern monorepo containing multiple web applications and shared components for the Oshima ecosystem.

## 🏗️ Repository Structure

```
oshima/
├── app/                    # React + Vite web application
├── www/                    # Astro static site/marketing site
├── packages/               # Shared packages and components
│   ├── components/         # Shared UI components (@oshi/ui)
│   ├── config/            # Shared configuration files
│   └── styles/            # Shared styling utilities
├── api/                   # FastAPI backend
└── dev.sh                 # Development environment startup script
```

## 📦 Applications & Packages

### `/app` - React Application
- **Framework**: React 18 + TypeScript
- **Build Tool**: Vite
- **Styling**: Tailwind CSS
- **Purpose**: Main web application interface

### `/www` - Marketing Site
- **Framework**: Astro 5 + TypeScript
- **Styling**: Tailwind CSS
- **Purpose**: Static marketing site and documentation

### `/packages/components` - Shared UI Library
- **Package Name**: `@oshi/ui`
- **Framework**: React + TypeScript
- **Styling**: Tailwind CSS with Radix Colors
- **Purpose**: Shared components across applications

### `/packages/config` - Shared Configuration
- **Purpose**: Shared Tailwind presets and build configurations

### `/api` - FastAPI Backend
- **Framework**: FastAPI + Python 3.13
- **Package Manager**: uv (ultra-fast)
- **Features**: REST API, async endpoints, automatic docs, structured logging
- **Development**: http://localhost:8000
- **Documentation**: http://localhost:8000/docs (auto-generated)
- **Health Check**: http://localhost:8000/health
- **Testing**: Automated endpoint discovery and testing

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- npm 9+

### Installation

```bash
# Clone the repository
git clone https://github.com/oshima-sci/oshima.git
cd oshima

# Install dependencies for all workspaces
npm install

# Install dependencies for specific workspace
npm install --workspace=app
npm install --workspace=www
npm install --workspace=@oshi/ui
```

### Development

#### Quick Start (Recommended)
```bash
# Start all development servers with one command
npm run dev
# or
./dev.sh

# Start only specific services
./dev.sh app www          # React + Astro only
./dev.sh api              # FastAPI only  
./dev.sh app              # React only
```

This will start:
- 🅰️ **React App** on http://localhost:5173
- 🚀 **Astro Site** on http://localhost:4321
- 🔥 **FastAPI Backend** on http://localhost:8000
- 📝 **Logs** in `./logs/` directory
- 🔄 **Auto-restart** and monitoring

#### Manual Development
```bash
# Start all development servers manually
npm run dev --workspaces

# Start specific application
npm run dev --workspace=app      # React app on http://localhost:5173
npm run dev --workspace=www      # Astro site on http://localhost:4321

# Build all applications
npm run build --workspaces

# Build specific application
npm run build --workspace=app
npm run build --workspace=www
```

## 🔧 Development Tools

### Linting & Code Quality

```bash
# Frontend linting
npm run lint                # ESLint for JS/TS/Astro
npm run lint:fix            # Auto-fix issues
npm run lint:strict         # Fail on warnings
npm run typecheck           # TypeScript checking

# Backend linting  
npm run lint:python         # Black + isort + flake8
npm run lint:python:fix     # Auto-fix Python formatting
npm run typecheck:python    # MyPy type checking

# API testing
npm run test:api            # Test all API endpoints
```

### Pre-commit Hooks
- **Husky**: Automated pre-commit and pre-push hooks
- **lint-staged**: Runs ESLint + Python formatters on staged files
- **Pre-commit**: Auto-formats JS/TS and Python files
- **Pre-push**: Runs strict linting + type checking for all languages

## 📋 Scripts Reference

| Script | Description |
|--------|-------------|
| `npm run dev` | Start all development servers |
| `./dev.sh [services]` | Start specific services (app, www, api) |
| `npm run lint` | Run ESLint on all TypeScript/React/Astro files |
| `npm run lint:fix` | Run ESLint with auto-fix |
| `npm run lint:strict` | Run ESLint with zero warnings allowed |
| `npm run lint:python` | Lint Python code (black + isort + flake8) |
| `npm run lint:python:fix` | Auto-fix Python formatting |
| `npm run typecheck` | Run TypeScript compiler checks |
| `npm run typecheck:python` | Run Python static type checking |
| `npm run test:api` | Test all API endpoints automatically |

## 🏛️ Architecture Decisions

### Monorepo Structure
- **Workspaces**: Using npm workspaces for dependency management
- **Shared Components**: Centralized UI library (`@oshi/ui`) for consistency
- **Independent Apps**: Each app can be developed and deployed independently

### Code Quality
- **ESLint**: Airbnb configuration with TypeScript support
- **Different Rulesets**: React rules for `/app`, base rules + Astro for `/www`
- **Shared Standards**: Consistent linting across all packages

### Styling Strategy
- **Tailwind CSS**: Utility-first styling across all applications
- **Radix Colors**: Professional color system via `@radix-ui/colors`
- **Shared Presets**: Common Tailwind configuration in `/packages/config`

## 🛠️ Technology Stack

| Layer | Technologies |
|-------|-------------|
| **Frontend Frameworks** | React 18, Astro 5 |
| **Backend Framework** | FastAPI + Python 3.13 |
| **Build Tools** | Vite, Astro |
| **Languages** | TypeScript, JavaScript, Python |
| **Styling** | Tailwind CSS, Radix Colors |
| **Code Quality** | ESLint (Airbnb), Black, flake8, MyPy |
| **Package Management** | npm workspaces, uv (Python) |
| **Version Control** | Git with Husky hooks |
| **API Documentation** | Auto-generated OpenAPI/Swagger |

## 📁 Workspace Commands

### Working with Specific Packages

```bash
# Add dependency to specific workspace
npm install <package> --workspace=app
npm install <package> --workspace=www
npm install <package> --workspace=@oshi/ui

# Run scripts in specific workspace
npm run build --workspace=app
npm run dev --workspace=www

# Run command in all workspaces
npm run build --workspaces
npm run lint --workspaces
```

## 🔮 Roadmap

### Completed
- [x] **`/api` Directory**: FastAPI backend with full development workflow
- [x] **Automated API Testing**: Endpoint discovery and testing
- [x] **Python Linting**: Black, isort, flake8 integration
- [x] **Selective Dev Script**: Start only needed services

### Planned Additions
- [ ] **Database Integration**: Data persistence layer
- [ ] **Authentication**: User management system
- [ ] **CI/CD Pipeline**: Automated testing and deployment
- [ ] **Testing Suite**: Unit and integration tests
- [ ] **Storybook**: Component documentation and testing

### Future Considerations
- **Microservices**: Potential API service separation
- **Edge Functions**: Serverless API deployment
- **Documentation Site**: Enhanced docs in `/www`
- **Design System**: Expanded component library

## 🤝 Contributing

1. **Clone** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Follow** the existing code style (ESLint will help!)
4. **Test** your changes: `npm run lint:strict && npm run typecheck && npm run lint:python`
5. **Commit** with descriptive messages
6. **Push** and create a Pull Request

### Code Style Guidelines
- Use TypeScript for all new code
- Follow Airbnb ESLint configuration
- Use Tailwind CSS for styling
- Write descriptive commit messages
- Keep components small and focused

## 📄 License

This project is part of the Oshima ecosystem. See individual package licenses for details.

---

**Oshima** - Building the future of web development, one component at a time.
