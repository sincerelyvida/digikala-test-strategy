# Product Search – Manual Test Cases Summary

This document summarizes the manual test cases for **Digikala Product Search**.  
Each test is categorized as **Positive**, **Negative**, or **Edge**.

---

## Positive Test Cases

**TC_Search_001 – Valid Search Query**  
- Ensure valid keyword returns products with title, price, and availability.

**TC_Search_002 – Multiple Pages of Results**  
- Validate pagination shows distinct product sets across pages.

**TC_Search_003 – Product Detail Link**  
- Confirm product in search results links correctly to detail page.

---

## Negative Test Cases

**TC_Search_004 – Invalid Characters**  
- Search with symbols/unsupported characters should return no results or error message.

**TC_Search_005 – Too Long Query**  
- Very long strings should not crash system, should return error/empty result.

**TC_Search_006 – SQL/Script Injection Attempt**  
- Queries with suspicious patterns should not break system.

**TC_Search_007 – Nonexistent Word**  
- Search for nonsense term should show no results.

---

## Edge Test Cases

**TC_Search_008 – Empty Query**  
- Submitting empty search should return no products or prompt user.

**TC_Search_009 – Leading/Trailing Spaces**  
- Ensure search handles extra whitespace correctly.

**TC_Search_010 – Diacritics and Emoji**  
- Queries with diacritics or emojis should not crash and handle gracefully.

**TC_Search_011 – Mixed Language Input**  
- Searching with a mix of Persian/English should return relevant results if possible.

---

## Notes
- Manual tests validate **functional correctness** and **robustness**.
- They serve as a foundation for automation (Pytest, Robot Framework).
- Any failures should be logged with actual vs. expected behavior.