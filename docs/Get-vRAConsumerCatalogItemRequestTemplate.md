# Get-vRAConsumerCatalogItemRequestTemplate

## SYNOPSIS
    
Get the request template of a catalog item that the user is entitled to see

## SYNTAX
 Get-vRAConsumerCatalogItemRequestTemplate [-Limit <String>] [<CommonParameters>] Get-vRAConsumerCatalogItemRequestTemplate -Id <String> [-Limit <String>] [<CommonParameters>] Get-vRAConsumerCatalogItemRequestTemplate -Name <String> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Get the request template of a catalog item that the user is entitled to see and return a JSON payload to reuse in a request

## PARAMETERS


### Id

The id of the catalog item

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Name

The name of the catalog item

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.String

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAConsumerCatalogItemRequestTemplate -Id dab4e578-57c5-4a30-b3b7-2a5cefa52e9e







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAConsumerCatalogItemRequestTemplate -Name Centos_Template







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAConsumerEntitledCatalogItem | Get-vRAConsumerCatalogItemRequestTemplate







-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRAConsumerCatalogItemRequestTemplate







-------------------------- EXAMPLE 5 --------------------------

PS C:\>Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRAConsumerCatalogItemRequestTemplate | 
ConvertFrom-Json
```

