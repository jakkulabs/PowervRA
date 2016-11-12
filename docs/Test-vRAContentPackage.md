# Test-vRAContentPackage

## SYNOPSIS
Validates a vRA Content Package

## SYNTAX

```
Test-vRAContentPackage [-File] <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Validates a vRA Content Package

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Test-vRAContentPackage -File C:\Packages\ContentPackage100.zip
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-ChildItem -Path C:\Packages\ContentPackage100.zip| Test-vRAContentPackage
```

## PARAMETERS

### -File
The content package file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### System.String

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

