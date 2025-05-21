FROM python:3.10-slim

WORKDIR /app

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source
COPY . .

# Expose Python backend port (adjust if needed)
EXPOSE 5000

CMD ["python", "app.py"]
