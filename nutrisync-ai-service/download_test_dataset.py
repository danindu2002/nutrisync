import os
import requests
from PIL import Image
from io import BytesIO
import time

# CONFIG
CLASSES_FILE = 'classes.txt'
OUTPUT_DIR = 'dataset/test'
IMAGES_PER_CLASS = 5

# Use LoremFlickr to get raw images by keyword. 
# We pass an 'index' to act as a cache-buster so we don't get the exact same image 10 times.
def get_image_url(query, index):
    # Format the query to remove spaces, as LoremFlickr prefers comma-separated keywords
    formatted_query = query.replace(' ', ',')
    return f"https://loremflickr.com/224/224/{formatted_query}?lock={index}"

def download_images():
    # Make sure classes.txt actually exists before trying to read it
    if not os.path.exists(CLASSES_FILE):
        print(f"Error: {CLASSES_FILE} not found. Please create it first.")
        return

    with open(CLASSES_FILE, 'r') as f:
        # Ignore empty lines
        classes = [line.strip() for line in f.readlines() if line.strip()]

    for cls in classes[:10]:  
        class_dir = os.path.join(OUTPUT_DIR, cls)
        os.makedirs(class_dir, exist_ok=True)

        print(f"\nDownloading images for: {cls}")

        for i in range(IMAGES_PER_CLASS):
            try:
                # Pass 'i' to get a unique image each time
                url = get_image_url(cls, i)
                
                # Added a User-Agent header, which sometimes helps prevent automated requests from being blocked
                headers = {'User-Agent': 'Mozilla/5.0'}
                response = requests.get(url, headers=headers, timeout=10)
                
                # Check if the request was actually successful before trying to parse the image
                response.raise_for_status() 

                img = Image.open(BytesIO(response.content)).convert('RGB')
                
                # LoremFlickr already returns 224x224 based on our URL, but keeping this is a safe fallback
                img = img.resize((224, 224))

                img.save(os.path.join(class_dir, f"{cls}_{i}.jpg"))
                print(f"Saved {cls}_{i}.jpg")

                time.sleep(1)  # rate limits

            except Exception as e:
                print(f"Error downloading {cls}_{i}: {e}")

        print(f"{cls} done")

    print("\nTest dataset created!")

if __name__ == "__main__":
    download_images()