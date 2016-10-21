# Request-vRAResourceAction

## SYNOPSIS
    
Request an available resourceAction for a catalog resource

## SYNTAX
 Request-vRAResourceAction -ActionId <String> -ResourceId <String> [-WhatIf] [-Confirm] [<CommonParameters>]  Request-vRAResourceAction -ActionId <String> -ResourceName <String> [-WhatIf] [-Confirm] [<CommonParameters>]  Request-vRAResourceAction -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]     

## DESCRIPTION

A resourceAction is a specific type of ResourceOperation that is performed by submitting a request. 
Unlike ResourceExtensions, resource actions can be invoked via the Service Catalog service and subject to approvals.

## PARAMETERS


### ActionId


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ResourceId

The id of the resource that the resourceAction will execute against

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### ResourceName

The name of the resource that the resourceAction will execute against

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### JSON


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

System.String

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>$ResourceActionId = (Get-vRAResource -Name vm01 | Get-vRAResourceAction "Reboot").id

Request-vRAResourceAction -Id $ResourceActionId -ResourceName vm01




-------------------------- EXAMPLE 2 --------------------------

PS C:\>Request-vRAResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceId 20402e93-fb1d-4bd9-8a51-b809fbb946fd






-------------------------- EXAMPLE 3 --------------------------

PS C:\>Request-vRAResourceAction -Id 6a301f8c-d868-4908-8348-80ad0eb35b00 -ResourceName vm01






-------------------------- EXAMPLE 4 --------------------------

PS C:\>$JSON = @"

{
        "type":  "com.vmware.vcac.catalog.domain.request.CatalogResourceRequest",
        "resourceId":  "448fcd09-b8c0-482c-abbc-b3ab818c2e31",
        "actionId":  "fae08c75-3506-40f6-9c9b-35966fe9125c",
        "description":  null,
        "data":  {
                     "description":  null,
                     "reasons":  null
                 }
    }        
"@

$JSON | Request-vRAResourceAction
```

