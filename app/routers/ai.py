from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.resume import Resume
from app.models.user import User
from app.services.ai_service import generate_resume, generate_portfolio
from app.services.user_service import get_current_user
from app.schemas.ai import JobMatchRequest
from app.services.ai_service import generate_resume, generate_portfolio, match_resume_to_job, check_ats_score

router = APIRouter(prefix="/ai", tags=["AI Generation"])

@router.post("/generate-resume")
def ai_generate_resume(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    # Get user's resume data
    resume = db.query(Resume).filter(Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=404, detail="No resume found, create one first")
    
    # Convert resume to dict and send to AI
    resume_data = {
        "full_name": resume.full_name,
        "email": resume.email,
        "phone": resume.phone,
        "summary": resume.summary,
        "education": resume.education,
        "experience": resume.experience,
        "skills": resume.skills
    }
    
    # Generate AI resume
    ai_resume = generate_resume(resume_data)
    
    # Save it back to database
    resume.ai_generated_resume = ai_resume
    db.commit()
    db.refresh(resume)
    
    return {
        "message": "Resume generated successfully!",
        "ai_generated_resume": ai_resume
    }

@router.post("/generate-portfolio")
def ai_generate_portfolio(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    resume = db.query(Resume).filter(Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=404, detail="No resume found, create one first")
    
    resume_data = {
        "full_name": resume.full_name,
        "summary": resume.summary,
        "education": resume.education,
        "experience": resume.experience,
        "skills": resume.skills
    }
    
    ai_portfolio = generate_portfolio(resume_data)
    
    # Save to database
    resume.ai_generated_portfolio = ai_portfolio
    db.commit()
    db.refresh(resume)
    
    return {
        "message": "Portfolio generated successfully!",
        "ai_generated_portfolio": ai_portfolio
    }


@router.post("/match-job")
def match_job(request: JobMatchRequest, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    resume = db.query(Resume).filter(Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=404, detail="No resume found, create one first")
    
    resume_data = {
        "full_name": resume.full_name,
        "email": resume.email,
        "phone": resume.phone,
        "summary": resume.summary,
        "education": resume.education,
        "experience": resume.experience,
        "skills": resume.skills
    }
    
    matched_resume = match_resume_to_job(resume_data, request.job_description)
    
    return {
        "message": "Resume matched to job successfully!",
        "matched_resume": matched_resume
    }

@router.post("/ats-score")
def ats_score(request: JobMatchRequest, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    # Get user's resume from database
    resume = db.query(Resume).filter(Resume.user_id == current_user.id).first()
    if not resume:
        raise HTTPException(status_code=404, detail="No resume found, create one first")
    
    # Build resume data dict
    resume_data = {
        "full_name": resume.full_name,
        "summary": resume.summary,
        "education": resume.education,
        "experience": resume.experience,
        "skills": resume.skills
    }
    
    # Get ATS score from AI
    score_result = check_ats_score(resume_data, request.job_description)
    
    return {
        "message": "ATS score calculated successfully!",
        "result": score_result
    }