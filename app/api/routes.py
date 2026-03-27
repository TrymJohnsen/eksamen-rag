from fastapi import APIRouter
import logging

router = APIRouter()
logger = logging.getLogger(__name__)


@router.get("/")
def root():
    return {"message": "Local Document AI Service is running"}


@router.get("/health")
def health():
    logger.info("Health check called")
    return {"status": "ok"}