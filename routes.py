"""HTTP routes: health, OCR, and AI."""

from __future__ import annotations

import logging

from flask import Blueprint, jsonify, request

import pytesseract

from app.services.gemini_ai import generate_ncert_answer
from app.services.ocr_helper import extract_text_from_image_stream

logger = logging.getLogger(__name__)

bp = Blueprint("api", __name__)


@bp.route("/", methods=["GET"])
def health():
    """Health check."""
    return "ok", 200, {"Content-Type": "text/plain; charset=utf-8"}


@bp.route("/ocr", methods=["POST"])
def ocr():
    """
    Accept multipart/form-data with an image file.
    Field name: 'file' or 'image'.
    """
    try:
        upload = request.files.get("file") or request.files.get("image")
        if upload is None or upload.filename is None or upload.filename == "":
            return (
                jsonify(
                    {
                        "success": False,
                        "error": "Missing file. Send multipart/form-data with field 'file' or 'image'.",
                    }
                ),
                400,
            )

        # Read stream into OCR helper
        text = extract_text_from_image_stream(upload.stream)
        return jsonify({"success": True, "extracted_text": text}), 200

    except ValueError as exc:
        logger.warning("OCR validation error: %s", exc)
        return jsonify({"success": False, "error": str(exc)}), 400

    except pytesseract.TesseractNotFoundError:
        logger.error("Tesseract executable not found on PATH.")
        return (
            jsonify(
                {
                    "success": False,
                    "error": "Tesseract OCR is not installed or not on PATH. See README.",
                }
            ),
            503,
        )

    except Exception as exc:
        logger.exception("OCR failed")
        return jsonify({"success": False, "error": f"OCR failed: {exc}"}), 500


@bp.route("/ai", methods=["POST"])
def ai():
    """
    JSON body: question, subject, chapter, language.
    """
    if not request.is_json:
        return (
            jsonify({"success": False, "error": "Content-Type must be application/json."}),
            415,
        )

    payload = request.get_json(silent=True)
    if payload is None:
        return jsonify({"success": False, "error": "Invalid JSON body."}), 400

    question = (payload.get("question") or "").strip()
    subject = (payload.get("subject") or "").strip()
    chapter = (payload.get("chapter") or "").strip()
    language = (payload.get("language") or "en").strip()

    if not question:
        return (
            jsonify({"success": False, "error": "Field 'question' must be non-empty."}),
            400,
        )

    try:
        result = generate_ncert_answer(
            question=question,
            subject=subject,
            chapter=chapter,
            language=language,
        )
        return (
            jsonify(
                {
                    "success": True,
                    "answer": result["answer"],
                    "step_by_step": result["step_by_step"],
                    "simple_explanation": result["simple_explanation"],
                    "translated_response": result["translated_response"],
                }
            ),
            200,
        )

    except ValueError as exc:
        logger.warning("AI validation error: %s", exc)
        return jsonify({"success": False, "error": str(exc)}), 400

    except RuntimeError as exc:
        logger.error("AI runtime error: %s", exc)
        return jsonify({"success": False, "error": str(exc)}), 502

    except Exception as exc:
        logger.exception("AI failed")
        return jsonify({"success": False, "error": f"Unexpected error: {exc}"}), 500
