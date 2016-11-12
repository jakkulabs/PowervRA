# Remove-vRAReservationPolicy

## SYNOPSIS
Remove a vRA Reservation Policy

## SYNTAX

### ById (Default)
```
Remove-vRAReservationPolicy -Id <String[]> [-WhatIf] [-Confirm]
```

### ByName
```
Remove-vRAReservationPolicy -Name <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a vRA Reservation Policy

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRAReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd"
```

### -------------------------- EXAMPLE 2 --------------------------
```
Remove-vRAReservationPolicy -Name "ReservationPolicy01"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAReservationPolicy -Name "ReservationPolicy01" | Remove-vRAReservationPolicy -Confirm:$false
```

## PARAMETERS

### -Id
Reservation Policy ID

```yaml
Type: String[]
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
Reservation Policy Name

```yaml
Type: String[]
Parameter Sets: ByName
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

## OUTPUTS

### None

## NOTES

## RELATED LINKS

