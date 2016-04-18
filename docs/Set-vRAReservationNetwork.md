# Set-vRAReservationNetwork

## SYNOPSIS
    
Set vRA reservation network properties

## SYNTAX
 Set-vRAReservationNetwork [-Id] <String> [-NetworkPath] <String> [[-NetworkProfile] <String>] [-WhatIf] [-Confirm]  [<CommonParameters>]    

## DESCRIPTION

Set vRA reservation network properties. This cmdlet can be used to set the Network Profile for a
Network Path in a reservation.

## PARAMETERS


### Id

The Id of the reservation

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### NetworkPath

The network path

* Required: true
* Position: 2
* Default value: 
* Accept pipeline input: false

### NetworkProfile

The network profile

* Required: false
* Position: 3
* Default value: 
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

System.String.

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "VM Network" -NetworkProfile 
"Test Profile 1"
```

