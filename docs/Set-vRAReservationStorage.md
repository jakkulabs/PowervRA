---
external help file: Set-vRAReservationStorage-help.xml
online version: 
schema: 2.0.0
---

# Set-vRAReservationStorage

## SYNOPSIS
Set vRA reservation storage properties

## SYNTAX

```
Set-vRAReservationStorage [-Id] <String> [-Path] <String> [[-ReservedSizeGB] <Int32>] [[-Priority] <Int32>]
 [-Enabled] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Set vRA reservation storage properties

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservation -Name "Reservation01" | Set-vRAReservationStorage -Path "Datastore01"  -ReservedSizeGB 20 -Priority 10
```

## PARAMETERS

### -Id
The Id of the reservation

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
The storage path

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReservedSizeGB
{{Fill ReservedSizeGB Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
The priority of storage

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
The status of the storage

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

### System.String.
System.Int.
System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

