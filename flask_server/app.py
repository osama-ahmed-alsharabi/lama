from flask import Flask, request, jsonify
from flask_cors import CORS
from PIL import Image
import os
import numpy as np

app = Flask(__name__)
CORS(app)

def get_dominant_color(image_path):
    """
    Extract the dominant color from an image using median color.
    """
    image = Image.open(image_path).convert('RGB')
    image = image.resize((50, 50))  # Resize for faster processing
    pixels = np.array(image)
    pixels = pixels.reshape(-1, 3)  # Flatten into list of RGB values
    median_color = np.median(pixels, axis=0)  # Calculate median color
    return tuple(int(color) for color in median_color)  # Convert to native Python int

def rgb_to_hv_single(R, G, B):
    """
    Convert RGB values to Hue (H) and Value (V).
    """
    R_normalized = R / 255.0
    G_normalized = G / 255.0
    B_normalized = B / 255.0
    V = max(R_normalized, G_normalized, B_normalized)
    min_rgb = min(R_normalized, G_normalized, B_normalized)
    delta = V - min_rgb

    if delta == 0:
        H = 0
    else:
        if V == R_normalized:
            H = 60 * ((G_normalized - B_normalized) / delta) % 6
        elif V == G_normalized:
            H = 60 * ((B_normalized - R_normalized) / delta + 2)
        else:
            H = 60 * ((R_normalized - G_normalized) / delta + 4)

    if H < 0:
        H += 360
    V_percent = V * 100
    return round(H, 2), round(V_percent, 2)

def classify_season(H, V):
    """
    Classify the season based on Hue (H) and Value (V).
    """
    H = round(H)
    if 81 <= H <= 329 and V > 50:
        return "Summer"
    elif (0 <= H <= 80 or 330 <= H <= 360) and V > 50:
        return "Spring"
    elif (0 <= H <= 80 or 330 <= H <= 360) and V <= 50:
        return "Autumn"
    elif 81 <= H <= 329 and V <= 50:
        return "Winter"
    else:
        return "Unknown Season"

@app.route('/analyze', methods=['POST'])
def analyze():
    """
    Handle image upload and return season classification.
    """
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({'error': 'Empty filename'}), 400

    # Save the uploaded file temporarily
    temp_dir = 'temp_uploads'
    os.makedirs(temp_dir, exist_ok=True)
    temp_path = os.path.join(temp_dir, file.filename)
    file.save(temp_path)

    try:
        # Get dominant color and classify season
        R, G, B = get_dominant_color(temp_path)
        H, V = rgb_to_hv_single(R, G, B)
        season = classify_season(H, V)

        # Clean up temporary file
        os.remove(temp_path)

        # Return JSON response
        return jsonify({
            'hue': float(H),  # Ensure float for JSON
            'value': float(V),  # Ensure float for JSON
            'season': season,
            'rgb': [int(R), int(G), int(B)]  # Ensure native Python int
        })
    except Exception as e:
        # Handle errors gracefully
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
#----------------------------------------------------
# from flask import Flask, request, jsonify
# from flask_cors import CORS
# import tensorflow as tf
# from PIL import Image
# import numpy as np
# import io
# import os
# from color_classifier import get_dominant_color, classify_season

# app = Flask(__name__)
# CORS(app)

# # Debugging: Check if the model file exists
# MODEL_PATH = 'model.h5'
# if not os.path.exists(MODEL_PATH):
#     raise FileNotFoundError(f"Model file '{MODEL_PATH}' not found.")

# # Load your trained model
# try:
#     # model.save('model.h5')
#     model = tf.keras.models.load_model(model.h5)
#     print("Model loaded successfully!")
# except Exception as e:
#     print(f"Error loading model: {e}")
#     raise

# def preprocess_image(image):
#     img = Image.open(image).convert('RGB')
#     img = img.resize((160, 160))
#     img_array = tf.keras.preprocessing.image.img_to_array(img)
#     img_array = tf.expand_dims(img_array, 0)
#     return img_array / 255.0

# @app.route('/predict_season', methods=['POST'])
# def predict_season():
#     file = request.files['image']
#     img_array = preprocess_image(file)
#     prediction = model.predict(img_array)
#     classes = ['Autumn', 'Spring', 'Summer', 'Winter']
#     return jsonify({'season': classes[np.argmax(prediction)]})

# @app.route('/check_match', methods=['POST'])
# def check_match():
#     file = request.files['image']
#     season = request.form['season']
    
#     # Save temporary image
#     temp_path = "temp.jpg"
#     file.save(temp_path)
    
#     # Get dominant color
#     dominant_color = get_dominant_color(temp_path)
#     R, G, B = dominant_color
    
#     # Classify
#     H, V = rgb_to_hv_single(R, G, B)
#     calculated_season = classify_season(H, V)
    
#     os.remove(temp_path)
#     return jsonify({
#         'match': calculated_season == season,
#         'calculated_season': calculated_season
#     })

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000)