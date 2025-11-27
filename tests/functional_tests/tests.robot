*** Settings ***
Resource    ../../resources/libraries.robot

*** Test Cases ***
Open Google
    ${options}=    Get Chrome Options
    Open Browser    https://google.com    chrome    options=${options}

    Page Should Contain    Google

*** Keywords ***
Get Chrome Options
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --start-maximized
    RETURN    ${options}
