# New-vRAReservation

## SYNOPSIS
    
Create a new reservation

## SYNTAX
 New-vRAReservation -Type <String> -Name <String> [-Tenant <String>] -BusinessGroup <String> [-ReservationPolicy  <String>] [-Priority <Int32>] -ComputeResourceId <String> [-Quota <Int32>] -MemoryGB <Int32> -Storage <PSObject[]>  [-Network <PSObject[]>] [-ResourcePool <String>] [-EnableAlerts] [-EmailBusinessGroupManager] [-AlertRecipients  <String[]>] [-StorageAlertPercentageLevel <Int32>] [-MemoryAlertPercentageLevel <Int32>] [-CPUAlertPercentageLevel  <Int32>] [-MachineAlertPercentageLevel <Int32>] [-AlertReminderFrequency <Int32>] [-WhatIf] [-Confirm]  [<CommonParameters>] New-vRAReservation -JSON <String> [-NewName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]    

## DESCRIPTION

Create a new reservation

## PARAMETERS


### Type

The reservation type

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

### Tenant

The tenant that will own the reservation

* Required: false
* Position: named
* Default value: $Global:vRAConnection.Tenant
* Accept pipeline input: false

### BusinessGroup

The business group that will be associated with the reservation

* Required: true
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

### ComputeResourceId

The compute resource that will be associated with the reservation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Quota

The number of machines that can be provisioned in the reservation

* Required: false
* Position: named
* Default value: 0
* Accept pipeline input: false

### MemoryGB

The amount of memory available to this reservation

* Required: true
* Position: named
* Default value: 0
* Accept pipeline input: false

### Storage

The storage that will be associated with the reservation

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: false

### Network

The network that will be associated with this reservation

* Required: false
* Position: named
* Default value: 
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
* Default value: 80
* Accept pipeline input: false

### MemoryAlertPercentageLevel

The threshold for memory alerts

* Required: false
* Position: named
* Default value: 80
* Accept pipeline input: false

### CPUAlertPercentageLevel

The threshold for cpu alerts

* Required: false
* Position: named
* Default value: 80
* Accept pipeline input: false

### MachineAlertPercentageLevel

The threshold for machine alerts

* Required: false
* Position: named
* Default value: 80
* Accept pipeline input: false

### AlertReminderFrequency

Alert frequency in days

* Required: false
* Position: named
* Default value: 20
* Accept pipeline input: false

### JSON

Body text to send in JSON format

* Required: true
* Position: named
* Default value: 
* Accept pipeline input: true (ByValue)

### NewName

If passing a JSON payload NewName can be used to set the reservation name

* Required: false
* Position: named
* Default value: 
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

PS C:\># --- Get the compute resource id


$ComputeResource = Get-vRAReservationComputeResource -Type vSphere -Name "Cluster01 (vCenter)"

# --- Get the network definition
$NetworkDefinitionArray = @()
$Network1 = New-vRAReservationNetworkDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -NetworkPath "VM 
Network" -NetworkProfile "Test-Profile"
$NetworkDefinitionArray += $Network1

# --- Get the storage definition
$StorageDefinitionArray = @()
$Storage1 = New-vRAReservationStorageDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -Path 
"Datastore1" -ReservedSizeGB 10 -Priority 0 
$StorageDefinitionArray += $Storage1

# --- Set the parameters and create the reservation
$Param = @{

    Type = "vSphere"
    Name = "Reservation01"
    Tenant = "Tenant01"
    BusinessGroup = "Default Business Group[Tenant01]"
    ReservationPolicy = "ReservationPolicy1"
    Priority = 0
    ComputeResourceId = $ComputeResource.Id
    Quota = 0
    MemoryGB = 2048
    Storage = $StorageDefinitionArray
    ResourcePool = "Resources"
    Network = $NetworkDefinitionArray
    EnableAlerts = $false

}

New-vRAReservation @Param -Verbose
```

