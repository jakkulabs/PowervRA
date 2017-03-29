# New-vRAReservation

## SYNOPSIS
Create a new reservation

## SYNTAX

### Standard (Default)
```
New-vRAReservation -Type <String> -Name <String> [-Tenant <String>] -BusinessGroup <String>
 [-ReservationPolicy <String>] [-Priority <Int32>] -ComputeResourceId <String> [-Quota <Int32>]
 -MemoryGB <Int32> -Storage <PSObject[]> [-Network <PSObject[]>] [-ResourcePool <String>] [-EnableAlerts]
 [-EmailBusinessGroupManager] [-AlertRecipients <String[]>] [-StorageAlertPercentageLevel <Int32>]
 [-MemoryAlertPercentageLevel <Int32>] [-CPUAlertPercentageLevel <Int32>]
 [-MachineAlertPercentageLevel <Int32>] [-AlertReminderFrequency <Int32>] [-WhatIf] [-Confirm]
```

### JSON
```
New-vRAReservation -JSON <String> [-NewName <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a new reservation

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# --- Get the compute resource id
```

$ComputeResource = Get-vRAReservationComputeResource -Type vSphere -Name "Cluster01 (vCenter)"

# --- Get the network definition
$NetworkDefinitionArray = @()
$Network1 = New-vRAReservationNetworkDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -NetworkPath "VM Network" -NetworkProfile "Test-Profile"
$NetworkDefinitionArray += $Network1

# --- Get the storage definition
$StorageDefinitionArray = @()
$Storage1 = New-vRAReservationStorageDefinition -Type vSphere -ComputeResourceId $ComputeResource.Id -Path "Datastore1" -ReservedSizeGB 10 -Priority 0 
$StorageDefinitionArray += $Storage1

# --- Set the parameters and create the reservation
$Param = @{

    Type = "vSphere"
    Name = "Reservation01"
    Tenant = "Tenant01"
    BusinessGroup = "Default Business Group\[Tenant01\]"
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

## PARAMETERS

### -Type
The reservation type

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the reservation

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
The tenant that will own the reservation

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: $Global:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -BusinessGroup
The business group that will be associated with the reservation

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReservationPolicy
The reservation policy that will be associated with the reservation

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
The priority of the reservation

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputeResourceId
The compute resource that will be associated with the reservation

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quota
The number of machines that can be provisioned in the reservation

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemoryGB
The amount of memory available to this reservation

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Storage
The storage that will be associated with the reservation

```yaml
Type: PSObject[]
Parameter Sets: Standard
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
The network that will be associated with this reservation

```yaml
Type: PSObject[]
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourcePool
The resource pool that will be associated with this reservation

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableAlerts
Enable alerts

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailBusinessGroupManager
Email the alerts to the business group manager

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertRecipients
The recipients that will recieve email alerts

```yaml
Type: String[]
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StorageAlertPercentageLevel
The threshold for storage alerts

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemoryAlertPercentageLevel
The threshold for memory alerts

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -CPUAlertPercentageLevel
The threshold for cpu alerts

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -MachineAlertPercentageLevel
The threshold for machine alerts

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertReminderFrequency
Alert frequency in days

```yaml
Type: Int32
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -JSON
Body text to send in JSON format

```yaml
Type: String
Parameter Sets: JSON
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NewName
If passing a JSON payload NewName can be used to set the reservation name

```yaml
Type: String
Parameter Sets: JSON
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String
System.Int
System.Management.Automation.SwitchParameter
System.Management.Automation.PSObject

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

