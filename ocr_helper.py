"""
OCR helper: extract text from images using Tesseract via pytesseract.
"""

from __future__ import annotations

import io
import os
from typing import BinaryIO

from PIL import Image
import pytesseract


DEFAULT_TESSERACT_PATH = r"C:\Program Files\Tesseract-OCR\tesseract.exe"


def configure_tesseract() -> None:
    """
    Configure pytesseract to use the installed Tesseract executable.
    """
    custom_path = os.environ.get("TESSERACT_CMD", DEFAULT_TESSERACT_PATH)

    if os.path.exists(custom_path):
        pytesseract.pytesseract.tesseract_cmd = custom_path


def preprocess_image(image: Image.Image) -> Image.Image:
    """
    Convert image into a cleaner format for OCR.
    """
    if image.mode not in ("RGB", "L"):
        image = image.convert("RGB")

    image = image.convert("L")
    return image


def extract_text_from_image_stream(stream: BinaryIO) -> str:
    """
    Read an image from a binary stream, run OCR, return stripped text.
    """
    data = stream.read()
    if not data:
        raise ValueError("Empty image data.")

    return extract_text_from_image_bytes(data)


def extract_text_from_image_bytes(image_bytes: bytes) -> str:
    """
    Decode bytes to an image and run Tesseract OCR.
    """
    if not image_bytes:
        raise ValueError("Empty image data.")

    configure_tesseract()

    try:
        image = Image.open(io.BytesIO(image_bytes))
    except Exception as exc:
        raise ValueError("Could not decode image. Use PNG or JPEG.") from exc

    image = preprocess_image(image)

    try:
        raw = pytesseract.image_to_string(image, lang="eng")
    except pytesseract.TesseractNotFoundError:
        raise ValueError(
            "Tesseract OCR is installed but could not be located. "
            "Check TESSERACT_CMD or installation path."
        )
    except Exception as exc:
        raise ValueError(f"OCR failed: {exc}") from exc

    text = (raw or "").strip()
    if not text:
        raise ValueError("No text could be extracted from the image.")

    return text