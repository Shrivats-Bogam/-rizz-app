from enum import Enum
from pydantic import BaseModel
from typing import Dict, Optional

class Tone(str, Enum):
    FUNNY = "funny"
    SMOOTH = "smooth"
    SAVAGE = "savage"
    CUTE = "cute"
    MYSTERIOUS = "mysterious"
    INTELLECTUAL = "intellectual"

class Context(str, Enum):
    CRUSH = "crush"
    DATING_APP = "dating_app"
    TEXT = "text"
    INSTAGRAM = "instagram"

class GenerateRequest(BaseModel):
    tone: Tone
    context: Context
    details: Optional[str] = "None"

class GenerateResponse(BaseModel):
    message: str

class RewriteRequest(BaseModel):
    message: str

class RewriteResponse(BaseModel):
    variations: Dict[str, str] # Keys: safe, bold, playful

class AnalyzeRequest(BaseModel):
    chat: str

class AnalyzeResponse(BaseModel):
    vibe: str
    interest_level: float
    red_flags: list[str]
    suggestion: str
