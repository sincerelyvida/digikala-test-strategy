import os
from locust import HttpUser, task, between
from dotenv import load_dotenv

# ---- Env & defaults ---------------------------------------------------------
load_dotenv()

BASE_URL: str = os.getenv("DIGIKALA_BASE_URL", "https://api.digikala.com")
SEARCH_PATH: str = os.getenv(
    "DIGIKALA_SEARCH_PATH",
    "/v1/categories/training-entertainments-and-accessories/search/",
)
SEARCH_QUERY: str = os.getenv("SEARCH_QUERY", "گربه")

class DigikalaUser(HttpUser):
    wait_time = between(1, 3)  # seconds between requests

    base_path = SEARCH_PATH
    query = SEARCH_QUERY

    @task
    def search_products(self):
        params = {"q": self.query, "page": 1}
        headers = {
            "Accept": "application/json, text/plain, */*",
            "X-Web-Client": "desktop",
            "X-Web-Optimize-Response": "1",
            "User-Agent": "LocustLoadTest/1.0"
        }
        with self.client.get(self.base_path, params=params, headers=headers, catch_response=True) as response:
            if response.status_code != 200:
                response.failure(f"Unexpected status {response.status_code}")
            else:
                response.success()