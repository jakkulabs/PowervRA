# Get-vRAReservationComputeResource

## SYNOPSIS
    
Get a compute resource for a reservation type

## SYNTAX
 Get-vRAReservationComputeResource -Type <String> [<CommonParameters>] Get-vRAReservationComputeResource -Type <String> -Id <String[]> [<CommonParameters>] Get-vRAReservationComputeResource -Type <String> -Name <String[]> [<CommonParameters>]    

## DESCRIPTION

Get a compute resource for a reservation type

## PARAMETERS


### Type

The resource type

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Id

The id of the compute resource

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The name of the compute resource

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

PS C:\>Get-vRAReservationComputeResource -Type vSphere -Id 75ae3400-beb5-4b0b-895a-0484413c93b1







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAReservationComputeResource -Type vSphere -Name "Cluster01"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAReservationComputeResource -Type vSphere
```

