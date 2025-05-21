from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/analyze", methods=["POST"])
def analyze_script():
    data = request.get_json()
    # For demonstration, just echo the received data + fake analysis result
    script_content = data.get("script", "")
    result = {
        "length": len(script_content),
        "message": "Script analyzed successfully."
    }
    return jsonify(result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
