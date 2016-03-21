# Set-vRAReservationPolicy

## SYNOPSIS
    
Update a vRA Reservation Policy

## SYNTAX


## DESCRIPTION

Update a vRA Reservation Policy

## PARAMETERS


### Id

Reservation Policy Id

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Reservation Policy Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### NewName

Reservation Policy NewName

* Required: false
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

C:\PS>Set-vRAReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd" -NewName "NewName" -Description "This is the New Name"







-------------------------- EXAMPLE 2 --------------------------

C:\PS>Set-vRAReservationPolicy -Name ReservationPolicy01 -NewName "NewName" -Description "This is the New Name"







-------------------------- EXAMPLE 3 --------------------------

C:\PS>$JSON = @"


{
  "id": "34ae1d6c-9972-4736-acdb-7ee109ad1dbd",
  "name": "ReservationPolicy01",
  "description": "This is Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
}
"@
$JSON | Set-vRAReservationPolicy -Confirm:$false
```
