from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import base
from app.models import contact as contact_model
from app.models import user as user_model
from app.schemas import contact as contact_schema
from app.core import security
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from app.core.config import settings
from app.schemas.user import TokenData

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/v1/auth/token")

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(base.get_db)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
        token_data = TokenData(email=email)
    except JWTError:
        raise credentials_exception
    user = db.query(user_model.User).filter(user_model.User.email == token_data.email).first()
    if user is None:
        raise credentials_exception
    return user

@router.get("/", response_model=List[contact_schema.Contact])
def read_contacts(skip: int = 0, limit: int = 100, db: Session = Depends(base.get_db), current_user: user_model.User = Depends(get_current_user)):
    contacts = db.query(contact_model.Contact).filter(contact_model.Contact.owner_id == current_user.id).offset(skip).limit(limit).all()
    return contacts

@router.post("/", response_model=contact_schema.Contact)
def create_contact(contact: contact_schema.ContactCreate, db: Session = Depends(base.get_db), current_user: user_model.User = Depends(get_current_user)):
    db_contact = contact_model.Contact(**contact.dict(), owner_id=current_user.id)
    db.add(db_contact)
    db.commit()
    db.refresh(db_contact)
    return db_contact

@router.put("/{contact_id}", response_model=contact_schema.Contact)
def update_contact(contact_id: int, contact: contact_schema.ContactUpdate, db: Session = Depends(base.get_db), current_user: user_model.User = Depends(get_current_user)):
    db_contact = db.query(contact_model.Contact).filter(contact_model.Contact.id == contact_id, contact_model.Contact.owner_id == current_user.id).first()
    if not db_contact:
        raise HTTPException(status_code=404, detail="Contact not found")
    for key, value in contact.dict().items():
        setattr(db_contact, key, value)
    db.commit()
    db.refresh(db_contact)
    return db_contact

@router.delete("/{contact_id}")
def delete_contact(contact_id: int, db: Session = Depends(base.get_db), current_user: user_model.User = Depends(get_current_user)):
    db_contact = db.query(contact_model.Contact).filter(contact_model.Contact.id == contact_id, contact_model.Contact.owner_id == current_user.id).first()
    if not db_contact:
        raise HTTPException(status_code=404, detail="Contact not found")
    db.delete(db_contact)
    db.commit()
    return {"ok": True}
