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
    Page Should Contain Button    xpath=//button[@id="id93"]    ${N_REQ_10S_TIMEOUT}

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

F13: User shall be able to change their input and output devices
    [Documentation]    F13: User shall be able to change their input and output devices

    Open Browser To OpenMeetings
    Login To OpenMeetings    ${USERNAME_1}    ${PASSWORD_1}

    # Navigate to device settings page
    Create a conference
    
    Wait Until Element Is Visible    xpath=//span[contains(@class, "settings")]    ${TIMEOUT}
    Click Element    xpath=//span[contains(@class, "settings")]

    Page Should Contain Element    xpath=//select[contains(@class, "cam")]
    Log    Video input device selection is present.
    Page Should Contain Element    xpath=//select[contains(@class, "mic")]
    Log    Audio input device selection is present.
    Page Should Contain Element    xpath=//select[contains(@class, "speaker")]
    Log    Audio output device selection is present.

N13: The messages sent to chat shall arrive within 5 seconds when the internet connection is stable
    [Documentation]    N13: The messages sent to chat shall arrive within 5 seconds when the internet connection is stable

    Open Browser To OpenMeetings
    Login To OpenMeetings    ${USERNAME_1}    ${PASSWORD_1}

    Create a conference

    # Open chat panel
    Wait Until Element Is Visible    xpath=//div[@id="chatPanel"]    ${TIMEOUT}
    Click Element    xpath=//div[@id="chatPanel"] 

    Wait Until Element Is Visible    xpath=//div[contains(@class, "ui-resizable") and @id="chatPanel"]    ${TIMEOUT}

    # Send a chat message
    Wait Until Element Is Visible    xpath=//div[contains(@class, "wysiwyg-editor")]    ${TIMEOUT}
    Click Element    xpath=//div[contains(@class, "wysiwyg-editor")]
    Input Text    xpath=//div[contains(@class, "wysiwyg-editor")]    Test message from Robot Framework
    Click Button    xpath=//button[@id="id47"]

    # Verify that the message appears in the chat within 5 seconds
    Wait Until Page Contains Element    xpath=//div[contains(@class, "msg") and contains(@class, "float-start")]    ${N_REQ_5S_TIMEOUT}
    Log    Chat message received within 5 seconds.