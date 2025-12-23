from typing import Optional
from pydantic import BaseModel

class ContactBase(BaseModel):
    name: str
    phone: str
    email: Optional[str] = None

class ContactCreate(ContactBase):
    pass

class ContactUpdate(ContactBase):
    pass

class Contact(ContactBase):
    id: int
    owner_id: int

    class Config:
        from_attributes = True
