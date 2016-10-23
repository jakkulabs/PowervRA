# Import-vRAContentPackage

## SYNOPSIS
    
Imports a vRA Content Package

## SYNTAX
 Import-vRAContentPackage [-File] <String[]> [-DontValidatePackage] [-WhatIf] [-Confirm] [<CommonParameters>]     

## DESCRIPTION

Imports a vRA Content Package

## PARAMETERS


### File

The content package file

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### DontValidatePackage

Skip Package Validation. Not recommended by the API documentation

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

System.String
System.Switch

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Import-vRAContentPackage -File C:\Packages\ContentPackage100.zip






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-ChildItem -Path C:\Packages\ContentPackage100.zip| Import-vRAContentPackage -Confirm:$false
```

