# New-vRAGroupPrincipal

## SYNOPSIS
    
Create a vRA custom group

## SYNTAX
 New-vRAGroupPrincipal [-Tenant <String>] -Name <String> [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>] New-vRAGroupPrincipal -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA Principal (user)

## PARAMETERS


### Tenant

The tenant

* Required: false
* Position: named
* Default value: $Global:vRAConnection.Tenant
* Accept pipeline input: false

### Name

Group name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

A description for the group

* Required: false
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

PS C:\>New-vRAGroupPrincipal -Name TestGroup01 -Description "Test Group 01"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
        "@type": "Group",
        "groupType": "CUSTOM",
        "name": "TestGroup01",
        "fqdn": "TestGroup01@Tenant",
        "domain": "Tenant",
        "description": "Test Group 01",
        "principalId": {
            "domain": "Tenant",
            "name": "TestGroup01"
        }
    }
"@
```

