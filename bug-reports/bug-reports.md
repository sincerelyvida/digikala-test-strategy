# Bug Reports

## Bug Report 1
**Title:** Search suggestions list fails to update when query changes quickly  

**Severity:** Major  
**Priority:** Medium  
**Component/Area:** Product Search → Autocomplete Suggestions  

**Environment:**  
- Browser: Chrome 139 / macOS 13.6  
- URL: https://www.digikala.com/  

**Preconditions:**  
- User is logged in or logged out, homepage loaded.  
- Search bar is visible and functional.  

**Test Data:**  
- Any fast-typed query (e.g., `iph` followed by `iphone`).  

**Steps to Reproduce:**  
1. Click inside the search bar.  
2. Type quickly: `iph` → pause 0.5s → type `one`.  
3. Observe the suggestion dropdown.  

**Expected Result:**  
- Suggestions refresh in real time to match the updated query (`iphone`).  
- Outdated results for `iph` are discarded.  

**Actual Result:**  
- Dropdown freezes with outdated results (`iph`).  
- User must blur/focus or press Enter to refresh.  

**Impact / Risk:**  
- Users may assume no results exist and abandon the search.  
- Creates friction in the main shopping funnel.  

**Workaround:**  
- Pressing Enter reloads results, but suggestions remain stale.  

---

## Bug Report 2
**Title:** Adding multiple items to cart quickly results in inconsistent cart count badge  

**Severity:** High  
**Priority:** High  
**Component/Area:** Shopping Cart → Add to Cart Button / Header Badge  

**Environment:**  
- Browser: Chrome 139 / macOS 13.6  
- URL: https://www.digikala.com/product/...  

**Preconditions:**  
- User logged in.  
- Product page accessible and marketable.  

**Steps to Reproduce:**  
1. Open a product detail page.  
2. Click **Add to Cart**.  
3. Immediately click it again before the confirmation toast disappears.  
4. Observe the cart badge count in the header.  

**Expected Result:**  
- Cart badge increases by 2, matching the actual items added.  
- Backend and UI remain consistent.  

**Actual Result:**  
- Cart badge increments only once (+1).  
- On the cart page, correct count (+2) is shown.  
- UI and backend are inconsistent.  

**Impact / Risk:**  
- Customers may think only one item was added and retry, inflating orders.  
- Causes trust issues with cart accuracy.  

**Workaround:**  
- Refreshing page/cart syncs the count.  