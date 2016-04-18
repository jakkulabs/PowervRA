# Remove-vRATenantDirectory

## SYNOPSIS
    
Remove a vRA Tenant Directory

## SYNTAX
 Remove-vRATenantDirectory [-Id] <String> [-Domain] <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a vRA Tenant Directory

## PARAMETERS


### Id

Tenant Id

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: false

### Domain

Tenant Directory Domain

* Required: true
* Position: 2
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

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

None

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Remove-vRATenantDirectory -Id Tenant01 -Domain vrademo.local







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$Id = "Tenant01"


Get-vRATenantDirectory -Id $Id | Remove-vRATenantDirectory -Id $Id -Confirm:$false
```

