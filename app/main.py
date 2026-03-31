import logging

from fastapi import FastAPI

from app.api.routes import router
from app.core.config import settings

logging.basicConfig(
    level=getattr(logging, settings.LOG_LEVEL.upper(), logging.INFO),
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)

logger = logging.getLogger(__name__)

app = FastAPI(title=settings.APP_NAME)
app.include_router(router)


@app.on_event("startup")
def log_startup() -> None:
    logger.info("Starting %s in %s mode", settings.APP_NAME, settings.APP_ENV)
