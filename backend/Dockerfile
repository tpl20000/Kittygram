# Use an official Python image as the base
FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .
RUN echo requirements.txt

# Install the dependencies
RUN pip install -r requirements.txt --no-cache-dir

# Copy the application code
COPY . .

# Run the command to start the server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "kittygram_backend.wsgi"]