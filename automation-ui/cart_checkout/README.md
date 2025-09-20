# Cart & Checkout Tests

This directory contains Robot Framework suites for testing **Digikala cart and checkout flows**.

---

## Structure

- `cart_checkout_flow.robot` → Suite for positive end-to-end cart and checkout scenario. Tagged as `regression cart checkout`.

---

## Running the Suites

```bash
robot \
  --variablefile env_vars.py \
  --outputdir automation-ui/cart_checkout/results \
  --output output.xml \
  --log log.html \
  --report report.html \
  automation-ui/cart_checkout/cart_checkout_flow.robot
```