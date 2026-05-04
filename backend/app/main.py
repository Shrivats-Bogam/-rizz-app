from fastapi import FastAPI, HTTPException
from .models.schemas import GenerateRequest, GenerateResponse, RewriteRequest, RewriteResponse, AnalyzeRequest, AnalyzeResponse
from .services.nim_service import nim_service

app = FastAPI(title="Rizz AI Backend")

@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.post("/generate", response_model=GenerateResponse)
async def generate_rizz(request: GenerateRequest):
    try:
        message = await nim_service.generate_rizz(request.tone, request.context, request.details)
        return GenerateResponse(message=message)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/rewrite", response_model=RewriteResponse)
async def rewrite_rizz(request: RewriteRequest):
    try:
        variations = await nim_service.rewrite_message(request.message)
        return RewriteResponse(variations=variations)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/analyze", response_model=AnalyzeResponse)
async def analyze_chat(request: AnalyzeRequest):
    try:
        analysis = await nim_service.analyze_chat(request.chat)
        return AnalyzeResponse(**analysis)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
