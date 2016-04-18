# Remove-vRAReservationPolicy

## SYNOPSIS
    
Remove a vRA Reservation Policy

## SYNTAX
 Remove-vRAReservationPolicy -Id <String[]> [-WhatIf] [-Confirm] [<CommonParameters>] Remove-vRAReservationPolicy -Name <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Remove a vRA Reservation Policy

## PARAMETERS


### Id

Reservation Policy ID

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### Name

Reservation Policy Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

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

None

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Remove-vRAReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Remove-vRAReservationPolicy -Name "ReservationPolicy01"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAReservationPolicy -Name "ReservationPolicy01" | Remove-vRAReservationPolicy -Confirm:$false
```

