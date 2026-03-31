from fastapi import APIRouter, HTTPException
import logging
from pydantic import BaseModel

from app.services.search_service import run_query

router = APIRouter()
logger = logging.getLogger(__name__)


class QueryRequest(BaseModel):
    query: str


@router.get("/")
def root():
    return {"message": "Local Document AI Service is running"}


@router.get("/health")
def health():
    logger.info("Health check called")
    return {"status": "ok"}

    
@router.post("/query")
def query_post(request: QueryRequest):
    if not request.query.strip():
        raise HTTPException(status_code=400, detail="Field 'query' cannot be empty")
    
    logger.info(f"Received query: {request.query}")
    return run_query(request.query)
