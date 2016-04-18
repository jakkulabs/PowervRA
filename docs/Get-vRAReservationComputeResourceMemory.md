# Get-vRAReservationComputeResourceMemory

## SYNOPSIS
    
Get available memory for a compute resource

## SYNTAX
 Get-vRAReservationComputeResourceMemory [-Type] <String> [-ComputeResourceId] <String> [<CommonParameters>]    

## DESCRIPTION

Get available memory for a compute resource

## PARAMETERS


### Type

The reservation type

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: false

### ComputeResourceId


* Required: true
* Position: 2
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservationComputeResourceMemory -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d
```

