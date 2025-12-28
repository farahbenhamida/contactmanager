import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.api import api_router

# Initialize the correct "Advanced" backend application
app = FastAPI(title="Contact Manager API (Advanced)")

# Add CORS so the emulator/device can connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include the routers (Auth, Contacts) which match ApiService.dart paths
# ApiService expects: /auth/login, /contacts
# api_router in api.py already includes /auth and /contacts prefixes.
app.include_router(api_router)

if __name__ == "__main__":
    # Run on 0.0.0.0 to be accessible from Emulator (10.0.2.2)
    uvicorn.run(app, host="0.0.0.0", port=8000)
