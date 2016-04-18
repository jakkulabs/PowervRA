# New-vRAReservationNetworkDefinition

## SYNOPSIS
    
Creates a new network definition for a reservation.

## SYNTAX
 New-vRAReservationNetworkDefinition -Type <String> -ComputeResourceId <String> -NetworkPath <String> [-NetworkProfile  <String>] [<CommonParameters>]    

## DESCRIPTION

Creates a new network definition for a reservation. This cmdlet is used to create a custom
complex network object. One or more of these can be added to an array and passed to New-vRAReservation.

## PARAMETERS


### Type

The reservation type

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### ComputeResourceId

The id of the compute resource

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### NetworkPath

The network path

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### NetworkProfile

The network profile

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String.

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>$NetworkDefinitionArray = @()


$Network1 = New-vRAReservationNetworkDefinition -Type vSphere -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 
-Path "VM Network" -Profile "Test"
$NetworkDefinitionArray += $Networ1
```

