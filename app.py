from flask import Flask, request, jsonify, render_template
from PIL import Image
import io
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return "Please provide an image file", 400

    file = request.files['file']
    try:
        img = Image.open(file.stream)
    except Exception as e:
        return f"Error processing image: {str(e)}", 500

    # Example response, replace with actual prediction logic
    width, height = img.size
    return jsonify({'width': width, 'height': height})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=True)

