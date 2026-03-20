import os
os.environ['TF_USE_LEGACY_KERAS'] = '1'

import tensorflow as tf
from flask import Flask, request
from PIL import Image
import numpy as np
import io
import sys

# Load the environment variables from the .env file
from dotenv import load_dotenv
from google import genai
from google.genai import types
import json

load_dotenv()
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

api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    print("CRITICAL ERROR: GEMINI_API_KEY not found in .env file!")
    sys.exit(1)

client = genai.Client(api_key=api_key)

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

@app.route('/simulate-impact', methods=['POST'])
def simulate_impact():
    user_data = request.json

    prompt = f"""
    You are an expert AI health and fitness predictive engine. 
    The user is starting a new diet and workout plan. Calculate a realistic health projection for {user_data.get('months', 6)} months in the future.

    Current User Profile:
    - Age: {user_data.get('age')}
    - Gender: {user_data.get('gender')}
    - Current Weight: {user_data.get('weightKg')} kg
    - Height: {user_data.get('heightCm')} cm
    - Current BMI: {user_data.get('bmi')}
    - Target Daily Calories: {user_data.get('dailyCalorieGoal')} kcal
    - Current Body Fat: {user_data.get('bodyFatPercent', 27)}%

    STRICT RULES:
    1. Calculate realistic weight loss based on standard safe medical guidelines (e.g., losing 0.5 to 1 kg per week).
    2. Recalculate the future BMI based on the projected future weight and their current height.
    3. Calculate the difference (change) between current and projected metrics.
    4. Provide realistic body fat and waist-to-hip ratio improvements.

    You MUST return ONLY a valid JSON object matching this exact schema:
    {{
      "projectedBmi": 0.0,
      "projectedWeightKg": 0.0,
      "projectedBodyFatPercent": 0,
      "waistToHipRatio": 0.0,
      "expectedConsistencyLevel": "String (e.g., High, Medium)",
      "bmiChange": 0.0,
      "weightChangeKg": 0.0,
      "bodyFatChangePercent": 0
    }}
    """

    try:
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
        return {"error": "Failed to simulate health impact"}, 500
        
