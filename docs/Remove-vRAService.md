# Remove-vRAService

## SYNOPSIS
    
Remove a vRA Service

## SYNTAX
 Remove-vRAService [-Id] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a vRA Service

## PARAMETERS


### Id

The id of the service

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

System.String

## OUTPUTS

None

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

C:\PS>Remove-vRAService -Id "d00d3631-997c-40f7-90e8-7ccbc153c20c"







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRAService -Id "d00d3631-997c-40f7-90e8-7ccbc153c20c" | Remove-vRAService







-------------------------- EXAMPLE 3 --------------------------

C:\PS>Get-vRAService | Where-Object {$_.name -ne "Default Service"} | Remove-vRAService
```

