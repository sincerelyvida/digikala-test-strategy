# Resource file: shared variables & keywords for login suites

*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}
${USERNAME}
${PASSWORD}

${LOGIN_LINK}        xpath=//a[contains(@href,'/users/login')]
${USERNAME_FIELD}    xpath=//input[@name='username']
${USERNAME_SUBMIT}   xpath=//button[@type='submit' and @data-cro-id='login-register']
${PASSWORD_FIELD}    xpath=//input[@name='password']
${PASSWORD_SUBMIT}   xpath=//button[@type='submit' and contains(.,'تایید')]
${RATE_LIMIT_TOAST}    xpath=//div[contains(text(),'بیش از حد مجاز تلاش کرده‌اید')]
${TOO_MANY_REQUESTS_TOAST}    xpath=//div[contains(text(), 'تعداد درخواست‌ها بیشتر از حد مجاز است')]
${Wrong_Password_TOAST}    xpath=//div[contains(text(),'اطلاعات کاربری نادرست است')]
${USER_NOT_FOUND_TOAST}    xpath=//div[contains(text(),'حساب کاربری با مشخصات وارد شده وجود ندارد. لطفا از شماره تلفن همراه برای ساخت حساب کاربری استفاده نمایید.')]
${HEADER_CART}    xpath=//a[contains(@href,'/checkout/cart')]

*** Keywords ***
Setup Browser
    Open Browser    ${BASE_URL}    chrome
    Maximize Browser Window
    Set Selenium Timeout    10s
    Set Selenium Implicit Wait    1s

Guard Against Rate Limit
    [Arguments]    ${step}
    ${rate_limited}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${RATE_LIMIT_TOAST}    3s
    Run Keyword If    ${rate_limited}    Fail    Rate limited at step: ${step} — Back off and retry later (rate limit toast shown).

Login Should Succeed
    Wait Until Element Is Visible    ${LOGIN_LINK}    5s
    Click Element    ${LOGIN_LINK}
    Wait Until Page Contains Element    ${USERNAME_FIELD}    10s
    Input Text       ${USERNAME_FIELD}    ${USERNAME}
    Click Button     ${USERNAME_SUBMIT}

    Guard Against Rate Limit    email-submit

    # If account/email does not exist, fail fast with a clear message
    ${no_user}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${USER_NOT_FOUND_TOAST}    3s
    Run Keyword If    ${no_user}    Fail    Login failed: account/username not found — use a valid account or phone number (invalid credentials toast shown).

    Wait Until Page Contains Element    ${PASSWORD_FIELD}    10s
    Input Text       ${PASSWORD_FIELD}    ${PASSWORD}
    Click Button     ${PASSWORD_SUBMIT}

    # Wait for successfully redirecting to home: left the /users/login URL
    ${password_toast}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${Wrong_Password_TOAST}    5s
    ${too_many_toast}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${TOO_MANY_REQUESTS_TOAST}    5s
    ${left_login}=    Run Keyword And Return Status    Wait Until Location Does Not Contain    /users/login

    IF    ${password_toast}
        Fail    Login failed: Password is wrong — invalid password toast shown.
    ELSE IF    ${too_many_toast}
        Fail    Login failed: Too many attempts — throttle toast shown after password submit.
    ELSE IF    ${left_login}
        Log    Login success heuristic passed.    INFO
        Capture Page Screenshot
    ELSE
        Fail    Login failed: neither redirect, header change, nor known error toast appeared. Check network, timing, or selectors.
    END


Login Should Fail
    Wait Until Element Is Visible    ${LOGIN_LINK}    5s
    Click Element    ${LOGIN_LINK}
    Wait Until Page Contains Element    ${USERNAME_FIELD}    10s
    Input Text       ${USERNAME_FIELD}    ${USERNAME}
    Click Button     ${USERNAME_SUBMIT}

    Wait Until Page Contains Element    ${PASSWORD_FIELD}    10s
    Input Text       ${PASSWORD_FIELD}    wrong-password
    Click Button     ${PASSWORD_SUBMIT}

    Wait Until Element Is Visible    ${Wrong_Password_TOAST}    5s
    Element Should Contain    xpath=//div[contains(@class,'z-10')]    اطلاعات کاربری نادرست است
