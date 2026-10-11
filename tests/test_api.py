
import unittest
from fastapi import HTTPException

from app.main import home, health, get_weather


class TestWeatherAPI(unittest.TestCase):

    def test_home(self):
        result = home()
        self.assertEqual(
            result["message"],
            "Weather API is running successfully!"
        )

    def test_health(self):
        result = health()
        self.assertEqual(result["status"], "healthy")

    def test_weather_jaipur(self):
        result = get_weather("Jaipur")
        self.assertEqual(result["city"], "Jaipur")
        self.assertEqual(result["temperature"], 32)

    def test_case_insensitive(self):
        result = get_weather("DELHI")
        self.assertEqual(result["city"], "Delhi")

    def test_invalid_city(self):
        with self.assertRaises(HTTPException) as context:
            get_weather("Atlantis")

        self.assertEqual(context.exception.status_code, 404)


if __name__ == "__main__":
    unittest.main()
