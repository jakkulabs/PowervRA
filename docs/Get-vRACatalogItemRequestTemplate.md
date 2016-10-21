# Get-vRACatalogItemRequestTemplate

## SYNOPSIS
    
Get the request template of a catalog item that the user is entitled to see

## SYNTAX
 Get-vRACatalogItemRequestTemplate -Id <String> [<CommonParameters>]  Get-vRACatalogItemRequestTemplate -Name <String> [<CommonParameters>]     

## DESCRIPTION

Get the request template of a catalog item that the user is entitled to see and return a JSON payload to reuse in a request

## PARAMETERS


### Id

The id of the catalog item

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

PS C:\>Get-vRAConsumerEntitledCatalogItem | Get-vRACatalogItemRequestTemplate






-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRACatalogItemRequestTemplate






-------------------------- EXAMPLE 5 --------------------------

PS C:\>Get-vRAConsumerEntitledCatalogItem -Name Centos_Template | Get-vRACatalogItemRequestTemplate | ConvertFrom-Json
```

