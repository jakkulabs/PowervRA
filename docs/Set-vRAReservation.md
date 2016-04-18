# Set-vRAReservation

## SYNOPSIS
    
Set a vRA reservation

## SYNTAX
 Set-vRAReservation -Id <String> [-Name <String>] [-ReservationPolicy <String>] [-Priority <Int32>] [-Enabled] [-Quota  <Int32>] [-MemoryGB <Int32>] [-ResourcePool <String>] [-EnableAlerts] [-EmailBusinessGroupManager] [-AlertRecipients  <String[]>] [-StorageAlertPercentageLevel <Int32>] [-MemoryAlertPercentageLevel <Int32>] [-CPUAlertPercentageLevel  <Int32>] [-MachineAlertPercentageLevel <Int32>] [-AlertFrequencyReminder <Int32>] [-WhatIf] [-Confirm]  [<CommonParameters>]    

## DESCRIPTION

Set a vRA reservation

## PARAMETERS


### Id

The Id of the reservation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByPropertyName)

### Name

The name of the reservation

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### ReservationPolicy

The reservation policy that will be associated with the reservation

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Priority

The priority of the reservation

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### Enabled


* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### Quota

The number of machines that can be provisioned in the reservation

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### MemoryGB

The amount of memory available to this reservation

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### ResourcePool

The resource pool that will be associated with this reservation

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### EnableAlerts

Enable alerts

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### EmailBusinessGroupManager

Email the alerts to the business group manager

* Required: false
* Position: named
* Default value: False
* Accept pipeline input: false

### AlertRecipients

The recipients that will recieve email alerts

* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### StorageAlertPercentageLevel

The threshold for storage alerts

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### MemoryAlertPercentageLevel

The threshold for memory alerts

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### CPUAlertPercentageLevel

The threshold for cpu alerts

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### MachineAlertPercentageLevel

The threshold for machine alerts

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### AlertFrequencyReminder

Alert frequency in days

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

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

System.String
System.Int
System.Management.Automation.SwitchParameter
System.Management.Automation.PSObject

## OUTPUTS

System.Management.Automation.PSObject

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRAReservation -Name Reservation01 | Set-vRAReservation -Name Reservation01-Updated







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Set-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1 -ReservationPolicy "ReservationPolicy01"
```

