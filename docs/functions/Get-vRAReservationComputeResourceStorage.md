# Get-vRAReservationComputeResourceStorage

## SYNOPSIS
Get available storage for a compute resource

## SYNTAX

### Standard (Default)
```
Get-vRAReservationComputeResourceStorage -Type <String> -ComputeResourceId <String>
```

### ByName
```
Get-vRAReservationComputeResourceStorage -Type <String> -ComputeResourceId <String> -Name <String[]>
```

## DESCRIPTION
Get available storage for a compute resource

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.1
```

Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve all associated compute resource storage for the desired reservation type in vRA 7.1
Get-vRAReservationComputeResourceStorage -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d

### -------------------------- EXAMPLE 2 --------------------------
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.1
```

Get-vRAReservationComputeResource -Type 'vSphere' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve associated compute resource storage for the desired reservation type in vRA 7.1
Get-vRAReservationComputeResourceStorage -Type 'vSphere' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name DataStore01

### -------------------------- EXAMPLE 3 --------------------------
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
```

Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name 'Cluster01 (vCenter)' | Select-Object -ExpandProperty Id

# Retrieve associated compute resource storage for the desired reservation type in vRA 7.2 and later
Get-vRAReservationComputeResourceStorage -Type 'vSphere (vCenter)' -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name DataStore01

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
The name of the storage

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

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

