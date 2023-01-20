*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${FALSE}

*** Variables ***
${url}    https://j2store.net/freeadmin/administrator/
${usern}    manager
${passwd}    manager
${article}    Testikkeli3
${description}    Testiartikkelin kuvaus lorem ipsumit...

*** Tasks ***
Open website, do stuff
    Open webpage in browser
    Login with username
    Add new article
    Confirm success

*** Keywords ***
Open webpage in browser
    Open Available Browser    ${url}

Login with username
    Input Text When Element Is Visible    //input[@id="mod-login-username"]    ${usern}
    Input Text    //input[@id="mod-login-password"]    ${passwd}
    Click Button When Visible    class:login-button

Add New Article
    Click Element When Visible    link:New Article
    Input Text When Element Is Visible    //input[@id="jform_title"]    ${article}
    #site is slow as heck...
    Wait Until Element Is Visible    link:Code    timeout=30
    #open textarea
    Click Link    link:Code
    Input Text When Element Is Visible    id:jform_articletext    ${description}
    Click Button    class:button-apply

Confirm success
    Element Text Should Be    class:alert-message    Article saved.