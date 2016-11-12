---
external help file: Get-vRABlueprint-help.xml
online version: 
schema: 2.0.0
---

# Get-vRABlueprint

## SYNOPSIS
Retrieve vRA Blueprints

## SYNTAX

### Standard (Default)
```
Get-vRABlueprint [-Limit <String>]
```

### ById
```
Get-vRABlueprint -Id <String[]> [-Limit <String>]
```

### ByName
```
Get-vRABlueprint -Name <String[]> [-Limit <String>]
```

## DESCRIPTION
Retrieve vRA Blueprints

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRABlueprint
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRABlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRABlueprint -Name "Blueprint01","Blueprint02"
```

## PARAMETERS

### -Id
Specify the ID of a Blueprint

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
Specify the Name of a Blueprint

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

