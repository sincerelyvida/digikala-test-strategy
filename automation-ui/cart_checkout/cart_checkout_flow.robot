*** Settings ***
Library    SeleniumLibrary
Suite Setup    Setup Browser
Suite Teardown    Close All Browsers
Resource    ../login/login.robot
Documentation   Cart and checkout flow: search, pick product, add to cart, confirm popup, proceed to shipping.
Default Tags    regression    cart    checkout

*** Variables ***
${BASE_URL}
${USERNAME}
${PASSWORD}
${SEARCH_QUERY}

# Search and Select Product
${SEARCH_BOX}           xpath=//div[@data-cro-id='searchbox-click']
${SEARCH_INPUT}         xpath=//input[@name="search-input"]
${SEARCH_SUGGESTION}    xpath=(//span[contains(text(),"${SEARCH_QUERY}")])[1]
${FIRST_PRODUCT}        xpath=(//div[@data-product-index="1"]//a)[1]

# Add to Cart
${ADD_TO_CART_BTN}      xpath=//button[@data-testid="add-to-cart"]

# Select Shipping date and time
${SECOND_AVAILABLE_DAY}    xpath=(//div[starts-with(@id,'DAY_ID')])[2]
${ANY_ENABLED_TIME_TILE}       xpath=//div[contains(@class,'flex') and contains(@class,'items-center') and not(contains(@class,'pointer-events-none'))][.//input[@type='radio' and not(@disabled)]]
${FIRST_NON_PLUS_TIME_SLOT}    xpath=(//div[contains(@class,'swiper-slide-active')]//label[ .//input[@type='radio' and not(@disabled)] and not(ancestor::div[contains(@class,'pointer-events-none')]) and not(.//span[contains(.,'ویژه پلاس')])])[1]

# Go to Card Popup
${GO_TO_CART_POPUP}         xpath=//div[contains(@class,'fixed bottom-0')]//a[contains(.,'برو به سبد خرید')]

# Confirm order button after redirect
${CONFIRM_ORDER_BTN}        xpath=//a[@data-cro-id="cart-continue-shopping" and contains(.,'تایید و تکمیل سفارش')]


# Shipping -> Continue to review/payment
${SHIPPING_CONTINUE_BTN}    xpath=//button[@data-cro-id='shipping-continue']

# Final purchase button
${PAY_BUTTON}               xpath=//div[normalize-space()='پرداخت']/ancestor::*[self::button or self::a][1]

# tweak timeout for payment redirect
${PAYMENT_REDIRECT_TIMEOUT}    10s

*** Keywords ***
Setup Browser
    Open Browser    ${BASE_URL}    chrome
    Maximize Browser Window

Login Before Checkout
    Login Should Succeed
    # Wait for homepage redirect after successful login
    Wait Until Location Contains    ${BASE_URL}    10s

Handle New Tab After Clicking Product
    [Documentation]    If clicking a product opens a new tab, switch to it; otherwise continue in same tab.
    Sleep    0.5s
    ${switched}=    Run Keyword And Return Status    Switch Window    NEW
    IF    not ${switched}
        Switch Window    index=LAST
    END
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s

Select First Available Delivery Date And Earliest Time
    # 1) Select Second Day (the day tiles above the time slots)
    Wait Until Page Contains Element    ${SECOND_AVAILABLE_DAY}    10s
    Scroll Element Into View            ${SECOND_AVAILABLE_DAY}
    Click Element                       ${SECOND_AVAILABLE_DAY}

    # 2) Pick the first enabled *non-Plus* time slot that is in the ACTIVE swiper slide
    Wait Until Page Contains Element    ${FIRST_NON_PLUS_TIME_SLOT}    10s
    Scroll Element Into View            ${FIRST_NON_PLUS_TIME_SLOT}
    # Retry normal click a few times in case of transient overlay animations
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${FIRST_NON_PLUS_TIME_SLOT}
    Sleep    0.5s

    # 3) Continue button becomes enabled only after a valid selection
    Wait Until Element Is Enabled       ${SHIPPING_CONTINUE_BTN}    20s

Click Shipping Continue
    [Documentation]    On the shipping page, clicks the submit button.
    Wait Until Page Contains Element    ${SHIPPING_CONTINUE_BTN}    10s
    Scroll Element Into View            ${SHIPPING_CONTINUE_BTN}
    Click Element                       ${SHIPPING_CONTINUE_BTN}

Click Payment
    [Documentation]    Clicks the purchase button and verifies redirect to external gateway.
    # Click the final Pay button
    Wait Until Page Contains Element    ${PAY_BUTTON}    15s
    Scroll Element Into View            ${PAY_BUTTON}
    Click Element                       ${PAY_BUTTON}

*** Test Cases ***
Search Product, Add to Cart And Checkout
    Login Before Checkout
    # Open the search input by clicking the visible search box first
    Wait Until Page Contains Element    ${SEARCH_BOX}    10s
    Click Element    ${SEARCH_BOX}
    Wait Until Page Contains Element    ${SEARCH_INPUT}    10s
    Input Text    ${SEARCH_INPUT}       ${SEARCH_QUERY}
    Wait Until Page Contains Element    ${SEARCH_SUGGESTION}    10s
    Click Element    ${SEARCH_SUGGESTION}

    # Wait for the first product to load and click it to open the product page
    Wait Until Page Contains Element    ${FIRST_PRODUCT}    10s
    Click Element    ${FIRST_PRODUCT}
    Handle New Tab After Clicking Product
    Click Button    ${ADD_TO_CART_BTN}

    # Verify the bottom popup with go to cart appears and click it
    Wait Until Page Contains Element    ${GO_TO_CART_POPUP}    5s
    Click Element    ${GO_TO_CART_POPUP}

    # Verify that the confirm order button is visible after redirecting to checkout page
    Wait Until Page Contains Element    ${CONFIRM_ORDER_BTN}    10s
    Click Element    ${CONFIRM_ORDER_BTN}

    # Shipping: choose 2nd day and 1st enabled slot
    Select First Available Delivery Date And Earliest Time

    # Continue from shipping to review/payment
    Click Shipping Continue

    # Finalize payment
    Click Payment