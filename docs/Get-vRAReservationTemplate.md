# Get-vRAReservationTemplate

## SYNOPSIS
Get a reservation json template

## SYNTAX

```
Get-vRAReservationTemplate [-Id] <String> [[-OutFile] <String>]
```

## DESCRIPTION
Get a reservation json template.
This template can then be used to create a new reservation with the same properties

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservationTemplate -Id 75ae3400-beb5-4b0b-895a-0484413c93b1 -OutFile C:\Reservation.json
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAReservation -Name Reservation1 | Get-vRAReservationTemplate -OutFile C:\Reservation.json
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAReservation -Name Reservation1 | Get-vRAReservationTemplate
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OutFile
The path to an output file

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

