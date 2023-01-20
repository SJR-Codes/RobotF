*** Settings ***
Library    RPA.Browser.Selenium    auto_close=$[FALSE]

*** Variables ***
${url}    https://www.taitotalo.fi
${searchterm}    Python

*** Tasks ***
Open Taitotalo website, accept cookies and search Python course
    Open webpage in browser
    Accept cookies
    Enter search term
    Do search

*** Keywords ***
Open webpage in browser
    Open Available Browser    ${url}
Accept cookies
    Click Button When Visible    //button[@class="coi-banner__accept"]
Enter search term
    Input Text When Element Is Visible    //input[@id="edit-hakusanat"]    ${searchterm}
Do search
    Click Button When Visible    //input[@id="edit-submit-search-results"]