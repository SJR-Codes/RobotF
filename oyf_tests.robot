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

*** Tasks ***
Open OYF API
    Open connection
#Check logged in user
#    Check User

*** Keywords ***
Open connection    
#    Create Session    OYF    ${url}     auth=${auth}
    ${heads}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded    User-Agent=RobotFramework
    Create Session      OYF        ${url}
    ${body}=    Create Dictionary    username=${usern}    password=${passwd}
    ${response}=    POST On Session    OYF  url=${login}    data=${body}    headers=${heads}
    Should Be Equal As Strings      ${response.status_code}     200
#    Log  Response is ${response.json()['access_token']}  console=yes
    ${token}=    Set Variable    ${response.json()['access_token']}
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    
#    Log  Headers is ${headers}  console=yes
    ${resp}=  GET On Session  OYF  /users/me    headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    Should Be Equal As Strings  ${resp.json()['is_active']}  True
#    ${resp_oyf}=   POST On Session  OYF  ${login}    data=${data}  expected_status=200

    ${body}=    Create Dictionary    email=user@example.com    password=string    is_active=true    is_superuser=false    is_verified=false
    ${resp}=  POST On Session  OYF  /auth/register    json=${body}    headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  201

    ${uid}=    Set Variable    ${resp.json()['id']}
#    Log    Delete user ${uid}  console=yes
    ${resp}=  DELETE On Session  OYF  url=/users/${uid}    headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  204