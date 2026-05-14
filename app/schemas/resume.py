from pydantic import BaseModel
from typing import Optional

class ResumeCreate(BaseModel):
    full_name: str
    email: str
    phone: Optional[str] = None
    summary: Optional[str] = None
    education: Optional[str] = None
    experience: Optional[str] = None
    skills: Optional[str] = None

class ResumeUpdate(BaseModel):
    full_name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    summary: Optional[str] = None
    education: Optional[str] = None
    experience: Optional[str] = None
    skills: Optional[str] = None

class ResumeResponse(BaseModel):
    id: int
    user_id: int
    full_name: str
    email: str
    phone: Optional[str] = None
    summary: Optional[str] = None
    education: Optional[str] = None
    experience: Optional[str] = None
    skills: Optional[str] = None
    ai_generated_resume: Optional[str] = None

    class Config:
        from_attributes = True