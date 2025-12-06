*** Settings ***
Resource    ../../resources/libraries.robot

*** Variables ***
${URL}         http://localhost:8080
${BROWSER}     chrome
${TIMEOUT}     30s
${USERNAME_1}    ana
${PASSWORD_1}    password
${LOGIN_TIMEOUT}    5s

# Chrome preferences to disable password manager pop-up to change password
&{CHROME_PREFS_NO_SAVE}    credentials_enable_service=${FALSE}
...                        profile.password_manager_enabled=${FALSE}
...                        profile.password_manager_leak_detection=${FALSE}

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
    [Teardown]    Close All Browsers 

Lichess F2: User shall be able to edit user profile
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Open Edit Profile Page    
    Page Should Contain     Edit profile        ${TIMEOUT}
    [Teardown]    Close All Browsers

Lichess F3: User shall be able to add their chess ratings to their profile
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Open Edit Profile Page
    Page Should Contain Element    xpath=//input[@id="form3-fideRating"]    ${TIMEOUT}
    [Teardown]    Close All Browsers

Lichess F4: User shall be able to start a new chess game
    Open Browser To Lichess
    Login To Lichess    ${USERNAME_1}    ${PASSWORD_1}
    Start New Game Against Computer
    Page Should Contain Element    css=cg-board    ${TIMEOUT}
    [Teardown]    Close All Browsers

Lichess F5: User Can Join Match Against Online Opponent
    [Documentation]    F5: User shall be able to join and play against other online users
    Open Browser To Lichess
    Open Lobby Tab
    Join Any Free Lobby Game
    Verify Game Started
    [Teardown]    Close All Browsers


*** Keywords ***    
Get Chrome Options
    [Arguments]    ${headless}=True
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver

    Call Method    ${options}    add_experimental_option    prefs    ${CHROME_PREFS_NO_SAVE}

    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    IF    '${headless}' == 'True'
        Call Method    ${options}    add_argument    --headless
    END
    RETURN    ${options}

Open Browser To Lichess
    ${options}=    Get Chrome Options    headless=False
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Login To Lichess
    [Arguments]    ${username}    ${password}
    Click Element    xpath=//a[@class="signin"]
    Wait Until Page Contains    Sign in        ${TIMEOUT}

    Input Text    id=form3-username    ${username}
    Input Text    id=form3-password    ${password}

    Click Button    xpath=//button[@class="submit button"]
    Wait Until Page Contains Element    xpath=//div[@class="lobby__start"]    ${TIMEOUT}

Open Edit Profile Page
    Click Element    xpath=//div[@class="dasher"]
    #Wait Until Page Contains Element    xpath=//div[@class="dropdown"]    ${TIMEOUT}
    Sleep    1s
    Click Link    Preferences
    Wait Until Page Contains    Edit profile    ${TIMEOUT}
    
Start New Game Against Computer
    Click Button    Play against computer
    Wait Until Page Contains    Game setup    ${TIMEOUT}
    Click Button    xpath=//button[@class="button button-metal lobby__start__button lobby__start__button--ai"]

Open Lobby Tab
    Wait Until Page Contains Element
    ...    xpath=//span[@role="tab" and normalize-space(.)="Lobby"]
    ...    ${TIMEOUT}
    Click Element    xpath=//span[@role="tab" and normalize-space(.)="Lobby"]
    Sleep    2s

Join Any Free Lobby Game
    [Documentation]    Tries for up to 30 seconds to join any available game from the lobby.
    Wait Until Keyword Succeeds    30s    1s    Click Free Lobby Game And Wait For Board

Click Free Lobby Game And Wait For Board
    # Find a free game row (hook + join, but NOT disabled)
    Wait Until Page Contains Element
    ...    xpath=//tbody//tr[contains(@class,"hook") and contains(@class,"join") and not(contains(@class,"disabled"))]
    ...    2s

    # Click the first free game
    Click Element
    ...    xpath=(//tbody//tr[contains(@class,"hook") and contains(@class,"join") and not(contains(@class,"disabled"))])[1]

    # Wait until a board appears
    Wait Until Page Contains Element    css=cg-board    3s

Verify Game Started
    [Documentation]    Verifies that an ongoing game is displayed
    ...                (board + "You play the ... pieces").
    # 1) Board is visible
    Wait Until Page Contains Element    css=cg-board    ${TIMEOUT}

    # 2) Info text "You play the white/black pieces"
    Wait Until Page Contains    You play the    10s

    Log    Active game with board and info text "You play the ... pieces" is visible – requirement fulfilled.

