# Get-vRAReservationPolicy

## SYNOPSIS
    
Retrieve vRA Reservation Policies

## SYNTAX
 Get-vRAReservationPolicy [-Limit <String>] [<CommonParameters>] Get-vRAReservationPolicy -Id <String[]> [-Limit <String>] [<CommonParameters>] Get-vRAReservationPolicy -Name <String[]> [-Limit <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Reservation Policies

## PARAMETERS


### Id

Specify the ID of a Reservation Policy

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

Specify the Name of a Reservation Policy

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

PS C:\>Get-vRAReservationPolicy







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAReservationPolicy -Id "068afd10-560f-4360-aa52-786a28573fdc"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAReservationPolicy -Name "ReservationPolicy01","ReservationPolicy02"
```

