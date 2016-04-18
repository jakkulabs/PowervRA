# Get-vRAStorageReservationPolicy

## SYNOPSIS
    
Retrieve vRA Storage Reservation Policies

## SYNTAX
 Get-vRAStorageReservationPolicy [-Limit <String>] [<CommonParameters>] Get-vRAStorageReservationPolicy -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAStorageReservationPolicy -Name <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Storage Reservation Policies

## PARAMETERS


### Id

Specify the ID of a Storage Reservation Policy

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Specify the Name of a Storage Reservation Policy

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: named
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAStorageReservationPolicy







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAStorageReservationPolicy -Id "068afd10-560f-4360-aa52-786a28573fdc"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAStorageReservationPolicy -Name "StorageReservationPolicy01","StorageReservationPolicy02"
```

