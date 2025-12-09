*** Settings ***
Resource    ../../../resources/libraries.robot
Resource    openmeetings.resource

Suite Setup    Setup Test Environment
Test Teardown    Close All Browsers 

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

F2 User shall be able to create a conference
    [Documentation]    F2 User shall be able to create a conference

    Open Browser To OpenMeetings
    Login To OpenMeetings    ${USERNAME_1}    ${PASSWORD_1}

    Create a conference

    # Verify that the conference was created by checking for the presence of the meeting canvas.
    Page Should Contain Element    xpath=/html/body/div[3]/div/div[2]/div/div[1]/div[1]/div[2]/div[2]/div[2]/div[1]/div[2]/div/div[1]/div[2]/div[1]/div/canvas[2]    ${TIMEOUT}

F3: User shall be able to join a room
    [Documentation]    F3: User shall be able to join a room

    Open Browser To OpenMeetings
    Login To OpenMeetings    ${USERNAME_1}    ${PASSWORD_1}

    Join a room

    Page Should Contain Element    xpath=//a[@id="id184"]    ${TIMEOUT}

F4: User shall be able to search for other users
    [Documentation]    F4: User shall be able to search for other users

    Open Browser To OpenMeetings
    Login To OpenMeetings    ${USERNAME_1}    ${PASSWORD_1}

    Search for user

    # Verify that search results are displayed
    Page Should Contain Element    xpath=//table[@id="searchUsersTable"]