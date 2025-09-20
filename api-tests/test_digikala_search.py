import os
from typing import Dict, Any, Iterable, Set

import requests
from dotenv import load_dotenv

# ---- Env & defaults ---------------------------------------------------------
load_dotenv()

BASE_URL: str = os.getenv("DIGIKALA_BASE_URL", "https://api.digikala.com")
SEARCH_PATH: str = os.getenv(
    "DIGIKALA_SEARCH_PATH",
    "/v1/categories/training-entertainments-and-accessories/search/",
)
SEARCH_QUERY: str = os.getenv("SEARCH_QUERY", "گربه")
SEARCH_PAGE: int = int(os.getenv("SEARCH_PAGE", 1))
TIMEOUT_SECS: int = int(os.getenv("HTTP_TIMEOUT_SECS", 15))

COMMON_HEADERS = {
    # Match what the site sends enough to get optimized JSON
    "X-Web-Client": "desktop",
    "X-Web-Optimize-Response": "1",
    "Accept": "application/json, text/plain, */*",
    "User-Agent": "pytest-client",
}

# ---- Helpers ----------------------------------------------------------------
def _search(session: requests.Session, q: str, page: int = 1) -> requests.Response:
    url = f"{BASE_URL.rstrip('/')}{SEARCH_PATH}"
    params = {"q": q, "page": page}
    return session.get(url, params=params, headers=COMMON_HEADERS, timeout=TIMEOUT_SECS)


def _has_any_keys(obj: Dict[str, Any], keys: Iterable[str]) -> bool:
    return any(k in obj for k in keys)


def _extract_product_ids(products: Iterable[Dict[str, Any]]) -> Set[str]:
    ids: Set[str] = set()
    for p in products:
        # Digikala often uses one of these; collect whichever exists
        for key in ("id", "dkp_id", "product_id"):
            if key in p and p[key] is not None:
                ids.add(str(p[key]))
                break
    return ids


def _find_products(payload: Any) -> list[dict]:
    """
    Try to locate a list of products in Digikala API responses.
    Handles common keys and nested dicts.
    """
    # If payload is a dict, try common keys first
    if isinstance(payload, dict):
        if isinstance(payload.get("products"), list):
            return payload["products"]
        for key in ("items", "results", "hits", "docs"):
            val = payload.get(key)
            if isinstance(val, list):
                return val
        # Recurse through nested dicts / lists
        for v in payload.values():
            if isinstance(v, dict):
                found = _find_products(v)
                if found:
                    return found
            elif isinstance(v, list) and v and isinstance(v[0], dict):
                return v
    # If payload itself is a list of dicts
    if isinstance(payload, list) and payload and isinstance(payload[0], dict):
        return payload
    return []

def _pager_page(data: dict) -> int | None:
    try:
        return int(data["data"]["pager"]["current_page"])
    except Exception:
        return None


def _product_uid(p: dict) -> str:
    """Stable unique id for overlap checks (id if present, else url.uri)."""
    for k in ("id", "dkp_id", "product_id"):
        if k in p and p[k] is not None:
            return str(p[k])
    # fallback: product URL path is stable per product
    u = (((p.get("url") or {}).get("uri")) or "").strip()
    return u or repr(p)  # last resort to avoid empty

# ---- Tests ------------------------------------------------------------------
def test_search_returns_200_and_json():
    """
    Calls the real Digikala search API and verifies we get HTTP 200 + JSON.
    """
    with requests.Session() as s:
        resp = _search(s, SEARCH_QUERY, SEARCH_PAGE)

    assert resp.status_code == 200, f"Unexpected status: {resp.status_code}"
    ctype = resp.headers.get("Content-Type", "")
    assert ctype.startswith("application/json"), f"Unexpected content type: {ctype}"


def test_search_basic_schema_and_products_present():
    """
    Validates top-level schema and confirms we have a non-empty list of products.
    Tolerant to minor schema variations.
    """
    with requests.Session() as s:
        resp = _search(s, SEARCH_QUERY, SEARCH_PAGE)
    data = resp.json()

    # Top-level keys that are generally present
    assert isinstance(data, dict), "Response must be a JSON object"
    assert "status" in data, "Missing 'status' at top level"
    assert "data" in data and isinstance(data["data"], dict), "Missing/invalid 'data' object"

    payload = data["data"]

    # Products presence (robust to schema variants)
    products = _find_products(payload)
    assert isinstance(products, list), "Could not locate a list of products in the response"
    assert len(products) > 0, "No products returned for the query"

    # Spot-check the first product's shape (tolerant: any-of key checks)
    first = products[0]
    assert isinstance(first, dict), "Each product must be an object"
    assert _has_any_keys(
        first,
        ("id", "dkp_id", "product_id"),
    ), "Product missing id-like field"
    assert _has_any_keys(
        first,
        ("title_fa", "title_en", "title", "product_title"),
    ), "Product missing title-like field"


def test_pagination_two_pages_have_distinct_products():
    with requests.Session() as s:
        r1 = _search(s, SEARCH_QUERY, 1).json()
        r2 = _search(s, SEARCH_QUERY, 2).json()

    # (Optional) sanity: confirm API acknowledges requested pages if pager exists
    p1_num = _pager_page(r1)
    p2_num = _pager_page(r2)
    if p1_num is not None and p2_num is not None:
        assert (p1_num, p2_num) == (1, 2), f"Pager mismatch: got ({p1_num}, {p2_num})"

    p1 = _find_products(r1.get("data", {}))
    p2 = _find_products(r2.get("data", {}))

    # Require both pages to have products if your claim holds
    assert p1 and p2, "Expected products on both pages, got an empty page."

    ids1 = { _product_uid(p) for p in p1 }
    ids2 = { _product_uid(p) for p in p2 }

    # Strict: no overlaps allowed
    overlap = ids1 & ids2
    assert not overlap, (
        f"Pagination repeated products across pages; overlap={len(overlap)}. "
        f"Sample: {sorted(list(overlap))[:5]}"
    )