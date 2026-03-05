import os
os.environ['TF_USE_LEGACY_KERAS'] = '1'

import tensorflow as tf
from flask import Flask, request
from PIL import Image
import numpy as np
import io
import sys

app = Flask(__name__)

# 1. Load the model from your folder
MODEL_PATH = 'model/Food_Vision_Model.h5'
try:
    model = tf.keras.models.load_model(MODEL_PATH, compile=False)
    print("Model loaded successfully with Keras 2 backend!")
except Exception as e:
    print(f"CRITICAL ERROR: Failed to load model: {e}")
    sys.exit(1)

# 2. Load the classes from text file
with open('classes.txt', 'r') as f:
    class_names = [line.strip() for line in f.readlines()]

def preprocess_image(image_bytes):
    # Convert bytes to PIL Image and ensure it's RGB
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')

    # RESIZE: Most Food-101 models use 224x224.
    img = img.resize((224, 224))

    # Convert to array BUT DO NOT divide by 255.0
    img_array = np.array(img)

    # Add a 'batch' dimension (TensorFlow expects [1, 224, 224, 3])
    return np.expand_dims(img_array, axis=0)

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return "No file uploaded", 400

    file_bytes = request.files['file'].read()

    # Predict!
    processed_img = preprocess_image(file_bytes)
    predictions = model.predict(processed_img)

    # Get the index of the highest probability
    predicted_idx = np.argmax(predictions[0])
    food_label = class_names[predicted_idx]

    print(f"AI Identified: {food_label}")
    return food_label

if __name__ == '__main__':
    app.run(port=5000, debug=True)