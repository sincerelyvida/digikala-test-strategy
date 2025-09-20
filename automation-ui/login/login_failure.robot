*** Settings ***
Resource        login.robot
Suite Setup     Setup Browser
Suite Teardown  Close All Browsers
Documentation   Negative login flow: wrong password shows transient error toast.
Default Tags    regression    login

*** Test Cases ***
Unsuccessful Login - Wrong Password
    Login Should Fail