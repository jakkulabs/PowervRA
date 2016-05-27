# Remove-vRAGroupPrincipal

## SYNOPSIS
    
Remove a vRA custom group

## SYNTAX
 Remove-vRAGroupPrincipal [-Id] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a vRA custom group

## PARAMETERS


### Id

The principal id of the custom group

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

PS C:\>Remove-vRAGroupPrincipal -PrincipalId Group@Tenant







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAGroupPrincipal -Id Group@Tenant | Remove-vRAGroupPrincipal
```

