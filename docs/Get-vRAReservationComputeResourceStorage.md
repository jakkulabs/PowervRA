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
Get-vRAReservationComputeResourceStorage -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d -Name DataStore01
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAReservationComputeResourceStorage -Type vSphere -ComputeResourceId 0c0a6d46-4c37-4b82-b427-c47d026bf71d
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

