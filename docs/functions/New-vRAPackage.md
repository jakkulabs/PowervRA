# New-vRAPackage

## SYNOPSIS
Create a vRA Content Package

## SYNTAX

### ById (Default)
```
New-vRAPackage -Name <String> [-Description <String>] -Id <String[]> [-WhatIf] [-Confirm]
```

### ByName
```
New-vRAPackage -Name <String> [-Description <String>] -ContentName <String[]> [-WhatIf] [-Confirm]
```

### JSON
```
New-vRAPackage [-Description <String>] -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA Package

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRAPackage -Name Package01 -Description "This is Content Package 01" -Id "58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f"
```

### -------------------------- EXAMPLE 2 --------------------------
```
New-vRAPackage -Name Package01 -Description "This is Content Package 01" -ContentName "Blueprint01","Blueprint02"
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAContent | New-vRAPackage -Name Package01 - Description "This is Content Package 01"
```

### -------------------------- EXAMPLE 4 --------------------------
```
$JSON = @"
```

{
    "name":"Package01",
    "description":"This is Content Package 01",
    "contents":\[ "58e10956-172a-48f6-9373-932f99eab37a","0c74b085-dbc1-4fea-9cbf-a1601f668a1f" \]
}
"@
$JSON | New-vRAPackage

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

### -Id
A list of content Ids to include in the Package

```yaml
Type: String[]
Parameter Sets: ById
Aliases: ContentId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ContentName
A list of content names to include in the Package

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

