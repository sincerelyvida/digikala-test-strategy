# env_vars.py
from dotenv import load_dotenv
import os

load_dotenv()  # reads .env in current dir

BASE_URL = os.getenv("BASE_URL", "https://www.digikala.com/")
USERNAME = os.getenv("USERNAME", "")
PASSWORD = os.getenv("PASSWORD", "")
SEARCH_QUERY = os.getenv("SEARCH_QUERY", "گربه")

