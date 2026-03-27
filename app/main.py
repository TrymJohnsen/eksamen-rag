from fastapi import FastAPI #Python framework for building APIs
import logging #better than print because it provides more features and flexibility

logging.basicConfig(
    level = logging.INFO, #set the logging level to INFO, which means it will log messages with a severity of INFO or higher
    format = '%(asctime)s %(levelname)s %(name)s %(message)s'
)

logger = logging.getLogger(__name__) #create a logger object for the current module
# name is a special variable that holds the name of the current module, so this logger will be named after the module it is defined in

app = FastAPI() #this is FastAPI instance, which is the main entry point for my API application


@app.get("/health")
def health():
    logger.info("health check called")
    return {"status": "ok"}


@app.get("/")
def root():
    return {"message": "Local exam AI service is running"}
    