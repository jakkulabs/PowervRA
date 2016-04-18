# Get-vRAReservation

## SYNOPSIS
    
Get a reservation

## SYNTAX
 Get-vRAReservation [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>] Get-vRAReservation -Id <String[]> [<CommonParameters>] Get-vRAReservation -Name <String[]> [<CommonParameters>]    

## DESCRIPTION

Get a reservation

## PARAMETERS


### Id

The id of the reservation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The name of the reservation

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

### Page

The page of response to return. All pages are retuend by default

* Required: false
* Position: named
* Default value: 1
* Accept pipeline input: false

## INPUTS

System.String
System.Int

## OUTPUTS

System.Management.Automation.PSObject
System.Object[]

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAReservation -Name Reservation1







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAReservation
```

