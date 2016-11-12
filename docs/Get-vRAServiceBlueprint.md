---
external help file: Get-vRAServiceBlueprint-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAServiceBlueprint

## SYNOPSIS
Retrieve vRA ASD Blueprints

## SYNTAX

### Standard (Default)
```
Get-vRAServiceBlueprint [-Limit <String>]
```

### ById
```
Get-vRAServiceBlueprint -Id <String[]> [-Limit <String>]
```

### ByName
```
Get-vRAServiceBlueprint -Name <String[]> [-Limit <String>]
```

## DESCRIPTION
Retrieve vRA ASD Blueprints

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAServiceBlueprint
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAServiceBlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAServiceBlueprint -Name "ASDBlueprint01","ASDBlueprint02"
```

## PARAMETERS

### -Id
Specify the ID of an ASD Blueprint

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
Specify the Name of an ASD Blueprint

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

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

