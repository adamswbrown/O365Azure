 $users = Get-AzureADUser 
 $users | 
 Select-Object -property @{name="User Name";Expression={$_.UserPrincipalName}},
 @{name="First Name";Expression={$_.FirstName}},
 @{name="Last Name";Expression={$_.LastName}},
 @{name="Display Name";Expression={$_.DisplayName}},
 @{name="Job Title";Expression={$_.JobTitle}},
 @{name="Department";Expression={$_.Department}},
 @{name="Office Number";Expression={$_.Office}},
 @{name="Office Phone";Expression={$_.PhoneNumber}},
 @{name="Mobile Phone";Expression={$_.MobilePhone}},
 @{name="Fax";Expression={$_.Fax}},
 @{name="Address";Expression={$_.StreetAddress}},
 @{name="City";Expression={$_.City}},
 @{name="State or Province";Expression={$_.State}},
 @{name="Zip or Postal Code";Expression={$_.PostalCode}},
 @{name="Country or Region";Expression={$_.Country}} | 
 Export-Csv c:\users.csv -NoTypeInformation
