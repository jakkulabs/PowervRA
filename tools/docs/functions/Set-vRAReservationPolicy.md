# Set-vRAReservationPolicy

## SYNOPSIS
Update a vRA Reservation Policy

## SYNTAX

### ById (Default)
```
Set-vRAReservationPolicy -Id <String> [-NewName <String>] [-Description <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByName
```
Set-vRAReservationPolicy -Name <String> [-NewName <String>] [-Description <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### JSON
```
Set-vRAReservationPolicy -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update a vRA Reservation Policy

## EXAMPLES

### EXAMPLE 1
```
Set-vRAReservationPolicy -Id "34ae1d6c-9972-4736-acdb-7ee109ad1dbd" -NewName "NewName" -Description "This is the New Name"
```

### EXAMPLE 2
```
Set-vRAReservationPolicy -Name ReservationPolicy01 -NewName "NewName" -Description "This is the New Name"
```

### EXAMPLE 3
```
$JSON = @"
```

{
  "id": "34ae1d6c-9972-4736-acdb-7ee109ad1dbd",
  "name": "ReservationPolicy01",
  "description": "This is Reservation Policy 01",
  "reservationPolicyTypeId": "Infrastructure.Reservation.Policy.ComputeResource"
}
"@
$JSON | Set-vRAReservationPolicy -Confirm:$false

## PARAMETERS

### -Id
Reservation Policy Id

```yaml
Type: String
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Reservation Policy Name

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Reservation Policy NewName

```yaml
Type: String
Parameter Sets: ById, ByName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Reservation Policy Description

```yaml
Type: String
Parameter Sets: ById, ByName
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
