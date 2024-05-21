FROM python:3.7-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libhdf5-dev \
    && rm -rf /var/lib/apt/lists/*

# Set HDF5_DIR environment variable
ENV HDF5_DIR=/usr/lib/x86_64-linux-gnu/hdf5/serial/

# Upgrade pip and install h5py
RUN pip install --upgrade pip setuptools wheel
RUN pip install h5py
RUN pip install flask
RUN pip install tensorflow
RUN pip install tensorflow-hub
RUN pip install pillow
RUN pip install numpy
RUN pip install flask_cors
# Create a non-root user and set permissions
RUN useradd -m appuser
WORKDIR /app
COPY . /app
RUN chown -R appuser /app

# Switch to the non-root user
USER appuser

# Run the application
CMD ["python", "app.py"]

