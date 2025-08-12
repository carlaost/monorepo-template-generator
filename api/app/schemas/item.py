"""Item schemas for request/response models."""

from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class ItemBase(BaseModel):
    """Base item schema."""

    title: str
    description: Optional[str] = None
    is_active: bool = True


class ItemCreate(ItemBase):
    """Schema for creating an item."""

    pass


class ItemUpdate(BaseModel):
    """Schema for updating an item."""

    title: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None


class ItemInDB(ItemBase):
    """Schema for item stored in database."""

    id: int
    owner_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class Item(ItemBase):
    """Schema for item response."""

    id: int
    owner_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
