FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    libglib2.0-0 \
&& rm -rf /var/lib/apt/lists/*

COPY . .

RUN pip install --no-cache-dir \
    flask \
    tensorflow==2.16.1 \
    tf-keras \
    pillow \
    numpy

EXPOSE 5000

CMD ["python", "app.py"]