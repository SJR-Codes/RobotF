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
    Apply to first course

*** Keywords ***
Open webpage in browser
    Open Available Browser    ${url}
Accept cookies
    Click Button When Visible    //button[@class="coi-banner__accept"]
Enter search term
    Input Text When Element Is Visible    //input[@id="edit-hakusanat"]    ${searchterm}
Do search
    Click Button When Visible    //input[@id="edit-submit-search-results"]

Apply to first course
    Click Element When Visible    class:button-register