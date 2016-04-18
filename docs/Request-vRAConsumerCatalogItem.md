# Request-vRAConsumerCatalogItem

## SYNOPSIS
    
Request a vRA catalog item

## SYNTAX
 Request-vRAConsumerCatalogItem -Id <String> [-RequestedFor <String>] [-Description <String>] [-Reasons <String>]  [-Wait] [-WhatIf] [-Confirm] [<CommonParameters>] Request-vRAConsumerCatalogItem -JSON <String> [-Wait] [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Request a vRA catalog item with a given request template payload. 

If the wait switch is passed the cmdlet will wait until the request has completed. If successful informaiton
about the new resource will be returned

If no switch is passed then the request id will be returned

## PARAMETERS


### Id

The Id of the catalog item to request

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### RequestedFor

The user principal that the request is for (e.g. user@vsphere.local). If not specified the current user is used

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

A description for the request

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Reasons

Reasons for the request

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### JSON

JSON string containing the request template

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue)

### Wait

Wait for the request to complete

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

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>$Template = Get-vRAConsumerEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | 
Get-vRAConsumerCatalogItemRequestTemplate


$Resource = Request-vRAConsumerCatalogItem -JSON $Template -Wait -Verbose




-------------------------- EXAMPLE 2 --------------------------

PS C:\>$Template = Get-vRAConsumerEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | 
Get-vRAConsumerCatalogItemRequestTemplate


$RequestId = Request-vRAConsumerCatalogItem -JSON $Template -Verbose




-------------------------- EXAMPLE 3 --------------------------

PS C:\>Request-vRAConsumerCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e"







-------------------------- EXAMPLE 4 --------------------------

PS C:\>Request-vRAConsumerCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Wait







-------------------------- EXAMPLE 5 --------------------------

PS C:\>Request-vRAConsumerCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Description "Test" -Reasons "Test 
Reason"
```

