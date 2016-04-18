# Remove-vRABusinessGroup

## SYNOPSIS
    
Remove a vRA Business Group

## SYNTAX
 Remove-vRABusinessGroup -TenantId <String> -Id <String[]> [-WhatIf] [-Confirm] [<CommonParameters>] Remove-vRABusinessGroup -TenantId <String> -Name <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a vRA Business Group

## PARAMETERS


### TenantId

Tenant Id

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Id

Business Group Id

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Name

Business Group Name

* Required: true
* Position: named
* Default value: 
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

## OUTPUTS

None

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Remove-vRABusinessGroup -TenantId Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Remove-vRABusinessGroup -TenantId Tenant01 -Name "BusinessGroup01","BusinessGroup02"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01 | Remove-vRABusinessGroup -Confirm:$false
```

