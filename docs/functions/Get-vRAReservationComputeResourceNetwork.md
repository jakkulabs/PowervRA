# Get-vRAReservationComputeResourceNetwork

## SYNOPSIS
Get available networks for a compute resource

## SYNTAX

### Standard (Default)
```
Get-vRAReservationComputeResourceNetwork -Type <String> -ComputeResourceId <String>
```

### ByName
```
Get-vRAReservationComputeResourceNetwork -Type <String> -ComputeResourceId <String> -Name <String[]>
```

## DESCRIPTION
Get available network for a compute resource

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservationComputeResourceNetwork -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name VMNetwork
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAReservationComputeResourceNetwork -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d
```

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
{{Fill ComputeResourceId Description}}

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
The name of the network

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

