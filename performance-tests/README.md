# Digikala API Load Test (Locust)

This directory contains a **Locust-based load test** for the Digikala search API.  
It simulates multiple users searching for products to evaluate system performance under load.

---

## Files
- `locustfile.py` → Defines the load test behavior:
  - Simulates users sending GET requests to the Digikala search API.
  - Uses environment variables for base URL, search path, and query.
  - Includes request validation (fails if status ≠ 200).

---

## Running the Load Test

To run the load test, ensure you have Locust installed (`pip install locust`), then execute:

```bash
locust -f performance-tests/locustfile.py \
  --host=https://api.digikala.com \
  --headless -u 50 -r 10 --run-time 2m \
  --html performance-tests/results/locust-report.html \
  --csv performance-tests/results/locust-stats
```

This will start a web interface (by default at `http://localhost:8089`) where you can configure the number of users and spawn rate to begin the test.

### Configuring Environment Variables

Before running the test, you can set the following environment variables to customize the test parameters:

- `BASE_URL`: The base URL of the Digikala API (default if not set).
- `SEARCH_PATH`: The API endpoint path for searching.
- `SEARCH_QUERY`: The search term to use in requests.

Example:

```bash
export BASE_URL="https://api.digikala.com"
export SEARCH_PATH="/v1/products/search"
export SEARCH_QUERY="laptop"
```

### Test Results and Reports

During and after the test, Locust provides real-time statistics including:

- Requests per second
- Response times (min, max, average, percentiles)
- Failure rates
- Number of active users

These metrics help identify performance bottlenecks, latency issues, and system stability under load.

### Interpreting System Behavior Under Pressure

By analyzing the results, you can determine how the Digikala API behaves as the number of concurrent users increases. Look for:

- Increased response times or timeouts indicating strain.
- Error rates rising which may point to capacity limits.
- Consistent performance suggesting good scalability.

This information is valuable for optimizing infrastructure and ensuring a smooth user experience under heavy traffic.
