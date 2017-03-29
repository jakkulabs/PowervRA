# Remove-vRAStorageReservationPolicy

## SYNOPSIS
Remove a vRA Storage Reservation Policy

## SYNTAX

### ById (Default)
```
Remove-vRAStorageReservationPolicy -Id <String[]> [-WhatIf] [-Confirm]
```

### ByName
```
Remove-vRAStorageReservationPolicy -Name <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a vRA Storage Reservation Policy

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRAStorageReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd"
```

### -------------------------- EXAMPLE 2 --------------------------
```
Remove-vRAStorageReservationPolicy -Name "StorageReservationPolicy01"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAStorageReservationPolicy -Name "StorageReservationPolicy01" | Remove-vRAStorageReservationPolicy -Confirm:$false
```

## PARAMETERS

### -Id
Storage Reservation Policy ID

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
Storage Reservation Policy Name

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

