*** Settings ***
Resource    ../../resources/libraries.robot

*** Variables ***
${URL}         https://lichess.org
${BROWSER}     chrome
${TIMEOUT}     30s

*** Test Cases ***
Open Google
    ${options}=    Get Chrome Options    headless=False
    Open Browser    https://google.com    chrome    options=${options}
    Page Should Contain    Google

F5: User Can Join Match Against Online Opponent
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
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    IF    '${headless}' == 'True'
        Call Method    ${options}    add_argument    --headless
    END
    RETURN    ${options}

Open Browser To Lichess
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

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

