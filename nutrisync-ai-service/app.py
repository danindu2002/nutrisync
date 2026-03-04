import tensorflow as tf
from flask import Flask, request
from PIL import Image
import numpy as np
import io

app = Flask(__name__)

# 1. Load the model from your folder
MODEL_PATH = 'model/Food_Vision_Model.h5'
try:
    # We wrap the loading in a custom_object_scope to handle the TFOpLambda error
    with custom_object_scope({'TFOpLambda': tf.keras.layers.Lambda}):
        model = tf.keras.models.load_model(MODEL_PATH, compile=False)
    print("Model loaded successfully with custom scope!")
except Exception as e:
    print(f"Error loading model: {e}")

# 2. Load the classes from your text file
with open('classes.txt', 'r') as f:
    class_names = [line.strip() for line in f.readlines()]

def preprocess_image(image_bytes):
    # Convert bytes to PIL Image and ensure it's RGB
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')

    # RESIZE: Most Food-101 models use 224x224.
    # If your model fails, try changing this to 299x299.
    img = img.resize((224, 224))

    # Convert to array and Normalize (0 to 1)
    img_array = np.array(img) / 255.0

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