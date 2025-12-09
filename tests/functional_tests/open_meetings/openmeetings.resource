*** Settings ***
Resource    ../../../resources/libraries.robot

*** Variables ***
${URL}         https://localhost:5080
${BROWSER}     chrome
${TIMEOUT}     30s
${USERNAME_1}    om_admin
${PASSWORD_1}    1Q2w3e4r5t^y
${N_REQ_5S_TIMEOUT}    10s
${KEY_ENTER}

# Chrome preferences to disable password manager pop-up to change password
&{CHROME_PREFS_NO_SAVE}    credentials_enable_service=${FALSE}
...                        profile.password_manager_enabled=${FALSE}
...                        profile.password_manager_leak_detection=${FALSE}

*** Keywords ***    
Setup Test Environment
    BuiltIn.Set Suite Variable    ${KEY_ENTER}    \ue007
    
Get Chrome Options
    [Arguments]    ${headless}=True
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver

    Call Method    ${options}    add_experimental_option    prefs    ${CHROME_PREFS_NO_SAVE}

    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --ignore-certificate-errors
    IF    '${headless}' == 'True'
        Call Method    ${options}    add_argument    --headless
    END
    RETURN    ${options}

Open Browser To OpenMeetings
    ${options}=    Get Chrome Options    headless=False
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Login to OpenMeetings
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    xpath=/html/body/div[3]/div/div/div[2]/form/div[2]/div[1]/input    ${TIMEOUT}
    Click Element    xpath=/html/body/div[3]/div/div/div[2]/form/div[2]/div[1]/input
    Input Text    xpath=/html/body/div[3]/div/div/div[2]/form/div[2]/div[1]/input    ${username}
    Click Element    xpath=/html/body/div[3]/div/div/div[2]/form/div[2]/div[2]/input
    Input Text    xpath=/html/body/div[3]/div/div/div[2]/form/div[2]/div[2]/input    ${password}
    Click Element     xpath=//*[@id="id4"]
    Wait Until Element Is Visible    xpath=//button[@id="id93"]    ${TIMEOUT}