# Get-vRAResourceMetrics

## SYNOPSIS
    
Retrieve metrics for a deployed resource

## SYNTAX
 Get-vRAResourceMetrics [-Limit <String[]>] [<CommonParameters>] Get-vRAResourceMetrics [-Id <String[]>] [-Limit <String[]>] [<CommonParameters>] Get-vRAResourceMetrics [-Name <String[]>] [-Limit <String[]>] [<CommonParameters>]    

## DESCRIPTION

Retrieve metrics for a deployed resource

## PARAMETERS


### Id

The id of the catalog resource

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The name of the catalog resource

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAResourceMetrics







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAConsumerCatalogItem -Name vm01 | Get-vRAResourceMetrics







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAResourceMetrics -Id "448fcd09-b8c0-482c-abbc-b3ab818c2e31"







-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRAResourceMetrics -Name vm01
```

