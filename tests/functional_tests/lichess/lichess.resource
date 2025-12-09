*** Settings ***
Resource    ../../../resources/libraries.robot

*** Variables ***
${URL}         http://localhost:8080
${URL-LIVE}         https://lichess.org/
${BROWSER}     chrome
${TIMEOUT}     30s
${USERNAME_1}    ana
${PASSWORD_1}    password
${LOGIN_TIMEOUT}    5s
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
    IF    '${headless}' == 'True'
        Call Method    ${options}    add_argument    --headless
    END
    RETURN    ${options}

Open Browser To Lichess
    ${options}=    Get Chrome Options    headless=False
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Open Browser To Lichess.org
    Open Browser    ${URL-LIVE}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Login To Lichess
    [Arguments]    ${username}    ${password}
    Click Element    xpath=//a[@class="signin"]
    Wait Until Page Contains Element    xpath=//input[@id="form3-username"]        ${TIMEOUT}

    Input Text    id=form3-username    ${username}
    Input Text    id=form3-password    ${password}

    Click Button    xpath=//button[@class="submit button"]
    Wait Until Page Contains Element    xpath=//div[@class="lobby__start"]    ${TIMEOUT}

Login To Lichess Specific
    [Arguments]    ${username}    ${password}
    Click Element    xpath=//a[@class="signin"]
    Wait Until Page Contains Element    xpath=//input[@id="form3-username"]        ${TIMEOUT}

    Input Text    xpath=//input[@id="form3-username"]    ${username}
    Input Text    xpath=//input[@id="form3-password"]    ${password}

    Click Button    xpath=//button[@type="submit" and normalize-space(.)="Sign in"]
    Wait Until Page Contains Element    xpath=//div[@class="lobby__start"]    ${TIMEOUT}

Open Edit Profile Page
    Click Element    xpath=//div[@class="dasher"]
    Wait Until Page Contains Element    xpath=//a[@href="/account/profile"]    ${TIMEOUT}
    Click Element    xpath=//a[@href="/account/profile"]
    Wait Until Page Contains Element    xpath=//input[@id="form3-fideRating"]    ${TIMEOUT}
    
Start New Game Against Computer
    Click Button    Play against computer
    Wait Until Page Contains    Game setup    ${TIMEOUT}
    Click Button    xpath=//button[@class="button button-metal lobby__start__button lobby__start__button--ai"]

Open Lobby Tab
    # Select the middle tab (index 2) within the horizontal tabs so it's language-agnostic
    Wait Until Page Contains Element
    ...    xpath=//div[contains(@class,"tabs-horiz") and @role="tablist"]/span[2]
    ...    ${TIMEOUT}
    Click Element    xpath=//div[contains(@class,"tabs-horiz") and @role="tablist"]/span[2]
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
    Wait Until Page Contains Element
    ...    xpath=//div[contains(@class,"message") and @data-icon]
    ...    10s

    Log    Active game with board and info text "You play the ... pieces" is visible – requirement fulfilled.

Search For User And NavigateToProfile
    [Arguments]    ${target_user}
    
    Click Element    xpath=//a[@class="link" and @data-icon=""]
    
    Wait Until Element Is Visible    xpath=//input[@aria-label="Search"]    ${TIMEOUT}
    
    Input Text    xpath=//input[@aria-label="Search"]    ${target_user}
    Press Keys    xpath=//input[@aria-label="Search"]    ${KEY_ENTER}
    
    Wait Until Page Contains    ${target_user}    ${TIMEOUT}
    
    Log    Successfully navigated to ${target_user}'s profile page.

Send Direct Message
    [Arguments]    ${message}
    
    Input Text    xpath=//textarea[@class="msg-app__convo__post__text"]    ${message}
    
    Press Keys    xpath=//textarea[@class="msg-app__convo__post__text"]    ${KEY_ENTER}
    Sleep    2s

