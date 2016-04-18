# New-vRATenantDirectory

## SYNOPSIS
    
Create a vRA Tenant Directory

## SYNTAX
 New-vRATenantDirectory -ID <String> -Name <String> [-Description <String>] [-Alias <String>] -Type <String> -Domain  <String> -UserNameDN <String> -Password <String> -URL <String> -GroupBaseSearchDN <String> [-UserBaseSearchDN  <String>] [-Subdomains <String>] -GroupBaseSearchDNs <String[]> [-UserBaseSearchDNs <String[]>] [-DomainAdminUsername  <String>] [-DomainAdminPassword <String>] [-Certificate <String>] [-TrustAll] [-UseGlobalCatalog] [-WhatIf] [-Confirm]  [<CommonParameters>] New-vRATenantDirectory -ID <String> -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA Tenant Directory

## PARAMETERS


### ID

Tenant ID

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Tenant Directory Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Tenant Directory Description

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Alias

Tenant Directory Alias

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Type

Tenant Directory Type

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Domain

Tenant Directory Domain

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### UserNameDN

DN of the Username to authenticate the Tenant Directory with

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Password

Password of the Username to authenticate the Tenant Directory with

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### URL

Tenant Directory URL, e.g. ldap://dc01.vrademo.local:389

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### GroupBaseSearchDN

Tenant Directory GroupBaseSearchDN

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### UserBaseSearchDN

Tenant Directory UserBaseSearchDN

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Subdomains

Tenant Directory Subdomains

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### GroupBaseSearchDNs

Tenant Directory GroupBaseSearchDNs

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### UserBaseSearchDNs

Tenant Directory UserBaseSearchDNs

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### DomainAdminUsername

Tenant Directory DomainAdminUserName

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### DomainAdminPassword

Tenant Directory DomainAdminPassword

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Certificate

Tenant Directory Certificate

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### TrustAll

Tenant Directory TrustAll

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### UseGlobalCatalog

Tenant Directory UseGlobalCatalog

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### JSON

Body text to send in JSON format

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue)

### WhatIf


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Confirm


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String.

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>New-vRATenantDirectory -ID Tenant01 -Name Tenant01 -Description "This is the Tenant01 Directory" -Type AD 
-Domain "vrademo.local" -UserNameDN "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local" `


-Password "P@ssw0rd" -URL "ldap://dc01.vrademo.local:389" -GroupBaseSearchDN 
"OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -UserBaseSearchDN "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" `
 -GroupBaseSearchDNs "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -UserBaseSearchDNs 
"OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -TrustAll




-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
  "name" : "Tenant01",
  "description" : "Tenant01",
  "alias" : "",
  "type" : "AD",
  "userNameDn" : "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local",
  "groupBaseSearchDn" : "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "password" : "P@ssword!",
  "url" : "ldap://dc01.vrademo.local:389",
  "userBaseSearchDn" : "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "domain" : "vrademo.local",
  "domainAdminUsername" : "",
  "domainAdminPassword" : "",
  "subdomains" : [ "" ],
  "groupBaseSearchDns" : [ "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
  "userBaseSearchDns" : [ "OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
  "certificate" : "",
  "trustAll" : true,
  "useGlobalCatalog" : false
}
"@
$JSON | New-vRATenantDirectory -ID Tenant01
```

