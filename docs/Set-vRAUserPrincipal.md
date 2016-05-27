# Set-vRAUserPrincipal

## SYNOPSIS
    
Update a vRA local user principal

## SYNTAX
 Set-vRAUserPrincipal -Id <String> [-FirstName <String>] [-LastName <String>] [-EmailAddress <String>] [-Description <String>] [-Password <String>] [-DisableAccount] [-EnableAccount] [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Update a vRA Principal (user)

## PARAMETERS


### Id

The principal id of the user

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### FirstName

First Name

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### LastName

Last Name

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### EmailAddress

Email Address

* Required: false
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

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### DisableAccount

Disable the user principal

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### EnableAccount

Enable or unlock the user principal

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

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
System.Diagnostics.Switch

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Set-vRAUserPrincipal -Id user@vsphere.local -FirstName FirstName-Updated -LastName LastName-Updated -EmailAddress userupdated@vsphere.local -Description Description-Updated







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Set-vRAUserPrincipal -Id user@vsphere.local -EnableAccount







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Set-vRAUserPrincipal -Id user@vsphere.local -DisableAccount







-------------------------- EXAMPLE 4 --------------------------

PS C:\>Set-vRAUserPrincipal -Id user@vsphere.local -Password s3cur3p@ss!
```

