# NCERT Doubt Solver — Flask microservice

REST API for OCR (Tesseract) and NCERT-style answers (Google Gemini).

## Prerequisites

- Python 3.10+
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) installed and on your `PATH` (required for `/ocr`)

### Windows (Tesseract)

Install the Windows installer from the [UB Mannheim builds](https://github.com/UB-Mannheim/tesseract/wiki) or use `choco install tesseract`. If `tesseract` is not on PATH, set:

```text
setx TESSDATA_PREFIX "C:\Program Files\Tesseract-OCR\tessdata"
```

(Adjust path if your install location differs.) You may also need to set `pytesseract.pytesseract.tesseract_cmd` in code if Tesseract is not in PATH.

### Linux

```bash
sudo apt install tesseract-ocr
```

### macOS

```bash
brew install tesseract
```

## Setup

1. Create a virtual environment and install dependencies:

```bash
cd ncert-doubt-flask-service
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

On Windows, if `python` is not on your PATH, use the launcher: `py -3 -m venv .venv` and `py -3 run.py`.

2. Copy `.env.example` to `.env` and set your key:

```bash
copy .env.example .env
```

Edit `.env`:

```text
GEMINI_API_KEY=your_actual_key
```

3. Run the server:

```bash
python run.py
```

Or:

```bash
flask --app run:app run --host 0.0.0.0 --port 5000
```

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Health check (plain text `ok`) |
| POST | `/ocr` | `multipart/form-data` with field `file` or `image` |
| POST | `/ai` | JSON: `question`, `subject`, `chapter`, `language` |

### Example: OCR

```bash
curl -X POST -F "file=@question.png" http://127.0.0.1:5000/ocr
```

### Example: AI

```bash
curl -X POST http://127.0.0.1:5000/ai ^
  -H "Content-Type: application/json" ^
  -d "{\"question\":\"What is photosynthesis?\",\"subject\":\"Science\",\"chapter\":\"Life Processes\",\"language\":\"hi\"}"
```

## Production

Use a production WSGI server (e.g. `gunicorn` on Linux, `waitress` on Windows) and disable Flask `debug=True`.
