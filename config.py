"""Application configuration loaded from environment."""

import os
from dotenv import load_dotenv

load_dotenv()


def _require_env(name: str) -> str:
    value = os.environ.get(name, "").strip()
    if not value:
        raise RuntimeError(
            f"Missing required environment variable: {name}. "
            "Set it in a .env file or the environment."
        )
    return value


class Config:
    """Flask and service settings."""

    GEMINI_API_KEY: str = os.environ.get("GEMINI_API_KEY", "").strip()

    # Use a current Gemini model name.
    # You can also try "gemini-flash-latest" if needed.
    GEMINI_MODEL: str = os.environ.get("GEMINI_MODEL", "gemini-2.5-flash").strip()

    MAX_CONTENT_LENGTH: int = int(
        os.environ.get("MAX_CONTENT_LENGTH", 16 * 1024 * 1024)
    )

    @staticmethod
    def validate_gemini_config() -> None:
        """Ensure API key is present when AI routes are used."""
        _require_env("GEMINI_API_KEY")