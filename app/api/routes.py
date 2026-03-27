from fastapi import APIRouter, HTTPException
import logging

from app.services.search_service import run_query

router = APIRouter()
logger = logging.getLogger(__name__)


@router.get("/")
def root():
    return {"message": "Local Document AI Service is running"}


@router.get("/health")
def health():
    logger.info("Health check called")
    return {"status": "ok"}


@router.get("/query")
def query(q: str):
    if not q.strip():
        raise HTTPException(status_code=400, detail="Query parameter 'q' cannot be empty")
    
    logger.info(f"Received query: {q}")
    return run_query(q)
    