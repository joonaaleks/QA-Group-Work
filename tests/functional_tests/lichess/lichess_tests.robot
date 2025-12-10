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
    # N4: User login must take under 5 seconds. This is tested with N_REQ_5S_TIMEOUT variable.
    
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Page Should Contain Element    xpath=//div[@class="dasher"]    ${N_REQ_5S_TIMEOUT} 


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


Lichess F4/N13: User shall be able to start a new chess game
    [Documentation]    User shall be able to start a new chess game
    # N13 is covered as a part of F4
    # N13: A new game shall start within 5 seconds after both players accept
    # This is tested with N_REQ_5S_TIMEOUT variable.
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Start New Game Against Computer    ${N_REQ_5S_TIMEOUT}
    Page Should Contain Element    css=cg-board    ${TIMEOUT}


Lichess F5/N13: User Can Join Match Against Online Opponent
    [Documentation]    F5: User shall be able to join and play against other online users
    # N13 is covered as a part of F4
    # N13: A new game shall start within 5 seconds after both players accept
    # This is tested with N_REQ_5S_TIMEOUT variable.
    Open Browser To Lichess
    Open Lobby Tab
    Join Any Free Lobby Game
    Verify Game Started    ${N_REQ_5S_TIMEOUT}


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

Lichess F14:
    [Documentation]    The user shall be able to play against different rated computers.
    Open Browser To Lichess
    Click Button    xpath=//button[contains(@class,"lobby__start__button--ai")]
    Wait Until Element Is Visible    xpath=//dialog[@aria-labelledby]    ${TIMEOUT}
    Page Should Contain Element    xpath=//div[@class="radio-pane"]    ${TIMEOUT}

Lichess F15:
    [Documentation]    The user shall be able to invite a friend to a match.
    Open Browser To Lichess
    Click Button    xpath=//button[contains(@class,"lobby__start__button--friend")]
    Wait Until Element Is Visible    xpath=//dialog[@aria-labelledby]    ${TIMEOUT}
    Click Button    xpath=//button[contains(@class,"lobby__start__button--friend") and not(contains(@class,'active'))]
    Sleep    0.5s
    Page Should Contain Element    xpath=//main[contains(@class, "challenge--created")]    ${TIMEOUT}

Lichess F16:
    [Documentation]    The user shall be able to play matches with different official time controls.
    Open Browser To Lichess
    Click Element    xpath=//div[contains(@class,"tabs-horiz") and @role="tablist"]/span[1]
    Find Official FIDE Time Controls

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

Lichess N5: Response time below 2 seconds
    [Documentation]    Measures the time taken to search for a user profile (Jtss) and navigate to it, ensuring it's below the 2-second requirement.
    
    ${TARGET_USER}=       Set Variable    Jtss
    ${MAX_TIME_S}=        Set Variable    2
    
    Open Browser To Lichess.org
    
    ${start_time}=    Get Time
    
    Search For User And NavigateToProfile    ${TARGET_USER}
    
    ${end_time}=    Get Time
    
    ${elapsed_time}=    Evaluate    ${end_time} - ${start_time}
    
    Log To Console    Search and navigation to ${TARGET_USER} took ${elapsed_time} seconds.
    
    Should Be True    ${elapsed_time} < ${MAX_TIME_S}
    ...    msg=The user search and profile navigation took ${elapsed_time} seconds, which exceeds the required ${MAX_TIME_S} seconds.

Lichess N6: Interface Responsiveness
    [Documentation]    N6: The interface should remain responsive and usable on mobile devices and tablets.
    
    Open Browser To Lichess.org
    
    # --- Mobile Device Check (375x667) ---
    Set Window Size    375    667
    
    ${MOBILE_MENU_LOCATOR}=    Set Variable    xpath=//label[@class="hbg"]
    Wait Until Page Contains Element    ${MOBILE_MENU_LOCATOR}    ${TIMEOUT}
    
    Click Element    ${MOBILE_MENU_LOCATOR}
    
    Sleep    0.5s
    
    ${LOGIN_LINK_LOCATOR}=    Set Variable    xpath=//a[normalize-space(text())="Sign in"]
    
    Wait Until Element Is Visible    ${LOGIN_LINK_LOCATOR}    ${TIMEOUT}
    
    Log    Mobile responsiveness confirmed.
    
    # --- Tablet Device Check (1024x768) ---
    Set Window Size    1024    768
    
    ${SITE_ICON_LOCATOR}=    Set Variable    xpath=//div[@class="site-icon" and @data-icon=""]
    Wait Until Page Contains Element    ${SITE_ICON_LOCATOR}    ${TIMEOUT}
    
    ${COMMUNITY_LINK_LOCATOR}=    Set Variable    xpath=//header//nav//a[contains(text(), 'Community')]
    Wait Until Page Contains Element    ${COMMUNITY_LINK_LOCATOR}    ${TIMEOUT}
    
    Log    Tablet responsiveness confirmed.

Lichess N17: User shall be able to stay logged in
    ${USERNAME_2}=    Set Variable    TestUserName22
    ${PASSWORD_2}=    Set Variable    TestUserName12
    ${USER_TAG_LOCATOR}=    Set Variable    xpath=//a[@id="user_tag" and normalize-space(text())="${USERNAME_2}"]
    
    Open Browser To Lichess.org
    Login To Lichess Specific    ${USERNAME_2}    ${PASSWORD_2}
    
    Wait Until Page Contains Element    ${USER_TAG_LOCATOR}    ${N_REQ_5S_TIMEOUT}
    Log    User successfully logged in (Tab 1).
    
    Execute JavaScript    window.open('${URL-LIVE}')
    Switch Window    NEW
    
    Wait Until Page Contains Element    ${USER_TAG_LOCATOR}    ${TIMEOUT}
    
    Log    Session successfully persisted in the new tab. User remains logged in.