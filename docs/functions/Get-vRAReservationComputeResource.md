# Get-vRAReservationComputeResource

## SYNOPSIS
Get a compute resource for a reservation type

## SYNTAX

### Standard (Default)
```
Get-vRAReservationComputeResource -Type <String>
```

### ById
```
Get-vRAReservationComputeResource -Type <String> -Id <String[]>
```

### ByName
```
Get-vRAReservationComputeResource -Type <String> -Name <String[]>
```

## DESCRIPTION
Get a compute resource for a reservation type

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Retrieve a list of compatible reservation types
```

Get-vRAReservationType | Select Name

# Retrieve associated compute resources for the desired reservation type in vRA 7.1
Get-vRAReservationComputeResource -Type 'vSphere'

### -------------------------- EXAMPLE 2 --------------------------
```
# Retrieve a list of compatible reservation types
```

Get-vRAReservationType | Select Name

# Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
Get-vRAReservationComputeResource -Type 'vSphere (vCenter)'

### -------------------------- EXAMPLE 3 --------------------------
```
# Retrieve associated compute resources for the vSphere reservation type in vRA 7.1
```

Get-vRAReservationComputeResource -Type 'vSphere' -Id 75ae3400-beb5-4b0b-895a-0484413c93b1

### -------------------------- EXAMPLE 4 --------------------------
```
# Retrieve associated compute resources for the vSphere reservation type in vRA 7.2 and later
```

Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Id 75ae3400-beb5-4b0b-895a-0484413c93b1

### -------------------------- EXAMPLE 5 --------------------------
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.1
```

Get-vRAReservationComputeResource -Type 'vSphere' -Name "Cluster01 (vCenter)"

### -------------------------- EXAMPLE 6 --------------------------
```
# Retrieve associated compute resources for the desired reservation type in vRA 7.2 and later
```

Get-vRAReservationComputeResource -Type 'vSphere (vCenter)' -Name "Cluster01 (vCenter)"

## PARAMETERS

### -Type
The resource type
Valid types vRA 7.1 and earlier: Amazon, Hyper-V, KVM, OpenStack, SCVMM, vCloud Air, vCloud Director, vSphere,XenServer
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

### -Id
The id of the compute resource

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
The name of the compute resource

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

