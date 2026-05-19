from pydantic import BaseModel

class JobMatchRequest(BaseModel):
    job_description: str