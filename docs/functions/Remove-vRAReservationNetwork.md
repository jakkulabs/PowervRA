# Remove-vRAReservationNetwork

## SYNOPSIS
Remove a network from a reservation

## SYNTAX

```
Remove-vRAReservationNetwork [-Id] <String> [-NetworkPath] <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a network from a reservation

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservation -Name Reservation01 | Remove-vRAReservationNetwork -NetworkPath "DMZ"
```

### -------------------------- EXAMPLE 2 --------------------------
```
Remove-vRAReservationNetwork -Id 8731ceb3-01cd-4dd6-834e-49a9aa8057d8 -NetworkPath
```

## PARAMETERS

### -Id
The id of the reservation

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -NetworkPath
The network path

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

## OUTPUTS

## NOTES

## RELATED LINKS

