# Oshima API 🚀

A modern FastAPI backend following industry best practices for the Oshima ecosystem.

## 🏗️ Architecture

```
api/
├── app/                    # Application source code
│   ├── api/               # API routes and endpoints
│   │   └── v1/           # API version 1
│   │       ├── api.py    # Main API router
│   │       └── endpoints/ # Individual endpoint modules
│   ├── core/             # Core application components
│   │   ├── config.py     # Application settings
│   │   └── logging.py    # Logging configuration
│   ├── models/           # Database models (SQLAlchemy)
│   ├── schemas/          # Pydantic models for validation
│   ├── services/         # Business logic layer
│   ├── db/              # Database configuration
│   └── main.py          # FastAPI application factory
├── tests/               # Test suite
├── scripts/            # Utility scripts
├── pyproject.toml      # Modern Python packaging
├── .env.example        # Environment variables template
└── README.md           # This file
```

## ✨ Features

### 🔧 **Modern Development Stack**
- **FastAPI** - High-performance async Python web framework
- **Pydantic v2** - Data validation with type hints
- **Structured Logging** - JSON logging with structlog + Rich
- **uv** - Ultra-fast Python package manager
- **Type Safety** - Full mypy type checking

### 🔒 **Security & Production Ready**
- **CORS** configuration for frontend integration
- **Trusted Host** middleware for production
- **Input Validation** with Pydantic schemas
- **Structured Error Handling**
- **Security Headers** ready for implementation

### 📊 **Observability**
- **Health Checks** - Basic and detailed endpoints
- **Structured Logging** - JSON format with context
- **Rich Console** output for development
- **OpenAPI Documentation** - Auto-generated with FastAPI

### 🎯 **Developer Experience**
- **Hot Reload** in development
- **Auto-generated Docs** at `/docs` and `/redoc`
- **Type-safe** API endpoints
- **Test Suite** ready for implementation

## 🚀 Quick Start

### Prerequisites

