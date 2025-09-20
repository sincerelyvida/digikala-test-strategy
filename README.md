# Digikala Test Strategy

## 📌 Project Overview
This repository contains the **test strategy and implementations** for the Digikala online shop.  
It demonstrates **manual test design, UI automation, API testing, and performance testing**.

---

## 📂 Repository Structure
```
digikala-test-strategy/
│── manual-tests/           # PDF test cases
│── automation-ui/          # Robot Framework + Selenium scripts
│── api-tests/              # Python API test scripts
│── performance-tests/      # Locust files + summary report
│── bug-reports/            # hypothetical bug reports
│── README.md               # Project documentation
```

---

## 📝 Manual Test Cases
- Located in `/manual-tests/` as **PDF file**.  
- The document contains **positive, edge, and negative test cases**.  
- Tests are written with **Gherkin-style steps** for clarity and consistency.  
- Covered feature include

---

## 🤖 Automated UI Tests (Selenium + Robot Framework)
- Located in `/automation-ui/`  
- Includes scenarios covering:  
  1. **Login** (successful and unsuccessful attempts)  
  2. **Add product to cart and proceed to checkout**  
  3. **Error handling** such as wrong credentials and too many login attempts  
- Uses a `.env` file for managing credentials securely.  
- Captures **screenshots in test results** for better debugging.  
- Supports **headless browser mode configurable via environment variables**.

---

## 🔗 API Tests (Python)
- Located in `/api-tests/`  
- Contains tests such as:  
  - `test_digikala_search.py` verifying search endpoint functionality  
  - Schema validation for API responses  
  - Pagination tests to verify correct page handling  
  - Product detail linkage tests ensuring search results link to correct product data  
- Uses environment variables for base URL and query parameters.

---

## 📊 Performance Tests
- Located in `/performance-tests/`  
- Implemented using **Locust** to simulate load on the search API endpoint.  
- Parameters include: number of users, spawn rate, and test duration.  
- Results are summarized in directory `README.md`, documenting:  
  - Test Scenario  
  - Load Profile (users, ramp-up, duration)  
  - Key Metrics (avg response time, percentiles, error rate, throughput)  
  - Observations on system stability and bottlenecks  
  - Conclusion on performance acceptability  

---

## 🐞 Bug Reports
- Located in `/bug-reports/` as PDF.  
- Includes:  
  - Title  
  - Steps to reproduce  
  - Expected result  
  - Actual result  
  - Severity  

---

## 🚀 How to Run

### Setup Environment
```bash
# Create a virtual environment
python -m venv venv

# Activate the environment
# On Linux/macOS
source venv/bin/activate
# On Windows
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

All commands can be executed from any directory by specifying explicit paths.
Read the README.md file of each directory for instructions.
---

## 📖 Notes
- Tests are **designed for demo purposes** on Digikala’s website.  
- All sensitive actions (e.g., real payments) are **mocked or stopped before completion** to avoid unintended transactions.  
- All scripts and test cases are **documented for clarity**.
