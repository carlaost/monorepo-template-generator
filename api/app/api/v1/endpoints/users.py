"""User endpoints."""

from datetime import datetime
from typing import List

from fastapi import APIRouter, HTTPException, status

from app.core.logging import get_logger
from app.schemas.user import User, UserCreate, UserUpdate

logger = get_logger(__name__)
router = APIRouter()

# Mock data for demonstration
MOCK_USERS = [
    {
        "id": 1,
        "email": "alice@example.com",
        "name": "Alice Johnson",
        "is_active": True,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow(),
    },
    {
        "id": 2,
        "email": "bob@example.com",
        "name": "Bob Smith",
        "is_active": True,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow(),
    },
]


@router.get("/", response_model=List[User])
async def list_users() -> List[User]:
    """Get all users."""
    logger.info("Fetching all users")
    return [User(**user) for user in MOCK_USERS]


@router.get("/{user_id}", response_model=User)
async def get_user(user_id: int) -> User:
    """Get a user by ID."""
    logger.info("Fetching user", user_id=user_id)

    user = next((user for user in MOCK_USERS if user["id"] == user_id), None)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    return User(**user)


@router.post("/", response_model=User, status_code=status.HTTP_201_CREATED)
async def create_user(user_data: UserCreate) -> User:
    """Create a new user."""
    logger.info("Creating new user", email=user_data.email)

    # Check if user already exists
    if any(user["email"] == user_data.email for user in MOCK_USERS):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists",
        )

    # Create new user
    new_user = {
        "id": len(MOCK_USERS) + 1,
        "email": user_data.email,
        "name": user_data.name,
        "is_active": user_data.is_active,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow(),
    }

    MOCK_USERS.append(new_user)

    return User(**new_user)


@router.put("/{user_id}", response_model=User)
async def update_user(user_id: int, user_data: UserUpdate) -> User:
    """Update a user."""
    logger.info("Updating user", user_id=user_id)

    user_index = next(
        (i for i, user in enumerate(MOCK_USERS) if user["id"] == user_id), None
    )

    if user_index is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    # Update user data
    user = MOCK_USERS[user_index]
    update_data = user_data.dict(exclude_unset=True)

    for field, value in update_data.items():
        if field in user:
            user[field] = value

    user["updated_at"] = datetime.utcnow()

    return User(**user)


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(user_id: int) -> None:
    """Delete a user."""
    logger.info("Deleting user", user_id=user_id)

    user_index = next(
        (i for i, user in enumerate(MOCK_USERS) if user["id"] == user_id), None
    )

    if user_index is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    MOCK_USERS.pop(user_index)
