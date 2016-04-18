# Set-vRACatalogItem

## SYNOPSIS
    
Update a vRA catalog item

## SYNTAX
 Set-vRACatalogItem -Id <String> [-Quota <Int32>] [-Service <String>] [-NewAndNoteworthy <Boolean>] [-WhatIf]  [-Confirm] [<CommonParameters>] Set-vRACatalogItem -Id <String> [-Status <String>] [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Update a vRA catalog item

## PARAMETERS


### Id

The id of the catalog item

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### Status

The status of the catalog item (e.g. PUBLISHED, RETIRED, STAGING)

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Quota

The Quota of the catalog item

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### Service

The Service to assign the catalog item to

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### NewAndNoteworthy

Mark the catalog item as New and noteworthy in the UI

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

System.Int
System.String
System.Bool

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -Status PUBLISHED







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -Quota 1







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -Service "Default Service"







-------------------------- EXAMPLE 4 --------------------------

PS C:\>Set-vRACatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e -NewAndNoteworthy $false


TODO:
- Investigate / fix authorization error
```

