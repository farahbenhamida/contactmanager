from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from app.core import security, config
from app.db import base
from app.models import user as user_model
from app.schemas import user as user_schema

router = APIRouter()

@router.post("/token", response_model=user_schema.Token)
def login_access_token(db: Session = Depends(base.get_db), form_data: OAuth2PasswordRequestForm = Depends()):
    user = db.query(user_model.User).filter(user_model.User.email == form_data.username).first()
    if not user or not security.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=config.settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = security.create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/register", response_model=user_schema.User)
def register_user(user_in: user_schema.UserCreate, db: Session = Depends(base.get_db)):
    user = db.query(user_model.User).filter(user_model.User.email == user_in.email).first()
    if user:
        raise HTTPException(
            status_code=400,
            detail="The user with this username already exists in the system.",
        )
    hashed_password = security.get_password_hash(user_in.password)
    db_user = user_model.User(email=user_in.email, hashed_password=hashed_password, name=user_in.name)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
