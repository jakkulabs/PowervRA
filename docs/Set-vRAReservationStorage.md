# Set-vRAReservationStorage

## SYNOPSIS
    
Set vRA reservation storage properties

## SYNTAX
 Set-vRAReservationStorage [-Id] <String> [-Path] <String> [[-ReservedSizeGB] <Int32>] [[-Priority] <Int32>] [-Enabled]  [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Set vRA reservation storage properties

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


* Required: false
* Position: 3
* Default value: 0
* Accept pipeline input: false

### Priority

The priority of storage

* Required: false
* Position: 4
* Default value: 0
* Accept pipeline input: false

### Enabled

The status of the storage

* Required: false
* Position: named
* Default value: False
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
System.Management.Automation.SwitchParameter

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservation -Name "Reservation01" | Set-vRAReservationStorage -Path "Datastore01"  -ReservedSizeGB 20 
-Priority 10
```

