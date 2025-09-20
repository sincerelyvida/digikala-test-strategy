# Digikala API Automated Tests

This directory contains automated API tests targeting Digikala’s search endpoint. The tests are designed to validate the correctness and consistency of the search API responses, ensuring reliable integration with Digikala's services.

---

## Test Coverage

The `test_digikala_search.py` file includes tests that verify:

- Schema validation of the search response to ensure the data structure meets expectations.
- Pagination consistency across search result pages.
- Product detail linkage by cross-referencing products from the search endpoint with the product detail endpoint.

---

## Running the Tests

To execute the tests, use `pytest` from the command line:

```bash
pytest api-tests/test_digikala_search.py
```

You can optionally set environment variables to customize the test behavior before running pytest:

```bash
DIGIKALA_BASE_URL=https://api.digikala.com \
DIGIKALA_SEARCH_PATH=/v1/categories/training-entertainments-and-accessories/search/ \
SEARCH_QUERY=گربه \
SEARCH_PAGE=1 \
HTTP_TIMEOUT_SECS=15 \
pytest api-tests/test_digikala_search.py
```

---

## Test Documentation and Outputs

All tests for the Digikala API are located in `test_digikala_search.py`. The purpose of this section is to explain what is being tested, how results are validated, and how to interpret outputs.

---

### Test Categories

1. **Schema Validation**
   - Confirms that the structure of the API response matches the expected schema (status code, `data`, and `products` list).
   - Uses `jsonschema` to ensure required fields (e.g., `id`, `title_fa`, `price`) are present and of the correct type.

2. **Pagination Consistency**
   - Ensures that requesting different pages of results (`page=1` vs `page=2`) returns distinct sets of product IDs.
   - Prevents duplicates between pages to guarantee reliable pagination.

3. **Product Detail Linkage**
   - Picks a product ID from the search results and calls the product detail endpoint.
   - Verifies that details (like `id`, `title_fa`, `status`) are consistent between the search response and the product detail response.

---

### Example Outputs

- **Passing test run**
  ```bash
  ============================= test session starts =============================
  collected 3 items

  api-tests/test_digikala_search.py ...                                    [100%]

  ============================== 3 passed in 4.21s ==============================
  ```

- **Failing test run**
  ```bash
  ============================= test session starts =============================
  collected 3 items

  api-tests/test_digikala_search.py .F.                                    [100%]

  =================================== FAILURES ==================================
  ________________________ test_pagination_two_pages_have_distinct_products ______
  AssertionError: Pagination did not change product set (ids overlap)
  ```

In case of failures, the output will clearly indicate which test failed and why (e.g., schema mismatch, duplicate product IDs, inconsistent product detail).


Configuration is managed via a `.env` file (loaded using `python-dotenv`). You can use the default values or override them as needed:

- `DIGIKALA_BASE_URL`: Base URL for the Digikala API (default: `https://api.digikala.com`)
- `DIGIKALA_SEARCH_PATH`: API path for the search endpoint (default: `/v1/categories/training-entertainments-and-accessories/search/`)
- `SEARCH_QUERY`: Search term used in queries (default: `گربه`)
- `SEARCH_PAGE`: Page number for pagination (default: `1`)
- `HTTP_TIMEOUT_SECS`: Timeout duration for HTTP requests in seconds (default: `15`)