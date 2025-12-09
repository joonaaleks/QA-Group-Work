*** Settings ***
Resource    ../../../resources/libraries.robot
Resource    lichess.resource

Suite Setup    Setup Test Environment
Test Teardown    Close All Browsers 

##################    VARIABLES AND KEYWORDS ARE LOCATED IN THE RESOURCE FILE    ##################

*** Test Cases ***
Open Google
    ${options}=    Get Chrome Options    headless=False
    Open Browser    https://google.com    chrome    options=${options}
    Page Should Contain    Google


Lichess F1/N2/N4: User shall be able to login 
    [Documentation]    F1: User shall be able to login
    # N2 and N4 are covered as part of F1.
    # N2: Software must be usable on the desktop version of the application.
    # This is tested by running the tests in a desktop browser. "Open Browser To Lichess" keyword opens a desktop browser.
    # N4: User login must take under 5 seconds. This is tested with LOGIN_TIMEOUT variable.
    
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Page Should Contain Element    xpath=//div[@class="dasher"]    ${LOGIN_TIMEOUT} 


Lichess F2: User shall be able to edit user profile
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Open Edit Profile Page    
    Page Should Contain Element     xpath=//textarea[@id="form3-bio"]        ${TIMEOUT}


Lichess F3: User shall be able to add their chess ratings to their profile
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Open Edit Profile Page
    Page Should Contain Element    xpath=//input[@id="form3-fideRating"]    ${TIMEOUT}


Lichess F4: User shall be able to start a new chess game
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Start New Game Against Computer
    Page Should Contain Element    css=cg-board    ${TIMEOUT}


Lichess F5: User Can Join Match Against Online Opponent
    [Documentation]    F5: User shall be able to join and play against other online users
    Open Browser To Lichess
    Open Lobby Tab
    Join Any Free Lobby Game
    Verify Game Started


Lichess F7: User shall be able to send and receive messages or challenges to other players
    [Documentation]    Tests sending a direct message to another player via search and profile.
    
    ${USERNAME_2}=    Set Variable    TestUserName22
    ${PASSWORD_2}=    Set Variable    TestUserName12
    ${TARGET_USER}=   Set Variable    Jtss
    ${MESSAGE}=       Set Variable    Hallo
    
    Open Browser To Lichess.org
    
    Login To Lichess Specific    ${USERNAME_2}    ${PASSWORD_2}
    
    Search For User And NavigateToProfile    ${TARGET_USER}
    
    Click Element    xpath=//a[@class="btn-rack__btn" and @data-icon=""]
    
    Wait Until Page Contains Element    xpath=//textarea[@class="msg-app__convo__post__text"]    ${TIMEOUT}
    
    Send Direct Message    ${MESSAGE}
    
    VerifyDirectMessageSent    ${MESSAGE}


Lichess F9:
    [Documentation]    User should be able to reconnect to a game if the user disconnects.
    Log To Console    Init
    Open Browser To Lichess

Lichess F10:
    [Documentation]    User should be able to use the customization features of the platform.
    Log To Console    Init
    Open Browser To Lichess

Lichess F11:
    [Documentation]    User should be able to use the training features, and the platform should record the completed tasks.
    Log To Console    Init
    Open Browser To Lichess

Lichess F12:
    [Documentation]    Users should be able to complete puzzles, and the platform should record the results and completed puzzles.
    Log To Console    Init
    Open Browser To Lichess

Lichess F13:
    [Documentation]    The user shall be able to watch other users live matches.
    Open Browser To Lichess.org
    # For some reason Click Element does not work here
    Execute JavaScript    document.querySelector('a[href="/games"]').click()
    Click First Game In Now Playing
    Page Should Contain Element    css=cg-board    ${TIMEOUT}

Lichess F17: User shall be able to follow other users
    [Documentation]    Tests the follow/unfollow functionality from a user's profile page.
    
    ${USERNAME_2}=    Set Variable    TestUserName22
    ${PASSWORD_2}=    Set Variable    TestUserName12
    ${TARGET_USER}=   Set Variable    Jtss
    
    Open Browser To Lichess.org
    
    Login To Lichess Specific    ${USERNAME_2}    ${PASSWORD_2}
    
    Search For User And NavigateToProfile    ${TARGET_USER}
    
    Follow And Unfollow User
    

Lichess F19: The user shall be able to concede a game
    [Documentation]    Tests the user's ability to concede a game after rejoining.
    
    ${USERNAME_2}=    Set Variable    TestUserName22
    ${PASSWORD_2}=    Set Variable    TestUserName12
    
    Open Browser To Lichess.org
    Login To Lichess Specific    ${USERNAME_2}    ${PASSWORD_2}
    Start 5+0 Game
    Log    Game started, closing browser to simulate interruption.
    
    Close All Browsers
    
    Open Browser To Lichess.org
    Login To Lichess Specific    ${USERNAME_2}    ${PASSWORD_2}
    
    Join Resumed Game
    
    Concede Game
    

Lichess F20: The user shall be able to search for other players and view their profiles
    [Documentation]    Tests searching for a user, navigating to the profile, and viewing their games list.
    
    ${USERNAME_2}=    Set Variable    TestUserName22
    ${PASSWORD_2}=    Set Variable    TestUserName12
    ${TARGET_USER}=   Set Variable    Jtss
    
    Open Browser To Lichess.org
    
    Login To Lichess Specific    ${USERNAME_2}    ${PASSWORD_2}
    
    Search For User And NavigateToProfile    ${TARGET_USER}