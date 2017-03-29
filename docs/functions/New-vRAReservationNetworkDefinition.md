# New-vRAReservationNetworkDefinition

## SYNOPSIS
Creates a new network definition for a reservation.

## SYNTAX

```
New-vRAReservationNetworkDefinition -Type <String> -ComputeResourceId <String> -NetworkPath <String>
 [-NetworkProfile <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Creates a new network definition for a reservation.
This cmdlet is used to create a custom
complex network object.
One or more of these can be added to an array and passed to New-vRAReservation.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$NetworkDefinitionArray = @()
```

$Network1 = New-vRAReservationNetworkDefinition -Type vSphere -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 -Path "VM Network" -Profile "Test"
$NetworkDefinitionArray += $Networ1

## PARAMETERS

### -Type
The reservation type

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputeResourceId
The id of the compute resource

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkPath
The network path

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
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
Position: Named
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

