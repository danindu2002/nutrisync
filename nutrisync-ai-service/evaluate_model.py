import os
os.environ['TF_USE_LEGACY_KERAS'] = '1'

import tensorflow as tf
import numpy as np
from sklearn.metrics import classification_report, f1_score
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import matplotlib.pyplot as plt

# Paths
MODEL_PATH = 'model/Food_Vision_Model.h5'
TEST_DIR = 'dataset/test'
CLASSES_FILE = 'classes.txt'

# Load model
model = tf.keras.models.load_model(MODEL_PATH, compile=False)

# Load the exact classes the model was trained on
with open(CLASSES_FILE, 'r') as f:
    # Read classes and remove empty lines
    training_classes = [line.strip() for line in f.readlines() if line.strip()]

# Image generator
datagen = ImageDataGenerator()

test_generator = datagen.flow_from_directory(
    TEST_DIR,
    target_size=(224, 224),
    batch_size=32,
    class_mode='categorical',
    classes=training_classes,
    shuffle=False
)

# Predictions
predictions = model.predict(test_generator)
y_pred = np.argmax(predictions, axis=1)
y_true = test_generator.classes

# F1 Score
f1 = f1_score(y_true, y_pred, average='weighted')
print(f"\nF1 Score: {round(f1, 4)}")

# Full Report (Filtered)
print("\nClassification Report (Active Classes Only):")
# Find the indices of classes that actually have images OR were guessed by the model
active_indices = np.unique(np.concatenate([y_true, y_pred]))
# Get the actual string names for only those active indices
active_names = [training_classes[i] for i in active_indices]
# Print the report using only the active labels and names
print(classification_report(
    y_true, 
    y_pred, 
    labels=active_indices, 
    target_names=active_names, 
    zero_division=0
))