import functools
import logging
import os

import pydantic

logger = logging.getLogger('uvicorn')


class Settings(pydantic.BaseSettings):
    environment: str = os.environ.get('ENVIRONMENT', 'dev')
    testing: bool = os.environ.get('TESTING', 0)


@functools.lru_cache()
def get_settings() -> Settings:
    logger.info('Loading config settings from the environment...')
    return Settings()
