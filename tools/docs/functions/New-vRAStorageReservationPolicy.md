# New-vRAStorageReservationPolicy

## SYNOPSIS
Create a vRA Storage Reservation Policy

## SYNTAX

### Standard (Default)
```
New-vRAStorageReservationPolicy -Name <String> [-Description <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### JSON
```
New-vRAStorageReservationPolicy -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a vRA Storage Reservation Policy

## EXAMPLES

### EXAMPLE 1
```
New-vRAStorageReservationPolicy -Name StorageReservationPolicy01 -Description "This is Storage Reservation Policy 01"
```

### EXAMPLE 2
```
$JSON = @"
```

{
  "name": "StorageReservationPolicy01",
  "description": "This is Storage Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.Storage"
}
"@
$JSON | New-vRAStorageReservationPolicy

## PARAMETERS

### -Name
Storage Reservation Policy Name

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

### -Description
Storage Reservation Policy Description

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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
