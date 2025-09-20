
# Login Tests

This directory contains Robot Framework suites for testing **Digikala login flows**.

---

## Structure

- `login.robot` → Shared **resource file** with locators, variables, and reusable keywords.
- `login_success.robot` → Suite for **positive login** with valid credentials. Tagged as `smoke login`.
- `login_failure.robot` → Suite for **negative login** with invalid credentials. Tagged as `regression login`.

---

## Running the Suites

### Successful Login
```bash
robot \
  --variablefile env_vars.py \
  --outputdir automation-ui/login/results/login/success \
  --output output.xml \
  --log log.html \
  --report report.html \
  automation-ui/login/login_success.robot
```

### Unsuccessful Login
```bash
robot \
  --variablefile env_vars.py \
  --outputdir automation-ui/login/results/login/failure \
  --output output.xml \
  --log log.html \
  --report report.html \
  automation-ui/login/login_failure.robot
```
