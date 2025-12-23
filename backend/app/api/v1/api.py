from fastapi import APIRouter
from app.api.v1.endpoints import auth, contacts

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(contacts.router, prefix="/contacts", tags=["contacts"])
