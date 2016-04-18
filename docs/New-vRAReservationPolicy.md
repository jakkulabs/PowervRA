# New-vRAReservationPolicy

## SYNOPSIS
    
Create a vRA Reservation Policy

## SYNTAX
 New-vRAReservationPolicy -Name <String> [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>] New-vRAReservationPolicy -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA Reservation Policy

## PARAMETERS


### Name

Reservation Policy Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Reservation Policy Description

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### JSON

Body text to send in JSON format

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue)

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

PS C:\>New-vRAReservationPolicy -Name ReservationPolicy01 -Description "This is Reservation Policy 01"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
  "name": "ReservationPolicy01",
  "description": "This is Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
}
"@
$JSON | New-vRAReservationPolicy
```

