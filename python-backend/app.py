import os
from flask import Flask, request, jsonify
import logging

app = Flask(__name__)

API_KEY = os.getenv("PYTHON_API_KEY", "supersecretpythonkey")

logging.basicConfig(level=logging.INFO)

def analyze_script(script):
    suspicious_keywords = ['eval', 'exec', 'Function', 'require']
    issues = [kw for kw in suspicious_keywords if kw in script]
    return {
        "length": len(script),
        "suspicious_keywords": issues,
        "message": "Script analyzed successfully."
    }

@app.before_request
def check_api_key():
    key = request.headers.get("X-API-Key")
    if key != API_KEY:
        logging.warning(f"Unauthorized access attempt from {request.remote_addr}")
        return jsonify({"error": "Unauthorized"}), 401

@app.route("/analyze", methods=["POST"])
def analyze():
    data = request.get_json()
    script = data.get("script", "")
    logging.info(f"Analyzing script of length {len(script)}")
    result = analyze_script(script)
    return jsonify(result)

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
