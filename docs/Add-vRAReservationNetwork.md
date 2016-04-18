# Add-vRAReservationNetwork

## SYNOPSIS
    
Add a network to an existing vRA reservation

## SYNTAX
 Add-vRAReservationNetwork [-Id] <String> [-NetworkPath] <String> [[-NetworkProfile] <String>] [-WhatIf] [-Confirm]  [<CommonParameters>]    

## DESCRIPTION

This cmdlet enables the user to add a new network to a reservation. Only one new network path can be added at a time.
If a duplicate network path is detected, the API will throw an error.

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

PS C:\>Get-vRAReservation -Name Reservation01 | Add-vRAReservationNetwork -NetworkPath "DMZ" -NetworkProfile 
"DMZ-Profile"
```

