# Set-vRAReservationNetwork

## SYNOPSIS
Set vRA reservation network properties

## SYNTAX
<<<<<<< HEAD

```
Set-vRAReservationNetwork [-Id] <String> [-NetworkPath] <String> [[-NetworkProfile] <String>] [-WhatIf]
 [-Confirm]
```

## DESCRIPTION
Set vRA reservation network properties.

This function enables you to:

- Add a new network path to a reservation
- Add a new network path to a reservation and assign a network profile
- Update the network profile of an existing network path

If the network path you supply is already selected in the reservation and no network profile is supplied, no action will be taken.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "VM Network" -NetworkProfile "Test Profile 1"
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "VM Network" -NetworkProfile "Test Profile 2"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAReservation -Name "Reservation01" | Set-vRAReservationNetwork -NetworkPath "Test Network"
```

## PARAMETERS

=======

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

>>>>>>> master
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
<<<<<<< HEAD

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

=======

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

>>>>>>> master
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

<<<<<<< HEAD
### System.String

## OUTPUTS

### None
=======
### System.String.

## OUTPUTS

### System.Management.Automation.PSObject
>>>>>>> master

## NOTES

## RELATED LINKS

