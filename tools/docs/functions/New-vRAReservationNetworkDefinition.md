# New-vRAReservationNetworkDefinition

## SYNOPSIS
Creates a new network definition for a reservation.

## SYNTAX

```
New-vRAReservationNetworkDefinition -Type <String> -ComputeResourceId <String> -NetworkPath <String>
 [-NetworkProfile <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new network definition for a reservation.
This cmdlet is used to create a custom
complex network object.
One or more of these can be added to an array and passed to New-vRAReservation.

## EXAMPLES

### EXAMPLE 1
```
# Create a network definition for type vSphere in vRA 7.1
```

$NetworkDefinitionArray = @()
$Network1 = New-vRAReservationNetworkDefinition -Type 'vSphere' -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 -NetworkPath 'VM Network' -NetworkProfile 'Test'
$NetworkDefinitionArray += $Network1

### EXAMPLE 2
```
# Create a network definition for type vSphere in vRA 7.2 and later
```

$NetworkDefinitionArray = @()
$Network1 = New-vRAReservationNetworkDefinition -Type 'vSphere (vCenter)' -ComputeResourceId 75ae3400-beb5-4b0b-895a-0484413c93b1 -NetworkPath 'VM Network' -NetworkProfile 'Test'
$NetworkDefinitionArray += $Network1

## PARAMETERS

### -Type
The reservation type
Valid types vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere, XenServer
Valid types vRA 7.2 and later: Amazon EC2, Azure, Hyper-V (SCVMM), Hyper-V (Standalone), KVM (RHEV), OpenStack, vCloud Air, vCloud Director, vSphere (vCenter), XenServer

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
