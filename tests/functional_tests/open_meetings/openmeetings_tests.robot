*** Settings ***
Resource    ../../../resources/libraries.robot
Resource    openmeetings.resource

Suite Setup

##################    VARIABLES AND KEYWORDS ARE LOCATED IN THE RESOURCE FILE    ##################

*** Test Cases ***
Open Google
    ${options}=    Get Chrome Options    headless=False
    Open Browser    https://google.com    chrome    options=${options}
    Page Should Contain    Google

F1/N3: User shall be able to login 
    [Documentation]    F1: User shall be able to login
    # N3 is covered as part of F1.
    # N3: User login must take under 5 seconds. This is tested with N_REQ_5S_TIMEOUT variable.
    
    Open Browser To OpenMeetings
    Login To OpenMeetings    ${USERNAME_1}    ${PASSWORD_1}
    Page Should Contain Button    xpath=//button[@id="id93"]    ${N_REQ_5S_TIMEOUT}