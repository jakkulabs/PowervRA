# New-vRAReservationPolicy

## SYNOPSIS
Create a vRA Reservation Policy

## SYNTAX

### Standard (Default)
```
New-vRAReservationPolicy -Name <String> [-Description <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### JSON
```
New-vRAReservationPolicy -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a vRA Reservation Policy

## EXAMPLES

### EXAMPLE 1
```
New-vRAReservationPolicy -Name ReservationPolicy01 -Description "This is Reservation Policy 01"
```

### EXAMPLE 2
```
$JSON = @"
```

{
  "name": "ReservationPolicy01",
  "description": "This is Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
}
"@
$JSON | New-vRAReservationPolicy

## PARAMETERS

### -Name
Reservation Policy Name

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
Reservation Policy Description

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
