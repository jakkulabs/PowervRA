# Test-vRAContentPackage

## SYNOPSIS
    
Validates a vRA Content Package

## SYNTAX
 Test-vRAContentPackage [-File] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]     

## DESCRIPTION

Validates a vRA Content Package

## PARAMETERS


### File

The content package file

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

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Test-vRAContentPackage -File C:\Packages\ContentPackage100.zip






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-ChildItem -Path C:\Packages\ContentPackage100.zip| Test-vRAContentPackage
```

