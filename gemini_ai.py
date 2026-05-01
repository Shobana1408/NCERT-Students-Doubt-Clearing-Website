"""
Gemini API integration: structured NCERT-style responses.
"""

from __future__ import annotations

import json
import re
from typing import Any

import google.generativeai as genai

from app.config import Config
from app.prompts import build_ncert_doubt_prompt


def _extract_response_text(response: Any) -> str:
    """Get concatenated text from a Gemini response (handles blocked/edge cases)."""
    try:
        t = getattr(response, "text", None)
        if t:
            return t.strip()
    except ValueError:
        pass

    parts: list[str] = []
    for cand in getattr(response, "candidates", None) or []:
        content = getattr(cand, "content", None)
        for part in getattr(content, "parts", None) or []:
            ptext = getattr(part, "text", None)
            if ptext:
                parts.append(ptext)
    return "".join(parts).strip()


def _strip_json_fence(text: str) -> str:
    """Remove optional ```json ... ``` wrappers from model output."""
    t = text.strip()
    if t.startswith("```"):
        t = re.sub(r"^```(?:json)?\s*", "", t, flags=re.IGNORECASE)
        t = re.sub(r"\s*```$", "", t)
    return t.strip()


def _parse_structured_json(text: str) -> dict[str, Any]:
    """Parse JSON object from model text; raise ValueError on failure."""
    cleaned = _strip_json_fence(text)
    try:
        data = json.loads(cleaned)
    except json.JSONDecodeError as exc:
        raise ValueError(f"Model did not return valid JSON: {exc}") from exc

    if not isinstance(data, dict):
        raise ValueError("Model JSON must be an object.")

    required = ("answer", "step_by_step", "simple_explanation", "translated_response")
    missing = [k for k in required if k not in data]
    if missing:
        raise ValueError(f"Missing keys in model output: {missing}")

    out = {}
    for k in required:
        val = data[k]
        if val is None:
            out[k] = ""
        elif isinstance(val, str):
            out[k] = val.strip()
        else:
            out[k] = str(val).strip()

    return out


def generate_ncert_answer(
    question: str,
    subject: str,
    chapter: str,
    language: str,
) -> dict[str, str]:
    """
    Call Gemini with the NCERT prompt and return structured string fields.

    Raises:
        RuntimeError: configuration or API errors.
        ValueError: empty question or invalid model JSON.
    """
    if not question or not str(question).strip():
        raise ValueError("Question must not be empty.")

    Config.validate_gemini_config()
    genai.configure(api_key=Config.GEMINI_API_KEY)

    model = genai.GenerativeModel(Config.GEMINI_MODEL)
    prompt = build_ncert_doubt_prompt(
        question=str(question).strip(),
        subject=(subject or "").strip(),
        chapter=(chapter or "").strip(),
        language=(language or "en").strip(),
    )

    try:
        response = model.generate_content(
            prompt,
            generation_config={
                "temperature": 0.35,
                "max_output_tokens": 8192,
            },
        )
    except Exception as exc:
        raise RuntimeError(f"Gemini API request failed: {exc}") from exc

    text = _extract_response_text(response)
    if not text.strip():
        # Some safety blocks leave empty text
        block = getattr(response, "prompt_feedback", None)
        reason = getattr(block, "block_reason", None) if block else None
        raise RuntimeError(
            "Empty response from Gemini."
            + (f" Block reason: {reason}" if reason else "")
        )

    parsed = _parse_structured_json(text)
    return {
        "answer": parsed["answer"],
        "step_by_step": parsed["step_by_step"],
        "simple_explanation": parsed["simple_explanation"],
        "translated_response": parsed["translated_response"],
    }
