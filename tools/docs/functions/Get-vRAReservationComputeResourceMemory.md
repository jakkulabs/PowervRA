# Get-vRAReservationComputeResourceMemory

## SYNOPSIS
Get available memory for a compute resource

## SYNTAX

```
Get-vRAReservationComputeResourceMemory [-Type] <String> [-ComputeResourceId] <String> [<CommonParameters>]
```

## DESCRIPTION
Get available memory for a compute resource

## EXAMPLES

### EXAMPLE 1
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.1
```

Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve associated compute resource memory for the desired reservation type in vRA 7.1
Get-vRAReservationComputeResourceMemory -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

### EXAMPLE 2
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
```

Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve associated compute resource memory for the desired reservation type in vRA 7.2 and later
Get-vRAReservationComputeResourceMemory -Type 'vSphere (vCenter)' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

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
Position: 1
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
