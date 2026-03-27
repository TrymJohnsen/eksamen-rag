import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    APP_NAME: str = os.getenv("APP_NAME", "Local Document AI Service")
    APP_ENV: str = os.getenv("APP_ENV", "development")
    APP_HOST: str = os.getenv("APP_HOST", "0.0.0.0")
    APP_PORT: int = int(os.getenv("APP_PORT", "8000"))
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
    DOCUMENTS_PATH: str = os.getenv("DOCUMENTS_PATH", "documents")
    INDEX_PATH: str = os.getenv("INDEX_PATH", "indexes")


settings = Settings() # create an instance of the Settings class, which will load the configuration values from the environment variables and make them available as attributes of the settings object one time