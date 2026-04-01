import os
from dotenv import load_dotenv

load_dotenv()


def _get_int(name: str, default: int) -> int:
    value = os.getenv(name)

    if value is None:
        return default

    try:
        parsed = int(value)
    except ValueError:
        return default

    return parsed if parsed > 0 else default


class Settings:
    APP_NAME: str = os.getenv("APP_NAME", "Local Document AI Service")
    APP_ENV: str = os.getenv("APP_ENV", "development")
    APP_HOST: str = os.getenv("APP_HOST", "0.0.0.0")
    APP_PORT: int = _get_int("APP_PORT", 8000)
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
    DOCUMENTS_PATH: str = os.getenv("DOCUMENTS_PATH", "documents")
    CHUNK_SIZE: int = _get_int("CHUNK_SIZE", 200)
    EMBEDDING_MODEL: str = os.getenv("EMBEDDING_MODEL", "sentence-transformers/all-MiniLM-L6-v2")
    INDEX_PATH: str = os.getenv("INDEX_PATH", "indexes")


settings = Settings()
