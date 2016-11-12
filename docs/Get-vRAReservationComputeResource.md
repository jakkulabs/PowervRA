---
external help file: Get-vRAReservationComputeResource-help.xml
online version: 
schema: 2.0.0
---

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
Get-vRAReservationComputeResource -Type vSphere -Id 75ae3400-beb5-4b0b-895a-0484413c93b1
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAReservationComputeResource -Type vSphere -Name "Cluster01"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAReservationComputeResource -Type vSphere
```

## PARAMETERS

### -Type
The resource type

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

