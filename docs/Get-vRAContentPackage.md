---
external help file: Get-vRAContentPackage-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAContentPackage

## SYNOPSIS
Retrieve vRA Content Packages

## SYNTAX

### Standard (Default)
```
Get-vRAContentPackage [-Limit <String>]
```

### ById
```
Get-vRAContentPackage -Id <String[]> [-Limit <String>]
```

### ByName
```
Get-vRAContentPackage -Name <String[]> [-Limit <String>]
```

## DESCRIPTION
Retrieve vRA Content Packages

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAContentPackage
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAContentPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAContentPackage -Name "ContentPackage01","ContentPackage02"
```

## PARAMETERS

### -Id
Specify the ID of a Content Package

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
Specify the Name of a Content Package

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

