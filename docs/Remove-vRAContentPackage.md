# Remove-vRAContentPackage

## SYNOPSIS
    
Remove a vRA Content Package

## SYNTAX
 Remove-vRAContentPackage -Id <String[]> [-WhatIf] [-Confirm] [<CommonParameters>] Remove-vRAContentPackage -Name <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a vRA Content Package

## PARAMETERS


### Id

Content Package Id

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Name

Content Package Name

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

PS C:\>Remove-vRAContentPackage -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Remove-vRAContentPackage -Name "ContentPackage01","ContentPackage02"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAContentPackage -Name "ContentPackage01","ContentPackage02" | Remove-vRAContentPackage -Confirm:$false
```

