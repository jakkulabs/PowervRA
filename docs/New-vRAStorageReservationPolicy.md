# New-vRAStorageReservationPolicy

## SYNOPSIS
    
Create a vRA Storage Reservation Policy

## SYNTAX
 New-vRAStorageReservationPolicy -Name <String> [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>] New-vRAStorageReservationPolicy -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a vRA Storage Reservation Policy

## PARAMETERS


### Name

Storage Reservation Policy Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Description

Storage Reservation Policy Description

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

PS C:\>New-vRAStorageReservationPolicy -Name StorageReservationPolicy01 -Description "This is Storage Reservation 
Policy 01"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>$JSON = @"


{
  "name": "StorageReservationPolicy01",
  "description": "This is Storage Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
}
"@
$JSON | New-vRAStorageReservationPolicy
```