- **Python 3.11+** 
- **uv** package manager ([install guide](https://github.com/astral-sh/uv))

### Installation with uv

```bash
# Navigate to API directory
cd api

# Create virtual environment with uv
uv venv

# Activate virtual environment
source .venv/bin/activate  # On macOS/Linux
# or
.venv\\Scripts\\activate   # On Windows

# Install dependencies
uv pip install -e .

# Install development dependencies
uv pip install -e ".[dev]"
```

### Environment Setup

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your settings
# At minimum, set a secure SECRET_KEY
```

### Development Server

```bash
# Option 1: Using uvicorn directly
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Option 2: Using the application script
python -m app.main

# Option 3: From root directory
../dev.sh  # Starts all services including API
```

### Verify Installation

```bash
# Check health endpoint
curl http://localhost:8000/health

# View API documentation
open http://localhost:8000/docs
```

## 📚 API Documentation

### **Endpoints Overview**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | API information and links |
| `/health` | GET | Basic health check |
| `/api/v1/health/detailed` | GET | Detailed system health |
| `/api/v1/users/` | GET, POST | User management |
| `/api/v1/users/{id}` | GET, PUT, DELETE | Individual user operations |
| `/api/v1/items/` | GET, POST | Item management |
| `/api/v1/items/{id}` | GET, PUT, DELETE | Individual item operations |

### **Interactive Documentation**

When running in development mode:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI Spec**: http://localhost:8000/api/v1/openapi.json

## 🧪 Testing

### Automated Endpoint Testing

The API includes an intelligent endpoint testing script that automatically discovers and tests all FastAPI routes:

```bash
# Test all endpoints automatically (recommended)
./test_api.sh
# or
python ping_endpoints.py
```

**Features:**
- 🔍 **Auto-discovery**: Finds all routes via FastAPI introspection
- 🎯 **Smart testing**: Tests appropriate HTTP methods per endpoint
- 📊 **Rich output**: Colored terminal output with response times
- 📁 **Results export**: Saves detailed JSON results with timestamps
- 🌳 **Route visualization**: Shows API structure as a tree

### Unit Testing (Future)

```bash
# Install test dependencies
uv pip install -e ".[dev]"

# Run tests
pytest

# Run tests with coverage
pytest --cov=app --cov-report=html

# Run specific test file
pytest tests/test_main.py

# Run tests with verbose output
pytest -v
```

## 🔧 Development Tools

### **Code Quality**

From the root directory:
```bash
npm run lint:python         # Run all Python linting (black + isort + flake8)
npm run lint:python:fix     # Auto-fix Python formatting
npm run typecheck:python    # Run MyPy type checking
npm run test:api            # Test all endpoints automatically
```

From the api directory:
```bash
# Format code with Black
black .

# Sort imports with isort
isort app tests

# Lint with flake8
flake8 app tests

# Type checking with mypy
mypy app

# Run all checks
black app tests && isort app tests && flake8 app tests && mypy app
```

### **Pre-commit Hooks**

```bash
# Install pre-commit
uv pip install pre-commit

# Install hooks
pre-commit install

# Run on all files
pre-commit run --all-files
```

## 📝 Configuration

### **Environment Variables**

Key environment variables (see `.env.example` for full list):

```bash
# Application
APP_NAME="Oshima API"
DEBUG=true
ENVIRONMENT="development"

# Server
HOST="127.0.0.1"
PORT=8000

# Security
SECRET_KEY="your-secure-secret-key"
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
ALLOWED_ORIGINS=["http://localhost:5173", "http://localhost:4321"]
```

### **Settings Management**

Settings are managed through `app/core/config.py` using Pydantic Settings:

- **Type-safe** configuration
- **Environment variable** override support
- **Validation** of all settings
- **IDE autocompletion** for configuration

## 🔌 Integration

### **Frontend Integration**

The API is designed to work seamlessly with the Oshima frontend applications:

- **React App** (port 5173) - Main application interface
- **Astro Site** (port 4321) - Marketing and documentation
- **CORS** configured for cross-origin requests

### **Database Integration** *(Coming Soon)*

Ready for integration with:
- **PostgreSQL** - Production database
- **SQLite** - Development/testing
- **SQLAlchemy 2.0** - Modern ORM with async support
- **Alembic** - Database migrations

### **Caching Integration** *(Coming Soon)*

Prepared for:
- **Redis** - Session storage and caching
- **In-memory** caching for development

## 📦 Dependencies

### **Core Dependencies**
- `fastapi` - Web framework
- `uvicorn` - ASGI server
- `pydantic` - Data validation
- `pydantic-settings` - Configuration management
- `structlog` - Structured logging
- `rich` - Rich console output

### **Optional Dependencies**
- `[dev]` - Development tools (pytest, black, mypy, etc.)
- `[db]` - Database integration (SQLAlchemy, drivers)
- `[redis]` - Redis integration
- `[monitoring]` - Observability tools

## 🚀 Deployment

### **Production Considerations**

1. **Environment Variables**
   ```bash
   DEBUG=false
   ENVIRONMENT="production"
   SECRET_KEY="your-production-secret"
   ```

2. **Security Headers**
   - TrustedHost middleware enabled
   - CORS properly configured
   - Documentation disabled in production

3. **Logging**
   ```bash
   LOG_LEVEL="INFO"
   LOG_FORMAT="json"
   ```

### **Docker Deployment** *(Coming Soon)*

Ready for containerization with:
- Multi-stage builds
- Security best practices
- Health checks
- Non-root user execution

## 🤝 Contributing

### **Development Workflow**

1. **Set up environment**
   ```bash
   uv venv && source .venv/bin/activate
   uv pip install -e ".[dev]"
   ```

2. **Make changes** following the project structure

3. **Run quality checks**
   ```bash
   black app tests
   isort app tests  
   flake8 app tests
   mypy app
   pytest
   ```

4. **Test integration**
   ```bash
   uvicorn app.main:app --reload
   # Test endpoints at http://localhost:8000/docs
   ```

### **Code Style**

- **Black** for code formatting
- **isort** for import sorting
- **flake8** for linting
- **mypy** for type checking
- **Pydantic** for data validation
- **Structured logging** for observability

## 📄 License

This project is part of the Oshima ecosystem. See the main repository for license details.

---

**Built with ❤️ using FastAPI and modern Python best practices**
