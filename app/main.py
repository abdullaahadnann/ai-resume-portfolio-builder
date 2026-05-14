from fastapi import FastAPI
from fastapi.security import HTTPBearer
from app.database import engine, Base
import app.models
from app.routers import auth, resume, ai

Base.metadata.create_all(bind=engine)

security = HTTPBearer()

app = FastAPI(title="AI Resume Builder")

app.include_router(auth.router)
app.include_router(resume.router)
app.include_router(ai.router)

@app.get("/")
def home():
    return {"message": "AI Resume Builder API is running!"}