"""Main FastAPI application."""

from contextlib import asynccontextmanager
from typing import AsyncGenerator

import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.responses import JSONResponse

from app import __description__, __version__
from app.api.v1.api import api_router
from app.core.config import settings
from app.core.logging import get_logger, setup_logging

# Set up logging
setup_logging()
logger = get_logger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """Application lifespan events."""
    # Startup
    logger.info("Starting Oshima API", version=__version__)

    # Add any startup logic here
    # e.g., database connection, cache initialization

    yield

    # Shutdown
    logger.info("Shutting down Oshima API")

    # Add any cleanup logic here
    # e.g., close database connections, cleanup caches


def create_application() -> FastAPI:
    """Create FastAPI application with all configurations."""

    app = FastAPI(
        title=settings.APP_NAME,
        description=__description__,
        version=__version__,
        openapi_url="/api/v1/openapi.json" if settings.DEBUG else None,
        docs_url="/docs" if settings.DEBUG else None,
        redoc_url="/redoc" if settings.DEBUG else None,
        lifespan=lifespan,
    )

    # Add security middleware
    if not settings.DEBUG:
        app.add_middleware(
            TrustedHostMiddleware,
            allowed_hosts=["localhost", "127.0.0.1", "*.oshima.dev"],
        )

    # Add CORS middleware
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.ALLOWED_ORIGINS,
        allow_credentials=True,
        allow_methods=settings.ALLOWED_METHODS,
        allow_headers=settings.ALLOWED_HEADERS,
    )

    # Include API routers
    app.include_router(api_router, prefix="/api/v1")

    # Root endpoint
    @app.get("/", response_class=JSONResponse)
    async def root():
        """Root endpoint with API information."""
        return {
            "message": "Welcome to Oshima API",
            "version": __version__,
            "description": __description__,
            "docs_url": "/docs" if settings.DEBUG else None,
            "redoc_url": "/redoc" if settings.DEBUG else None,
        }

    # Health check endpoint
    @app.get("/health", response_class=JSONResponse)
    async def health_check():
        """Health check endpoint."""
        return {
            "status": "healthy",
            "version": __version__,
            "environment": settings.ENVIRONMENT,
        }

    return app


# Create the FastAPI app
app = create_application()


def main() -> None:
    """Run the application."""
    uvicorn.run(
        "app.main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.RELOAD,
        log_level=settings.LOG_LEVEL.lower(),
    )


if __name__ == "__main__":
    main()
