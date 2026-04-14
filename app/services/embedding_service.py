import logging

from sentence_transformers import SentenceTransformer

import app.core.config as config

logger = logging.getLogger(__name__)

_model = None


def get_embedding_model():
    global _model

    if _model is None:
        logger.info("Loading embedding model: %s", config.settings.EMBEDDING_MODEL)
        _model = SentenceTransformer(config.settings.EMBEDDING_MODEL)

    return _model
