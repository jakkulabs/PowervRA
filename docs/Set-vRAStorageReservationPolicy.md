# Set-vRAStorageReservationPolicy

## SYNOPSIS
    
Update a vRA Storage Reservation Policy

## SYNTAX
 Set-vRAStorageReservationPolicy -Id <String> [-NewName <String>] [-Description <String>] [-WhatIf] [-Confirm]  [<CommonParameters>] Set-vRAStorageReservationPolicy -Name <String> [-NewName <String>] [-Description <String>] [-WhatIf] [-Confirm]  [<CommonParameters>] Set-vRAStorageReservationPolicy -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Update a vRA Storage Reservation Policy

## PARAMETERS


### Id

Storage Reservation Policy Id

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Storage Reservation Policy Name

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### NewName

Storage Reservation Policy NewName

* Required: false
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

PS C:\>Set-vRAStorageReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd" -NewName "NewName" -Description 
"This is the New Name"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Set-vRAStorageReservationPolicy -Name StorageReservationPolicy01 -NewName "NewName" -Description "This is the 
New Name"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>$JSON = @"


{
  "id": "34ae1d6c-9972-4736-acdb-7ee109ad1dbd",
  "name": "StorageReservationPolicy01",
  "description": "This is Storage Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
}
"@
$JSON | Set-vRAStorageReservationPolicy -Confirm:$false
```