@app.route('/risk-prediction', methods=['POST'])
def risk_prediction():
    user_data = request.json
    meal_logs = format_meal_logs(user_data.get('mealLogList'))

    prompt = f"""
    You are a nutrition and health risk analysis AI.

    Your task is to analyze a user's health profile, dietary habits, and logged meals to predict potential future health risks if the current habits continue.

    You MUST return the response ONLY in valid JSON format using the following structure:

    {{
        "riskPredictionList":[
          {{
            "predictedRisk": "",
            "reasonTitle": "",
            "probability": "",
            "warning": "",
            "icon": "",
            "contributedMeals": [
              {{
                "mealLogId": "",
                "contribution": ""
              }}
            ]
          }}
        ],
        "mealSwapList": [
            {{
              "riskyMealName": "",
              "riskyMealFact": "",
              "healthyMealName": "",
              "healthyMealFact": ""
            }}
        ]
    }}

    IMPORTANT RULES

    1. Output MUST be strictly valid JSON.
    2. Do NOT include explanations outside JSON.
    3. Return multiple risks if applicable.
    4. If no meaningful risk is found, return an empty list [].
    5. predictedRisk = name of the possible future health condition.
    6. reasonTitle = short cause summary (example: "Type 2 Diabetes – genetics and high carbohydrate intake").
    7. probability = estimated likelihood of the risk occurring within the next 1–5 years.
    8. probability must be expressed as a percentage (example: "35%").
    9. warning must clearly explain why the user's current habits increase the risk.
    10. icon should be a matching condition for the risk from the list[cardio, diabetes, obesity, hypertension, calorie_imbalance, other]. If no matching condition for the risk, set condition "other".
    11. contributedMeals must list meal logs that contributed to the risk.

    Meal contribution rules:
    - Insert mealLogId from MealLogDTO's logId to identify contributed meal.
    - contribution should describe how the meal contributes to the risk.
    - Include only meals that meaningfully influence the risk.

    -----------------------------------------------------

    NUTRITION INTERPRETATION RULES

    Food data notes:
    - foodMaster = macros represent nutrient values per 100g.
    - totalProtein = protein consumed based on eaten quantity (grams).
    - totalCarbs = carbohydrates consumed based on eaten quantity (grams).
    - totalCalories = calories consumed based on eaten quantity (kcal).
    - consumedQuantity = amount eaten in grams.

    -----------------------------------------------------

    RISK ANALYSIS FACTORS

    During analysis consider:

    • BMI
    • age
    • gender
    • activity level
    • sleep quality
    • dietary preferences
    • allergies
    • medical conditions
    • calorie intake
    • carbohydrate intake
    • sugar intake
    • fat intake
    • sodium intake
    • cholesterol intake
    • nutrient deficiencies
    • meal timing consistency

    -----------------------------------------------------

    PROBABILITY CALCULATION MODEL

    Estimate probability using the following weighted factors:

    Medical Condition Factor (0–35%)
    - existing diseases increasing risk

    Diet Composition Factor (0–30%)
    - high carbs, sugars, fats, sodium, or poor macro balance

    BMI Factor (0–15%)
    - overweight or underweight risk

    Lifestyle Factor (0–10%)
    - poor sleep or low physical activity

    Meal Pattern Factor (0–10%)
    - irregular meals or unhealthy patterns

    Total probability = sum of the above factors.

    Clamp the result between 0% and 100%.

    Interpretation guideline:

    0–20% = Unlikely
    21–40% = Possible
    41–60% = Moderate risk
    61–80% = Likely
    81–100% = Very likely

    -----------------------------------------------------

    RISK PREDICTION GUIDELINES

    Predict possible risks within the next {user_data.get('predictionPeriod')} years if habits continue.

    Focus on risks such as:

    • diabetes complications
    • cardiovascular disease
    • hypertension
    • obesity
    • metabolic syndrome
    • high cholesterol
    • high sodium related risks
    • nutrient deficiencies
    • protein deficiency
    • calorie imbalance

    -----------------------------------------------------

    MEAL ANALYSIS

    Evaluate each meal log.

    Only include meals that significantly contribute to the predicted risk.

    -----------------------------------------------------

    USER DATA

    - Age: {user_data.get('age')}
    - Gender: {user_data.get('gender')}
    - Weight: {user_data.get('weightKg')} kg
    - Height: {user_data.get('heightCm')} cm
    - BMI: {user_data.get('bmi')}
    - Activity Level: {user_data.get('activityLevel')}
    - Sleep Quality: {user_data.get('sleepQuality')}
    - Target Calories for a day: {user_data.get('dailyCalorieGoal')} kcal
    - Allergies: {', '.join(user_data.get('allergies', []))}
    - Medical Conditions: {', '.join(user_data.get('medicalConditions', []))}
    - Dietary Preferences: {', '.join(user_data.get('dietaryPreferences', []))}

    MEAL LOGS OF THE USER
    {meal_logs}

    -----------------------------------------------------

    TOP UNHEALTHY MEAL IDENTIFICATION

    Identify up to 3 most unhealthy meals from MEAL_LOG_ID_TABLE.

    Rank meals based on:
    - high carbohydrates (especially for diabetes)
    - high calories vs daily goal
    - high sugar
    - high sodium
    - high fat
    - mismatch with dietaryPreferences
    - conflicts with medicalConditions

    Select the TOP 1–3 meals that contribute most to health risks.

    -----------------------------------------------------------------

    HEALTHY SWAP REQUIREMENTS

    The healthy meal must:
    - reduce at least one major risk factor (carbs, sugar, sodium, fat)
    - provide better nutrient balance
    - not introduce new health risks

    -----------------------------------------------------------------

    MEAL SWAP ID RULES

    - riskyMealName MUST match to meal from MEAL_LOGS
    - Do NOT generate new risky meal names
    - Only use meals identified as unhealthy

    -----------------------------------------------------------------

    EXPLANATION RULES

    riskyMealFact:
    - explain why the meal is unhealthy

    healthyMealFact:
    - explain why the replacement is better
    - reference improved nutrients (e.g., lower carbs, higher fiber)

    -----------------------------------------------------------------

    MEAL SWAP GENERATION RULES

    For each selected risky meal:

    1. Provide a healthier alternative meal.
    2. The alternative MUST:
       - align with dietaryPreferences
       - respect allergies (strictly avoid allergens)
       - be suitable for medicalConditions
       - improve nutritional balance (lower carbs, sugar, sodium, etc.)

    3. Keep swaps realistic (not extreme or unrealistic meals).
    4. Maintain similar meal context (e.g., lunch → lunch).

    MEAL SWAP TASK

    Based on the identified risks and meal analysis:

    1. Identify top unhealthy meals.
    2. Generate healthy alternatives.

    -------------------------------------

    OUTPUT REQUIREMENTS

    - Include both:
      - riskPredictionList
      - mealSwapList
    - If no unhealthy meals found, return empty mealSwapList: []

    -------------------------------------

    Now analyze the user data and return the JSON response.
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
        return {"error": "Failed to predict risk"}, 500

def format_meal_logs(meal_logs):
    formatted = ""

    for meal in meal_logs:
        fm = meal["foodMaster"]

        formatted += f"""
    MealLog:
    id: {meal["logId"]}
    mealTime: {meal["mealTime"]}
    foodName: {meal["foodName"]}
    consumedQuantity_g: {meal["consumedQuantity"]}

    NutritionTotals:
    calories_kcal: {meal["totalCalories"]}
    protein_g: {meal["totalProtein"]}
    carbs_g: {meal["totalCarbs"]}

    FoodMasterPer100g:
    name: {fm["name"]}
    category: {fm["category"]}
    calories_kcal: {fm["caloriesInKcal"]}
    protein_g: {fm["proteinInG"]}
    carbs_g: {fm["carbohydratesInG"]}
    fat_g: {fm["totalFatsInG"]}
    fiber_g: {fm["fiberInG"]}
    sugar_g: {fm["sugarsInG"]}
    sodium_mg: {fm["sodiumInMg"]}
    cholesterol_mg: {fm["cholesterolInMg"]}
    water_g: {fm["waterInG"]}

    Notes:
    {meal.get("notes","")}
    """
    return formatted
        
if __name__ == '__main__':
    app.run(port=5000, debug=True)