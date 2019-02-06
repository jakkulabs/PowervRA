# Remove-vRAStorageReservationPolicy

## SYNOPSIS
Remove a vRA Storage Reservation Policy

## SYNTAX

### ById (Default)
```
Remove-vRAStorageReservationPolicy -Id <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByName
```
Remove-vRAStorageReservationPolicy -Name <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a vRA Storage Reservation Policy

## EXAMPLES

### EXAMPLE 1
```
Remove-vRAStorageReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd"
```

### EXAMPLE 2
```
Remove-vRAStorageReservationPolicy -Name "StorageReservationPolicy01"
```

### EXAMPLE 3
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.

## OUTPUTS

### None

## NOTES

## RELATED LINKS
