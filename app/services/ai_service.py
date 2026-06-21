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

def match_resume_to_job(resume_data: dict, job_description: str) -> str:
    prompt = f"""
    You are a professional resume writer specializing in tailoring resumes to job descriptions.
    
    Here is the candidate's current information:
    Name: {resume_data['full_name']}
    Email: {resume_data['email']}
    Phone: {resume_data.get('phone', 'Not provided')}
    Summary: {resume_data.get('summary', 'Not provided')}
    Education: {resume_data.get('education', 'Not provided')}
    Experience: {resume_data.get('experience', 'Not provided')}
    Skills: {resume_data.get('skills', 'Not provided')}
    
    Here is the job description they are applying for:
    {job_description}
    
    Rewrite their resume to:
    1. Match the keywords and requirements in the job description
    2. Highlight the most relevant skills and experience
    3. Use the same terminology as the job description
    4. Make it ATS friendly
    5. Keep it professional and compelling
    
    Write the complete tailored resume.
    """

    response = client.chat.completions.create(
        model="llama-3.3-70b-versatile",
        messages=[
            {"role": "system", "content": "You are an expert resume writer who specializes in ATS optimization and job matching."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=2000
    )

    return response.choices[0].message.content

def check_ats_score(resume_data: dict, job_description: str) -> dict:
    prompt = f"""
    You are an ATS (Applicant Tracking System) expert. Analyze the following resume against the job description and provide a score.

    Resume:
    Name: {resume_data['full_name']}
    Summary: {resume_data.get('summary', 'Not provided')}
    Education: {resume_data.get('education', 'Not provided')}
    Experience: {resume_data.get('experience', 'Not provided')}
    Skills: {resume_data.get('skills', 'Not provided')}

    Job Description:
    {job_description}

    Respond in this exact JSON format with no extra text:
    {{
        "score": <number between 0 and 100>,
        "matching_keywords": [<list of keywords that match>],
        "missing_keywords": [<list of important keywords that are missing>],
        "suggestions": [<list of specific improvements>]
    }}
    """

    response = client.chat.completions.create(
        model="llama-3.3-70b-versatile",
        messages=[
            {"role": "system", "content": "You are an ATS optimization expert. Always respond with valid JSON only, no extra text."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=1000
    )

    import json
    result = response.choices[0].message.content
    clean = result.replace("```json", "").replace("```", "").strip()
    return json.loads(clean)