# Get-vRAResourceOperation

## SYNOPSIS
    
Get a resource operation

## SYNTAX
 Get-vRAResourceOperation [-Limit <String>] [<CommonParameters>] Get-vRAResourceOperation -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAResourceOperation -ExternalId <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAResourceOperation -Name <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

A resource operation represents a Day-2 operation that can be performed on a resource. 
Resource operations are registered in the Service Catalog and target a specific resource type. 
These operations can be invoked / accessed by consumers through the self-service interface on the resources they own.

## PARAMETERS


### Id

The id of the resource operation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ExternalId

The external id of the resource operation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The name of the resource operation

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

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAResourceOperation







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAResourceOperation -Id "a4d57b16-9706-471b-9960-d0855fe544bb"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAResourceOperation -Name "Power On"







-------------------------- EXAMPLE 4 --------------------------

PS C:\>Get-vRAResourceOperation -ExternalId "Infrastructure.Machine.Action.PowerOn"
```