VerifyDirectMessageSent
    [Arguments]    ${expected_message}
    
    Wait Until Page Contains Element
    ...    xpath=//mine[.//t[normalize-space(.)="${expected_message}"]]
    ...    ${TIMEOUT}
    
    Log    Direct message successfully verified in the conversation history.

Follow And Unfollow User
    [Documentation]    Checks current state and performs follow/unfollow action, then reverses it.
    
    ${FOLLOW_LOCATOR}=    Set Variable    xpath=//a[@class="btn-rack__btn relation-button" and normalize-space(.)="Follow"]
    ${UNFOLLOW_LOCATOR}=  Set Variable    xpath=//a[@class="btn-rack__btn relation-button" and normalize-space(.)="Unfollow"]
    
    # Initial Check: Unfollow if already following
    ${count}=    Get Element Count    ${UNFOLLOW_LOCATOR}
    Run Keyword If    ${count} > 0    Click Element    ${UNFOLLOW_LOCATOR}
    
    # Wait until the button is definitely 'Follow' before proceeding
    Wait Until Element Is Visible    ${FOLLOW_LOCATOR}    ${TIMEOUT}
    
    # 1. Follow the user
    Click Element    ${FOLLOW_LOCATOR}
    Log    Clicked Follow.
    
    # 2. Verify successful follow (Button changes to Unfollow)
    Wait Until Element Is Visible    ${UNFOLLOW_LOCATOR}    ${TIMEOUT}
    Log    Successfully verified button changed to Unfollow.
    
    # 3. Clean up/Reverse: Unfollow the user
    Click Element    ${UNFOLLOW_LOCATOR}
    Log    Clicked Unfollow.
    
    # 4. Verify successful unfollow (Button changes back to Follow)
    Wait Until Element Is Visible    ${FOLLOW_LOCATOR}    ${TIMEOUT}
    Log    Successfully verified button changed back to Follow.

Start 5+0 Game
    [Documentation]    Starts a new 5+0 game by clicking the quick pairing button.
    Click Element    xpath=//div[@role="button" and @data-id="5+0"]
    Wait Until Page Contains Element    css=cg-board    ${TIMEOUT}
    Log    5+0 game successfully started.

Join Resumed Game
    [Documentation]    Joins an ongoing game after re-logging in.
    ${JOIN_LOCATOR}=    Set Variable    xpath=//a[@class="text button button-fat" and normalize-space(text())='Join the game']
    Wait Until Element Is Visible    ${JOIN_LOCATOR}    ${TIMEOUT}
    Click Element    ${JOIN_LOCATOR}
    Wait Until Page Contains Element    css=cg-board    ${TIMEOUT}
    Log    Successfully joined resumed game.

Concede Game
    [Documentation]    Concedes the current game.
    Wait Until Element Is Visible    xpath=//button[normalize-space(text())='Resign'] | //button[@title='Resign']    ${TIMEOUT}
    Click Element    xpath=//button[normalize-space(text())='Resign'] | //button[@title='Resign']
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'status') or contains(@class, 'result')]    ${TIMEOUT}
    Log    Game conceded successfully.

Click First Game In Now Playing
    [Documentation]    Clicks the first game in the now-playing grid.
    Wait Until Page Contains Element    xpath=//div[contains(@class,"now-playing")]//a[contains(@class,"mini-game")]    ${TIMEOUT}
    Click Element    xpath=//div[contains(@class,"now-playing")]//a[contains(@class,"mini-game")][1]
    Log    Clicked first game in now-playing grid.

Find Official FIDE Time Controls
    [Documentation]    Looks for the following time controls: 30+20, 15+10, and 3+2.
    Page Should Contain Element    xpath=//div[@data-id='30+20']    ${TIMEOUT}
    Page Should Contain Element    xpath=//div[@data-id="15+10"]    ${TIMEOUT}
    Page Should Contain Element    xpath=//div[@data-id="3+2"]    ${TIMEOUT}
    Log    All official FIDE time controls found on the Quick Pairing page.