
from fastapi import FastAPI, HTTPException

app = FastAPI(
    title="Enterprise Weather API",
    version="1.0.0"
)

# Sample weather data for initial testing
weather_data = {
    "jaipur": {"temperature": 32, "condition": "Sunny"},
    "delhi": {"temperature": 30, "condition": "Cloudy"},
    "mumbai": {"temperature": 28, "condition": "Rainy"}
}

@app.get("/")
def home():
    return {"message": "Weather API is running successfully!"}

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.get("/weather")
def get_weather(city: str):
    city_key = city.strip().lower()

    if city_key not in weather_data:
        raise HTTPException(
            status_code=404,
            detail="City not found"
        )

    return {
        "city": city_key.title(),
        **weather_data[city_key],
        "data_type": "sample"
    }
