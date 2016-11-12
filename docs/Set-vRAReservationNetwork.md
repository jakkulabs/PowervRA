# Set-vRAReservationNetwork

## SYNOPSIS
Set vRA reservation network properties

## SYNTAX

```
Set-vRAReservationNetwork [-Id] <String> [-NetworkPath] <String> [[-NetworkProfile] <String>] [-WhatIf]
 [-Confirm]
```

## DESCRIPTION
Set vRA reservation network properties.
This cmdlet can be used to set the Network Profile for a
Network Path in a reservation.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "VM Network" -NetworkProfile "Test Profile 1"
```

## PARAMETERS

### -Id
The Id of the reservation

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

### -NetworkProfile
The network profile

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
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

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

