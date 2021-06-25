import functools
import logging
import os

from pydantic import AnyUrl, BaseSettings

logger = logging.getLogger("uvicorn")


class Settings(BaseSettings):
    environment: str = os.environ.get("ENVIRONMENT", "dev")
    testing: bool = os.environ.get("TESTING", 0)
    database_url: AnyUrl = os.environ.get("DATABASE_URL")


@functools.lru_cache()
def get_settings() -> Settings:
    logger.info("Loading config settings from the environment...")
    return Settings()
