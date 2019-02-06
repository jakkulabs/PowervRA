# Get-vRAReservationPolicy

## SYNOPSIS
Retrieve vRA Reservation Policies

## SYNTAX

### Standard (Default)
```
Get-vRAReservationPolicy [-Limit <String>] [<CommonParameters>]
```

### ById
```
Get-vRAReservationPolicy -Id <String[]> [-Limit <String>] [<CommonParameters>]
```

### ByName
```
Get-vRAReservationPolicy -Name <String[]> [-Limit <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve vRA Reservation Policies

## EXAMPLES

### EXAMPLE 1
```
Get-vRAReservationPolicy
```

### EXAMPLE 2
```
Get-vRAReservationPolicy -Id "068afd10-560f-4360-aa52-786a28573fdc"
```

### EXAMPLE 3
```
Get-vRAReservationPolicy -Name "ReservationPolicy01","ReservationPolicy02"
```

## PARAMETERS

### -Id
Specify the ID of a Reservation Policy

```yaml
Type: String[]
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specify the Name of a Reservation Policy

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

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
