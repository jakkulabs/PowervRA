# Remove-vRAReservation

## SYNOPSIS
    
Remove a reservation

## SYNTAX
 Remove-vRAReservation -Id <String[]> [-WhatIf] [-Confirm] [<CommonParameters>] Remove-vRAReservation -Name <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a reservation

## PARAMETERS


### Id

The id of the reservation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Name

The name of the reservation

* Required: true
* Position: named
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

System.String

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Remove-vRAReservation -Name Reservation1







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Remove-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAReservation -Name Reservation1 | Remove-vRAReservation
```

