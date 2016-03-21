# Get-vRAResourceOperation

## SYNOPSIS
    
Get a resource operation

## SYNTAX
 Get-vRAResourceOperation [-Limit <String>] [<CommonParameters>] Get-vRAResourceOperation -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAResourceOperation -ExternalId <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAResourceOperation -Name <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Resource Type API exposed to administrators.Resource types is a type assigned to resources. 
The types are defined by the provider types. It allows similar resources to be grouped together.

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

C:\PS>Get-vRAResourceOperation







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Get-vRAResourceOperation -Id "a4d57b16-9706-471b-9960-d0855fe544bb"







-------------------------- EXAMPLE 3 --------------------------

C:\PS>Get-vRAResourceOperation -Name "Power On"







-------------------------- EXAMPLE 4 --------------------------

C:\PS>Get-vRAResourceOperation -ExternalId "Infrastructure.Machine.Action.PowerOn"
```

