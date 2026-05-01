from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()

# Debug: check if API key is loaded
print("GEMINI_API_KEY =", os.getenv("GEMINI_API_KEY"))

from app import create_app

app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)