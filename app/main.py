from fastapi import FastAPI #Python framework for building APIs
import logging #better than print because it provides more features and flexibility

from app.api.routes import router
from app.core.config import settings

logging.basicConfig( 
    level = logging.INFO, #set the logging level to INFO, which means it will log messages with a severity of INFO or higher
    format = '%(asctime)s %(levelname)s %(name)s %(message)s'
)

logger = logging.getLogger(__name__) #create a logger object for the current module
# name is a special variable that holds the name of the current module, so this logger will be named after the module it is defined in


app = FastAPI(title=settings.APP_NAME)
app.include_router(router)

logger.info(f"Starting {settings.APP_NAME} in {settings.APP_ENV} mode")
