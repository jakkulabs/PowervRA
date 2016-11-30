# Get-vRAReservationComputeResourceMemory

## SYNOPSIS
Get available memory for a compute resource

## SYNTAX

```
Get-vRAReservationComputeResourceMemory [-Type] <String> [-ComputeResourceId] <String>
```

## DESCRIPTION
Get available memory for a compute resource

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAReservationComputeResourceMemory -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d
```

## PARAMETERS

### -Type
The reservation type

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
{{Fill ComputeResourceId Description}}

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

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

