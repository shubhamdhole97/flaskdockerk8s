# Pull Base Python Image
FROM python:3.10-alpine AS builder

# Set Working Directory
WORKDIR /app

# Copy only requirements first to leverage Docker cache efficiently
COPY requirements.txt .

# Install dependencies
RUN pip3 install -r requirements.txt

# Copy application code separately
COPY app.py .

# Expose the port
EXPOSE 8000

# Define Entrypoint and Default Command
ENTRYPOINT ["python3"]
CMD ["app.py"]
