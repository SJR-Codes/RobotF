*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${FALSE}

*** Variables ***
${url}    https://www.taitotalo.fi
${searchterm}    Python

*** Tasks ***
Open Taitotalo website, accept cookies, search Python course and click apply
    Open webpage in browser
    Accept cookies
    Enter search term
    Do search
    Open first course
    Switch to new window
    Accept cookies 2
    Apply to course

*** Keywords ***
Open webpage in browser
    Open Available Browser    ${url}
Accept cookies
    Click Button When Visible    //button[@class="coi-banner__accept"]
Enter search term
    Input Text When Element Is Visible    //input[@id="edit-hakusanat"]    ${searchterm}
Do search
    Click Button When Visible    //input[@id="edit-submit-search-results"]

Open first course
    Click Element When Visible    (//div[@class="execution-link"]//a)[1]
    #Click Element When Visible    (//a[@class="button-register btn btn-purple"])[1]

Switch to new window
    Switch Window    NEW

Accept cookies 2
    Click Element When Visible    class:cc-btn

Apply to course
    Click Element When Visible    class:btn-default