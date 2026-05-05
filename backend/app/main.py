import logging
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from .models.schemas import GenerateRequest, GenerateResponse, RewriteRequest, RewriteResponse, AnalyzeRequest, AnalyzeResponse
from .services.nim_service import nim_service

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Rizz AI Backend")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.post("/generate", response_model=GenerateResponse)
async def generate_rizz(request: GenerateRequest):
    try:
        message = await nim_service.generate_rizz(request.tone, request.context, request.details)
        return GenerateResponse(message=message)
    except Exception:
        logger.exception("Error generating rizz")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.post("/rewrite", response_model=RewriteResponse)
async def rewrite_rizz(request: RewriteRequest):
    try:
        variations = await nim_service.rewrite_message(request.message)
        return RewriteResponse(variations=variations)
    except Exception:
        logger.exception("Error rewriting message")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.post("/analyze", response_model=AnalyzeResponse)
async def analyze_chat(request: AnalyzeRequest):
    try:
        analysis = await nim_service.analyze_chat(request.chat)
        return AnalyzeResponse(**analysis)
    except Exception:
        logger.exception("Error analyzing chat")
        raise HTTPException(status_code=500, detail="Internal server error")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
