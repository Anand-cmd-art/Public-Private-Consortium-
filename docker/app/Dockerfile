FROM python:3.8-slim
WORKDIR /app

# Update and install system dependencies including libsystemd-dev.
RUN apt-get update && apt-get install -y \
    ninja-build \
    build-essential \
    libcurl4-openssl-dev \
    pkg-config \
    libcairo2-dev \
    libsystemd-dev

# Upgrade pip and install meson with the required version.
RUN pip install --upgrade pip
RUN pip install --upgrade "meson>=0.63.3"

# Copy requirements and install Python dependencies.
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
CMD ["python", "app.py"]
