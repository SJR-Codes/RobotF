*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
#Library  customAuthenticator.py
#Resource  res_setup.robot

*** Variables ***
${url}    http://127.0.0.1:8000/
${login_url}    auth/jwt/login
${register_url}    auth/register
${user_url}    users/
${oyf_base_url}    authenticated-route
${oyf_categories_url}    categories/
${oyf_photos_url}    photos/
${oyf_test_photo_id}    d77ab215-6046-4ccf-8194-bbd316c33b46
${admin}    a@a.fo
${admin_pass}    asd
${usern}    user@example.com
${user_pass}    asd
${super_headers}    foo
${user_headers}    foo
${bleh_headers}    Create Dictionary    Content-Type=application/json    Authorization=Bearer bleh
${uid}    foo
${test_image}    Lenna_(test_image).png

*** Tasks ***
Open OYF API
    Open Connection
Check Admin Authorization
    Is Admin Authorized
Check OYF as Admin
    Can Admin Access OYF
Check OYF Categories as Admin
    Can Admin Access OYF Categories
Check User Adding
    Adding User
Check User Authorization
    Login User
Check User login
    Is User Authorized
Check OYF as User
    Can User Access OYF
Check OYF Categories as User
    Can User Access OYF Categories
Check User Delete
    Delete User
Check OYF Without Login
    Is Unauthorized Access Blocked OYF
Check OYF Categories Without Login
    Is Unauthorized Access Blocked OYF Categories


*** Keywords ***
Open Connection    
#    Create Session    OYF    ${url}     auth=${auth}
    ${heads}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded    User-Agent=RobotFramework
    Create Session      OYF        ${url}
    ${body}=    Create Dictionary    username=${admin}    password=${admin_pass}
    ${response}=    POST On Session    OYF  url=${login_url}    data=${body}    headers=${heads}   expected_status=200
#    Log  Response is ${response.json()['access_token']}  console=yes
    ${token}=    Set Variable    ${response.json()['access_token']}
    ${local_headers}    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    Set Global Variable    ${super_headers}    ${local_headers}

Is Admin Authorized    
#    Log  Headers is ${headers}  console=yes
    ${resp}=  GET On Session  OYF  ${user_url}me    headers=${super_headers}   expected_status=200
    Should Be Equal As Strings  ${resp.json()['is_active']}  True
    Should Be Equal As Strings  ${resp.json()['is_superuser']}  True

Can Admin Access OYF
    ${resp}=  GET On Session  OYF  ${oyf_base_url}    headers=${super_headers}   expected_status=200
    Should Be Equal As Strings  ${resp.json()['message'][:5]}  Hello
Can Admin Access OYF Categories
    ${resp}=  GET On Session  OYF  ${oyf_categories_url}    headers=${super_headers}   expected_status=200
    #Should Be Equal As Strings  ${resp.json()['message'][:5]}  Hello

Adding User
    ${body}=    Create Dictionary    email=${usern}    password=${user_pass}    is_active=true    is_superuser=false    is_verified=false
    ${resp}=  POST On Session  OYF  ${register_url}    json=${body}    headers=${super_headers}   expected_status=201
    ${local_uid}=    Set Variable    ${resp.json()['id']}
    Set Global Variable    ${uid}    ${local_uid}

Login User    
#    Create Session    OYF    ${url}     auth=${auth}
    ${heads}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded    User-Agent=RobotFramework
    Create Session      OYFUSER        ${url}
    ${body}=    Create Dictionary    username=${usern}    password=${user_pass}
    ${response}=    POST On Session    OYFUSER  url=${login_url}    data=${body}    headers=${heads}   expected_status=200
#    Log  Response is ${response.json()['access_token']}  console=yes
    ${token}=    Set Variable    ${response.json()['access_token']}
    ${local_headers}    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    Set Global Variable    ${user_headers}    ${local_headers}

Is User Authorized
    ${resp}=  GET On Session  OYFUSER  ${user_url}me    headers=${user_headers}   expected_status=200
    Should Be Equal As Strings  ${resp.json()['is_active']}  True
    Should Be Equal As Strings  ${resp.json()['is_superuser']}  False

Can User Access OYF
    ${resp}=  GET On Session  OYFUSER  ${oyf_base_url}    headers=${user_headers}   expected_status=200
    Should Be Equal As Strings  ${resp.json()['message'][:5]}  Hello
Can User Access OYF Categories
    ${resp}=  GET On Session  OYF  ${oyf_categories_url}    headers=${user_headers}   expected_status=200
    #Should Be Equal As Strings  ${resp.json()['message'][:5]}  Hello

Delete User
    ${resp}=  DELETE On Session  OYF  url=${user_url}${uid}    headers=${super_headers}   expected_status=204

Is Unauthorized Access Blocked OYF    
    ${resp}=  GET On Session  OYFUSER  ${oyf_base_url}    ${bleh_headers}   expected_status=401
Is Unauthorized Access Blocked OYF Categories
    ${resp}=  GET On Session  OYFUSER  ${oyf_categories_url}    ${bleh_headers}   expected_status=401
