# Add-vRAReservationStorage

## SYNOPSIS
Add storage to an existing vRA reservation

## SYNTAX

```
Add-vRAReservationStorage [-Id] <String> [-Path] <String> [-ReservedSizeGB] <Int32> [[-Priority] <Int32>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet enables the user to add new storage to a reservation.
Only one new storage path can be added at a time.
If a duplicate storage path is detected, the API will throw an error.

## EXAMPLES

### EXAMPLE 1
```
Get-vRAReservation -Name Reservation01 | Add-vRAReservationStorage -Path "Datastore01" -ReservedSizeGB 500 -Priority 1
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
The size in GB of this reservation

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.
System.Int.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
