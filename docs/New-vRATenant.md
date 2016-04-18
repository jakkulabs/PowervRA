# New-vRATenant

## SYNOPSIS
    
Create a vRA Tenant

## SYNTAX
 New-vRATenant -Name <String> [-Description <String>] -URLName <String> [-ContactEmail <String>] -ID <String> [-WhatIf]  [-Confirm] [<CommonParameters>] New-vRATenant -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA Tenant

## PARAMETERS


### Name

Tenant Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Tenant Description

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### URLName

Tenant URL Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ContactEmail

Tenant Contact Email

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### ID

Tenant ID

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

PS C:\>New-vRATenant -Name Tenant01 -Description "This is Tenant01" -URLName Tenant01 -ContactEmail 
admin.user@tenant01.local -ID Tenant01







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
  "name" : "Tenant02",
  "description" : "This is Tenant02",
  "urlName" : "Tenant02",
  "contactEmail" : "test.user@tenant02.local",
  "id" : "Tenant02",
  "defaultTenant" : false,
  "password" : ""
}
"@
$JSON | New-vRATenant
```

