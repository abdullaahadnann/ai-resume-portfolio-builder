from sqlalchemy import Column, Integer, String, Text, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base

class Resume(Base):
    __tablename__ = "resumes"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    full_name = Column(String, nullable=False)
    email = Column(String, nullable=False)
    phone = Column(String, nullable=True)
    summary = Column(Text, nullable=True)
    education = Column(Text, nullable=True)
    experience = Column(Text, nullable=True)
    skills = Column(Text, nullable=True)
    ai_generated_resume = Column(Text, nullable=True)
    ai_generated_portfolio = Column(Text, nullable=True)

    owner = relationship("User", back_populates="resume")