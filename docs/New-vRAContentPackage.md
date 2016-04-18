# New-vRAContentPackage

## SYNOPSIS
    
Create a vRA Content Package

## SYNTAX
 New-vRAContentPackage -Name <String> [-Description <String>] -BlueprintId <String[]> [-WhatIf] [-Confirm]  [<CommonParameters>] New-vRAContentPackage -Name <String> [-Description <String>] -BlueprintName <String[]> [-WhatIf] [-Confirm]  [<CommonParameters>] New-vRAContentPackage [-Description <String>] -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA ContentPackage

## PARAMETERS


### Name

Content Package Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Content Package Description

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### BlueprintId

Blueprint Ids to include in the Content Package

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### BlueprintName

Blueprint Names to include in the Content Package

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

PS C:\>New-vRAContentPackage -Name ContentPackage01 -Description "This is Content Package 01" -BlueprintId 
"58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>New-vRAContentPackage -Name ContentPackage01 -Description "This is Content Package 01" -BlueprintName 
"Blueprint01","Blueprint02"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>$JSON = @"


{
    "name":"ContentPackage01",
    "description":"This is Content Package 01",
    "contents":[ "58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f" ]
}
"@
$JSON | New-vRAContentPackage
```

