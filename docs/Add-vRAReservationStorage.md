# Add-vRAReservationStorage

## SYNOPSIS
    
Add storage to an existing vRA reservation

## SYNTAX
 Add-vRAReservationStorage [-Id] <String> [-Path] <String> [-ReservedSizeGB] <Int32> [[-Priority] <Int32>] [-WhatIf]  [-Confirm] [<CommonParameters>]    

## DESCRIPTION

This cmdlet enables the user to add new storage to a reservation. Only one new storage path can be added at a time.
If a duplicate storage path is detected, the API will throw an error.

## PARAMETERS


### Id

The Id of the reservation

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Path

The storage path

* Required: true
* Position: 2
* Default value: 
* Accept pipeline input: false

### ReservedSizeGB


* Required: true
* Position: 3
* Default value: 0
* Accept pipeline input: false

### Priority

The priority of storage

* Required: false
* Position: 4
* Default value: 0
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
System.Int.

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservation -Name Reservation01 | Add-vRAReservationStorage -Path "Datastore01" -ReservedSizeGB 500 
-Priority 1
```

