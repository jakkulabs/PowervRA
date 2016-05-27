# New-vRAUserPrincipal

## SYNOPSIS
    
Create a vRA local user principal

## SYNTAX
 New-vRAUserPrincipal [-Tenant <String>] -PrincipalId <String> -FirstName <String> -LastName <String> -EmailAddress <String> [-Description <String>] -Password <String> [-WhatIf] [-Confirm] [<CommonParameters>] New-vRAUserPrincipal [-Tenant <String>] -FirstName <String> -LastName <String> -EmailAddress <String> [-Description <String>] -Credential <PSCredential> [-WhatIf] [-Confirm] [<CommonParameters>] New-vRAUserPrincipal -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA Principal (user)

## PARAMETERS


### Tenant

The tenant

* Required: false
* Position: named
* Default value: $Global:vRAConnection.Tenant
* Accept pipeline input: false

### PrincipalId

Principal id in user@company.com format

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### FirstName

First Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### LastName

Last Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### EmailAddress

Email Address

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Users text description

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Password

Users password

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Credential

Credential object

* Required: true
* Position: named
* Default value: 
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

PS C:\>New-vRAUserPrincipal -Tenant vsphere.local -FirstName "Test" -LastName "User" -EmailAddress "user@company.com" -Description "a description" -Password "password" -PrincipalId "user@vsphere.local"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
    "locked": "false",
    "disabled": "false",
    "firstName": "Test",
    "lastName": "User",
    "emailAddress": "user@company.com",
    "description": "no",
    "password": "password123",
    "principalId": {
        "domain": "vsphere.local",
        "name": "user"
    },
    "tenantName": "Tenant01",
    "name": "Test User"
    }
"@

$JSON | New-vRAUserPrincipal
```

