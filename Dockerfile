
# Step 1: Use a lightweight Python base image
FROM python:3.12-slim

# Step 2: Define working directory inside container
WORKDIR /app

# Step 3: Set Python environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Step 4: Copy dependency list
COPY requirements.txt .

# Step 5: Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 6: Copy our application code
COPY app/ ./app/

# Step 7: Create an unprivileged user
RUN useradd --create-home --uid 10001 appuser
USER appuser

# Step 8: Document the application port
EXPOSE 8000

# Step 9: Start FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
