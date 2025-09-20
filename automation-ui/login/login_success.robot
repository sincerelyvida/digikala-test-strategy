*** Settings ***
Resource        login.robot
Suite Setup     Setup Browser
Suite Teardown  Close All Browsers
Documentation   Positive login flow: should authenticate and land on homepage.
Default Tags    smoke    login

*** Test Cases ***
Successful Login
    Login Should Succeed