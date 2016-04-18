# Remove-vRATenant

## SYNOPSIS
    
Remove a vRA Tenant

## SYNTAX
 Remove-vRATenant [-Id] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a vRA Tenant

## PARAMETERS


### Id

Tenant ID

* Required: true
* Position: 1
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

PS C:\>Remove-vRATenant -Id Tenant02







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRATenant -Id Tenant02 | Remove-vRATenant -Confirm:$false
```

