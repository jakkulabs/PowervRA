# Get-vRAReservationComputeResourceResourcePool

## SYNOPSIS
Get available resource pools for a compute resource

## SYNTAX

### Standard (Default)
```
Get-vRAReservationComputeResourceResourcePool -Type <String> -ComputeResourceId <String> [<CommonParameters>]
```

### ByName
```
Get-vRAReservationComputeResourceResourcePool -Type <String> -ComputeResourceId <String> -Name <String[]>
 [<CommonParameters>]
```

## DESCRIPTION
Get available resource pools for a compute resource

## EXAMPLES

### EXAMPLE 1
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.1
```

Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve all associated compute resource resource pools for the desired reservation type in vRA 7.1
Get-vRAReservationComputeResourceResourcePool -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

### EXAMPLE 2
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.1
```

Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve associated compute resource resource pool for the desired reservation type in vRA 7.1
Get-vRAReservationComputeResourceResourcePool -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name ResourcePool1

### EXAMPLE 3
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
```

Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve associated compute resource resource pool for the desired reservation type in vRA 7.2 and later
Get-vRAReservationComputeResourceResourcePool -Type 'vSphere (vCenter)' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name ResourcePool1

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

### -Name
The name of the resource pool

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
