# Get-vRAEntitledCatalogItem

## SYNOPSIS
    
Get a catalog item that the user is entitled to see

## SYNTAX
 Get-vRAEntitledCatalogItem [-Service <String>] [-Page <Int32>] [-Limit <Int32>] [<CommonParameters>]  Get-vRAEntitledCatalogItem -Id <String[]> [<CommonParameters>]  Get-vRAEntitledCatalogItem -Name <String[]> [<CommonParameters>]     

## DESCRIPTION

Get catalog items that are entitled to. Consumer Entitled CatalogItem(s) are basically catalog items:
- in an active state.
- the current user has the right to consume.
- the current user is entitled to consume.
- associated to a service.

## PARAMETERS


### Id


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### Name

The name of the catalog item

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Service

Return catalog items in a specific service

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Page

The index of the page to display

* Required: false
* Position: named
* Default value: 1
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String
System.Int

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAEntitledCatalogItem






-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAEntitledCatalogItem -Limit 9999






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAEntitledCatalogItem -Service "Default Service"






-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRAEntitledCatalogItem -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e






-------------------------- EXAMPLE 5 --------------------------

PS C:\>Get-vRAEntitledCatalogItem -Name Centos_Template
```

