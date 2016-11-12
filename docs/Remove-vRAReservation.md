# Remove-vRAReservation

## SYNOPSIS
Remove a reservation

## SYNTAX

### ById (Default)
```
Remove-vRAReservation -Id <String[]> [-WhatIf] [-Confirm]
```

### ByName
```
Remove-vRAReservation -Name <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a reservation

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRAReservation -Name Reservation1
```

### -------------------------- EXAMPLE 2 --------------------------
```
Remove-vRAReservation -Id 75ae3400-beb5-4b0b-895a-0484413c93b1
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAReservation -Name Reservation1 | Remove-vRAReservation
```

## PARAMETERS

### -Id
The id of the reservation

```yaml
Type: String[]
Parameter Sets: ById
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
Type: String[]
Parameter Sets: ByName
Aliases: 

Required: True
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

## OUTPUTS

## NOTES

## RELATED LINKS

