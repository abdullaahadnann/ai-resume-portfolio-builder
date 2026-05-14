import os
from groq import Groq
from dotenv import load_dotenv

load_dotenv()

client = Groq(api_key=os.getenv("GROQ_API_KEY"))


def generate_resume(resume_data: dict) -> str:
    prompt = f"""
    You are a professional resume writer. Based on the following information,
    write a polished, professional resume in a clean format.

    Name: {resume_data['full_name']}
    Email: {resume_data['email']}
    Phone: {resume_data.get('phone', 'Not provided')}
    Summary: {resume_data.get('summary', 'Not provided')}
    Education: {resume_data.get('education', 'Not provided')}
    Experience: {resume_data.get('experience', 'Not provided')}
    Skills: {resume_data.get('skills', 'Not provided')}

    Write a complete, professional resume with proper sections and formatting.
    Make it compelling and highlight the candidate's strengths.
    """
    response = client.chat.completions.create(
        model="llama-3.3-70b-versatile",
        messages=[
            {"role": "system", "content": "You are an expert resume writer with 10 years of experience."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=2000
    )
    return response.choices[0].message.content


def generate_portfolio(resume_data: dict) -> str:
    prompt = f"""
    You are a professional portfolio writer. Based on the following information,
    write a compelling portfolio bio and project descriptions.

    Name: {resume_data['full_name']}
    Summary: {resume_data.get('summary', 'Not provided')}
    Education: {resume_data.get('education', 'Not provided')}
    Experience: {resume_data.get('experience', 'Not provided')}
    Skills: {resume_data.get('skills', 'Not provided')}

    Write:
    1. A compelling professional bio (2-3 paragraphs)
    2. A skills showcase section
    3. A career highlights section
    Make it engaging and suitable for a portfolio website.
    """
    response = client.chat.completions.create(
        model="llama-3.3-70b-versatile",
        messages=[
            {"role": "system", "content": "You are an expert portfolio and personal branding writer."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=2000
    )
    return response.choices[0].message.content