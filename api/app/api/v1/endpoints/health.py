"""Health check endpoints."""

from datetime import datetime
from typing import Any, Dict

from fastapi import APIRouter
from fastapi.responses import JSONResponse

from app import __version__
from app.core.config import settings
from app.core.logging import get_logger

logger = get_logger(__name__)
router = APIRouter()


@router.get("/", response_class=JSONResponse)
async def health_check() -> Dict[str, str]:
    """Basic health check endpoint."""
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "version": __version__,
        "environment": settings.ENVIRONMENT,
    }


@router.get("/detailed", response_class=JSONResponse)
async def detailed_health_check() -> Dict[str, Any]:
    """Detailed health check with system information."""
    try:
        # Add checks for external dependencies here
        # e.g., database connection, redis connection, etc.

        return {
            "status": "healthy",
            "timestamp": datetime.utcnow().isoformat(),
            "version": __version__,
            "environment": settings.ENVIRONMENT,
            "app_name": settings.APP_NAME,
            "debug": settings.DEBUG,
            "checks": {
                "api": "healthy",
                # "database": "healthy",  # Uncomment when database is added
                # "redis": "healthy",     # Uncomment when redis is added
            },
        }
    except Exception as e:
        logger.error("Health check failed", error=str(e))
        return JSONResponse(
            status_code=503,
            content={
                "status": "unhealthy",
                "timestamp": datetime.utcnow().isoformat(),
                "error": str(e),
            },
        )
