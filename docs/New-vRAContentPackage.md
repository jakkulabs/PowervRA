# New-vRAContentPackage

## SYNOPSIS
Create a vRA Content Package

## SYNTAX

### ById (Default)
```
New-vRAContentPackage -Name <String> [-Description <String>] -BlueprintId <String[]> [-WhatIf] [-Confirm]
```

### ByName
```
New-vRAContentPackage -Name <String> [-Description <String>] -BlueprintName <String[]> [-WhatIf] [-Confirm]
```

### JSON
```
New-vRAContentPackage [-Description <String>] -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA ContentPackage

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRAContentPackage -Name ContentPackage01 -Description "This is Content Package 01" -BlueprintId "58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f"
```

### -------------------------- EXAMPLE 2 --------------------------
```
New-vRAContentPackage -Name ContentPackage01 -Description "This is Content Package 01" -BlueprintName "Blueprint01","Blueprint02"
```

### -------------------------- EXAMPLE 3 --------------------------
```
$JSON = @"
```

{
    "name":"ContentPackage01",
    "description":"This is Content Package 01",
    "contents":\[ "58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f" \]
}
"@
$JSON | New-vRAContentPackage

## PARAMETERS

### -Name
Content Package Name

```yaml
Type: String
Parameter Sets: ById, ByName
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Content Package Description

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

### -BlueprintId
Blueprint Ids to include in the Content Package

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

### -BlueprintName
Blueprint Names to include in the Content Package

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

### -JSON
Body text to send in JSON format

```yaml
Type: String
Parameter Sets: JSON
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

