import os
os.environ['TF_USE_LEGACY_KERAS'] = '1'

import tensorflow as tf
from flask import Flask, request
from PIL import Image
import numpy as np
import io
import sys

from google import genai
from google.genai import types
import json

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

# Configure your API key (Get one free from Google AI Studio)
# Initialize the new Client.
# It's highly recommended to set this as an environment variable (GEMINI_API_KEY),
# but you can pass it directly for testing.
client = genai.Client(api_key="AIzaSyBK6MPP4z6KKbtrpWX1CKLhyj9SsJGNZt0")

@app.route('/generate-meal-plan', methods=['POST'])
def generate_meal_plan():
    user_data = request.json

# Construct a highly specific prompt for the LLM to generate a meal plan based on the user's profile.
    prompt = f"""
    You are an expert nutritionist AI. Generate a realistic 7-day meal plan (Breakfast, Lunch, Dinner)
    for the following user profile:

    - Age: {user_data.get('age')}
    - Gender: {user_data.get('gender')}
    - Weight: {user_data.get('weightKg')} kg
    - Height: {user_data.get('heightCm')} cm
    - BMI: {user_data.get('bmi')}
    - Activity Level: {user_data.get('activityLevel')}
    - Goal: {user_data.get('fitnessGoal')}
    - Goal Motivation: {user_data.get('goalMotivation')}
    - Sleep Quality: {user_data.get('sleepQuality')}
    - Speed of achieving the goal: {user_data.get('goalSpeed')}
    - Target Calories for a day: {user_data.get('dailyCalorieGoal')} kcal
    - Allergies: {', '.join(user_data.get('allergies', []))}
    - Medical Conditions: {', '.join(user_data.get('medicalConditions', []))}
    - Dietary Preferences: {', '.join(user_data.get('dietaryPreferences', []))}

    STRICT RULES:
    1. Health & Metrics First: Actively adapt the meals to the user's 'Medical Conditions' (e.g., low GI for diabetes, low sodium for hypertension), 'BMI', and 'Speed of achieving the goal'. If the goal speed is fast, prioritize high-satiety, nutrient-dense foods.
    2. Diverse but Simple Cuisine: Mix familiar Sri Lankan staples (like Red Rice, Dhal, String Hoppers, Fish Curry) with simple, easy-to-prep foods from other cultures (like Oatmeal, Greek Salad, Grilled Chicken Wraps, or Pasta).
    3. Realistic Naming: Keep recipe names very short and realistic (e.g., "String Hoppers with Dhal", "Grilled Chicken Salad", "Oats with Banana"). Do NOT prefix meals with "Sri Lankan" or use fancy, exaggerated names.
    4. Accurate Math: Ensure the mathematical values for calories and macronutrients are 100% realistic for a single human meal (e.g., 300 to 800 calories per meal). The sum of the daily meals MUST roughly match the Target Calories.
    5. Search Terms: Provide a simple, generic 'imageSearchTerm' (e.g., "Dhal Curry", "Chicken Wrap", "Pasta Tomato Sauce") for each meal to be used in an image API.

    You MUST return ONLY a valid JSON object matching this exact schema:
    {{
      "weeklyPlan": [
        {{
          "day": "Monday",
          "meals": [
            {{
              "mealType": "Breakfast",
              "recipeName": "String",
              "imageSearchTerm": "String",
              "prepTimeMin": 0,
              "calories": 0,
              "proteinG": 0,
              "carbsG": 0,
              "fatG": 0
            }}
          ]
        }}
      ]
    }}
    """

    try:
        # The new v2 syntax for generating content
        response = client.models.generate_content(
            model='gemini-2.5-flash',
            contents=prompt,
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
            )
        )
        return response.text, 200, {'Content-Type': 'application/json'}
    except Exception as e:
        print(f"LLM Error: {e}")
        return {"error": "Failed to generate meal plan"}, 500

if __name__ == '__main__':
    app.run(port=5000, debug=True)