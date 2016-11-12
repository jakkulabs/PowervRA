---
external help file: Set-vRAReservation-help.xml
online version: 
schema: 2.0.0
---

# Set-vRAReservation

## SYNOPSIS
Set a vRA reservation

## SYNTAX

```
Set-vRAReservation -Id <String> [-Name <String>] [-ReservationPolicy <String>] [-Priority <Int32>] [-Enabled]
 [-Quota <Int32>] [-MemoryGB <Int32>] [-ResourcePool <String>] [-EnableAlerts] [-EmailBusinessGroupManager]
 [-AlertRecipients <String[]>] [-StorageAlertPercentageLevel <Int32>] [-MemoryAlertPercentageLevel <Int32>]
 [-CPUAlertPercentageLevel <Int32>] [-MachineAlertPercentageLevel <Int32>] [-AlertReminderFrequency <Int32>]
 [-WhatIf] [-Confirm]
```

## DESCRIPTION
Set a vRA reservation

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservation -Name Reservation01 | Set-vRAReservation -Name Reservation01-Updated
```

### -------------------------- EXAMPLE 2 --------------------------
```
Set-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1 -ReservationPolicy "ReservationPolicy01"
```

## PARAMETERS

### -Id
The Id of the reservation

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the reservation

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReservationPolicy
The reservation policy that will be associated with the reservation

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
{{Fill Enabled Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quota
The number of machines that can be provisioned in the reservation

```yaml
Type: Int32
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourcePool
The resource pool that will be associated with this reservation

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemoryAlertPercentageLevel
The threshold for memory alerts

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CPUAlertPercentageLevel
The threshold for cpu alerts

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MachineAlertPercentageLevel
The threshold for machine alerts

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertReminderFrequency
Alert frequency in days

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
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

