"""Item endpoints."""

from datetime import datetime
from typing import List

from fastapi import APIRouter, HTTPException, status

from app.core.logging import get_logger
from app.schemas.item import Item, ItemCreate, ItemUpdate

logger = get_logger(__name__)
router = APIRouter()

# Mock data for demonstration
MOCK_ITEMS = [
    {
        "id": 1,
        "title": "Sample Item 1",
        "description": "This is a sample item for demonstration",
        "is_active": True,
        "owner_id": 1,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow(),
    },
    {
        "id": 2,
        "title": "Sample Item 2",
        "description": "Another sample item",
        "is_active": True,
        "owner_id": 2,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow(),
    },
]


@router.get("/", response_model=List[Item])
async def list_items() -> List[Item]:
    """Get all items."""
    logger.info("Fetching all items")
    return [Item(**item) for item in MOCK_ITEMS]


@router.get("/{item_id}", response_model=Item)
async def get_item(item_id: int) -> Item:
    """Get an item by ID."""
    logger.info("Fetching item", item_id=item_id)

    item = next((item for item in MOCK_ITEMS if item["id"] == item_id), None)
    if not item:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Item not found"
        )

    return Item(**item)


@router.post("/", response_model=Item, status_code=status.HTTP_201_CREATED)
async def create_item(item_data: ItemCreate) -> Item:
    """Create a new item."""
    logger.info("Creating new item", title=item_data.title)

    # Create new item
    new_item = {
        "id": len(MOCK_ITEMS) + 1,
        "title": item_data.title,
        "description": item_data.description,
        "is_active": item_data.is_active,
        "owner_id": 1,  # Default owner for demo
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow(),
    }

    MOCK_ITEMS.append(new_item)

    return Item(**new_item)


@router.put("/{item_id}", response_model=Item)
async def update_item(item_id: int, item_data: ItemUpdate) -> Item:
    """Update an item."""
    logger.info("Updating item", item_id=item_id)

    item_index = next(
        (i for i, item in enumerate(MOCK_ITEMS) if item["id"] == item_id), None
    )

    if item_index is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Item not found"
        )

    # Update item data
    item = MOCK_ITEMS[item_index]
    update_data = item_data.dict(exclude_unset=True)

    for field, value in update_data.items():
        if field in item:
            item[field] = value

    item["updated_at"] = datetime.utcnow()

    return Item(**item)


@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_item(item_id: int) -> None:
    """Delete an item."""
    logger.info("Deleting item", item_id=item_id)

    item_index = next(
        (i for i, item in enumerate(MOCK_ITEMS) if item["id"] == item_id), None
    )

    if item_index is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Item not found"
        )

    MOCK_ITEMS.pop(item_index)
