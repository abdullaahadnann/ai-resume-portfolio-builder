from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.resume import Resume
from app.models.user import User
from app.schemas.resume import ResumeCreate, ResumeUpdate, ResumeResponse
from app.services.user_service import get_current_user

router = APIRouter(prefix="/resume", tags=["Resume"])

@router.post("/", response_model=ResumeResponse, status_code=201)
def create_resume(resume: ResumeCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    # Check if user already has a resume
    existing = db.query(Resume).filter(Resume.user_id == current_user.id).first()
    if existing:
        raise HTTPException(status_code=400, detail="Resume already exists, use PUT to update")
    
    new_resume = Resume(
        user_id=current_user.id,
        **resume.dict()
    )
    db.add(new_resume)
    db.commit()
    db.refresh(new_resume)
    return new_resume

@router.get("/me", response_model=ResumeResponse)
def get_my_resume(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    resume = db.query(Resume).filter(Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=404, detail="No resume found, create one first")
    return resume

@router.put("/me", response_model=ResumeResponse)
def update_resume(resume: ResumeUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    existing = db.query(Resume).filter(Resume.user_id == current_user.id).first()
    if not existing:
        raise HTTPException(status_code=404, detail="No resume found, create one first")
    
    # Only update fields that were actually sent
    for field, value in resume.dict(exclude_none=True).items():
        setattr(existing, field, value)
    
    db.commit()
    db.refresh(existing)
    return existing