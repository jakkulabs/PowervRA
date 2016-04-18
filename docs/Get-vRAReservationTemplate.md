# Get-vRAReservationTemplate

## SYNOPSIS
    
Get a reservation json template

## SYNTAX
 Get-vRAReservationTemplate [-Id] <String> [[-OutFile] <String>] [<CommonParameters>]    

## DESCRIPTION

Get a reservation json template. This template can then be used to create a new reservation with the same properties

## PARAMETERS


### Id

The id of the reservation

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### OutFile

The path to an output file

* Required: false
* Position: 2
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.String

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservationTemplate -Id 75ae3400-beb5-4b0b-895a-0484413c93b1 -OutFile C:\Reservation.json







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAReservation -Name Reservation1 | Get-vRAReservationTemplate -OutFile C:\Reservation.json







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAReservation -Name Reservation1 | Get-vRAReservationTemplate
```

