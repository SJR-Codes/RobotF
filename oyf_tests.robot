*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
#Library  customAuthenticator.py
#Resource  res_setup.robot

*** Variables ***
${url}    http://127.0.0.1:8000/
${login}    auth/jwt/login
${usern}    a@a.fo
${passwd}    asd
#${auth}    Create List ${usern} ${passwd}
${auth}    Create List  a@a.fo    asd
${data}    username=a@a.fo&password=asd

*** Tasks ***
Open OYF API
    Open connection
Check logged in user
#    Check User

*** Keywords ***
Open connection    
#    Create Session    OYF    ${url}     auth=${auth}
    ${HEADERS}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded    User-Agent=RobotFramework
    Create Session      OYF        ${url}
    ${body}=    Create Dictionary    username=${usern}    password=${passwd}
    ${response}=    POST On Session    OYF  url=${login}    data=${body}    headers=${HEADERS}
    Should Be Equal As Strings      ${response.status_code}     200

Check User
    ${resp}=  GET On Session  OYF  /users/me
    Should Be Equal As Strings  ${resp.status_code}  200
    Should Be Equal As Strings  ${resp.json()['is_active']}  True
#    ${resp_oyf}=   POST On Session  OYF  ${login}    data=${data}  expected_status=200

