# Get-vRAReservationType

## SYNOPSIS
    
Get supported reservation types

## SYNTAX
 Get-vRAReservationType [-Limit <Int32>] [-Page <Int32>] [<CommonParameters>] Get-vRAReservationType -Id <String[]> [<CommonParameters>] Get-vRAReservationType -Name <String[]> [<CommonParameters>]    

## DESCRIPTION

Get supported reservation types

## PARAMETERS


### Id

The id of the reservation type

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Name

The name of the reservation type

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

The page of response to return. All pages are retuend by default.

* Required: false
* Position: named
* Default value: 1
* Accept pipeline input: false

## INPUTS

System.String.
System.Int.

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservationType -Id "Infrastructure.Reservation.Cloud.vCloud"







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAReservationType -Name "vCloud Director"







-------------------------- EXAMPLE 3 --------------------------

PS C:\>Get-vRAReservationType
```

