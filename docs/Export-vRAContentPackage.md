---
external help file: Export-vRAContentPackage-help.xml
online version: 
schema: 2.0.0
---

# Export-vRAContentPackage

## SYNOPSIS
Export a vRA Content Package

## SYNTAX

### ById (Default)
```
Export-vRAContentPackage -Id <String[]> [-Path <String>]
```

### ByName
```
Export-vRAContentPackage -Name <String[]> [-Path <String>]
```

## DESCRIPTION
Export a vRA Content Package

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Export-vRAContentPackage -Id "b2d72c5d-775b-400c-8d79-b2483e321bae" -Path C:\Packages\ContentPackage01.zip
```

### -------------------------- EXAMPLE 2 --------------------------
```
Export-vRAContentPackage -Name "ContentPackage01" -Path C:\Packages\ContentPackage01.zip
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAContentPackage | Export-vRAContentPackage
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAContentPackage -Name "ContentPackage01" | Export-vRAContentPackage -Path C:\Packages\ContentPackage01.zip
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
Accept pipeline input: True (ByPropertyName)
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

### -Path
The resulting path.
If this parameter is not passed the action will be exported to
the current working directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.IO.FileInfo

## NOTES

## RELATED LINKS

