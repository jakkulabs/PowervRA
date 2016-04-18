# Get-vRAReservationComputeResourceResourcePool

## SYNOPSIS
    
Get available resource pools for a compute resource

## SYNTAX
 Get-vRAReservationComputeResourceResourcePool -Type <String> -ComputeResourceId <String> [<CommonParameters>] Get-vRAReservationComputeResourceResourcePool -Type <String> -ComputeResourceId <String> -Name <String[]>  [<CommonParameters>]    

## DESCRIPTION

Get available resource pools for a compute resource

## PARAMETERS


### Type

The reservation type

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ComputeResourceId


* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The name of the resource pool

* Required: true
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

PS C:\>Get-vRAReservationComputeResourceResourcePool -Type vSphere -ComputeResourceId 
0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name ResourcePool1







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAReservationComputeResourceResourcePool -Type vSphere -ComputeResourceId 
0c0a6d46-4c37-4b82-b427-c47d026bf71d
```

