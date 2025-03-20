FROM python:3.8-slim
WORKDIR /app

# Update and install system dependencies, including additional packages for building extensions.
RUN apt-get update && apt-get install -y \
    ninja-build \
    build-essential \
    python3-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libcairo2-dev \
    libsystemd-dev \
    libgirepository1.0-dev \
    libdbus-1-dev \
    libdbus-glib-1-dev \
    libffi-dev \
    libssl-dev


EXPOSE 5000
# This is to ensure that pycurl is built with the correct SSL library.
 ENV PYCURL_SSL_LIBRARY=openssl 
 ENV FLASK_APP=app.py
 ENV FLASK_RUN_HOST=0.0.0.0
# Upgrade pip and install meson with the required version.

RUN pip install --upgrade pip
RUN pip install --upgrade "meson>=0.63.3"

# Copy requirements and install Python dependencies.
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
CMD ["python","app.py","flask", "run"]