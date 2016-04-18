# Set-vRATenantDirectory

## SYNOPSIS
    
Update a vRA Tenant Directory

## SYNTAX
 Set-vRATenantDirectory -ID <String> [-Name <String>] [-Description <String>] [-Alias <String>] [-Type <String>]  -Domain <String> [-UserNameDN <String>] [-Password <String>] [-URL <String>] [-GroupBaseSearchDN <String>]  [-UserBaseSearchDN <String>] [-Subdomains <String>] [-GroupBaseSearchDNs <String[]>] [-UserBaseSearchDNs <String[]>]  [-DomainAdminUsername <String>] [-DomainAdminPassword <String>] [-Certificate <String>] [-TrustAll]  [-UseGlobalCatalog] [-WhatIf] [-Confirm] [<CommonParameters>] Set-vRATenantDirectory -ID <String> -Domain <String> -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Update a vRA Tenant Directory

## PARAMETERS


### ID

Tenant ID

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Tenant Directory Name

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Description


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

* Required: false
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

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Password

Password of the Username to authenticate the Tenant Directory with

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### URL

Tenant Directory URL, e.g. ldap://dc01.vrademo.local:389

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### GroupBaseSearchDN

Tenant Directory GroupBaseSearchDN

* Required: false
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

* Required: false
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

PS C:\>Set-vRATenantDirectory -ID Tenant01 -Domain vrademo.local -GroupBaseSearchDNs 
"OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" -userBaseSearchDNs 
"OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
  "name" : "Tenant01",
  "description" : "Tenant01",
  "alias" : "",
  "type" : "AD",
  "userNameDn" : "CN=vrasvc,OU=Service Accounts,OU=HQ,DC=vrademo,DC=local",
  "groupBaseSearchDn" : "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "password" : "P@ssword!",
  "url" : "ldap://dc01.vrademo.local:389",
  "userBaseSearchDn" : "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local",
  "domain" : "vrademo.local",
  "domainAdminUsername" : "",
  "domainAdminPassword" : "",
  "subdomains" : [ "" ],
  "groupBaseSearchDns" : [ "OU=Groups,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
  "userBaseSearchDns" : [ "OU=Users,OU=Tenant01,OU=Tenants,DC=vrademo,DC=local" ],
  "certificate" : "",
  "trustAll" : true,
  "useGlobalCatalog" : false
}
"@
$JSON | Set-vRATenantDirectory -ID Tenant01 -Domain vrademo.local
```

