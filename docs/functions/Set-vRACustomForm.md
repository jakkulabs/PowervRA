# Set-vRACustomForm

## SYNOPSIS
Enable or Disable vRA Custom Form for a Blueprint

## SYNTAX

```
Set-vRACustomForm [-BlueprintId] <String[]> [-Action] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Enable or Disable a vRA Custom Form to a Blueprint

## EXAMPLES

### EXAMPLE 1
```
Set-vRACustomForm -BlueprintId "CentOS" -Action Enable
```

### EXAMPLE 2
```
Set-vRACustomForm -BlueprintId "CentOS" -Action Disable
```

### EXAMPLE 3
```
Get-vRABlueprint -Name "CentOS" | Set-vRACustomForm -Action Enable
```

## PARAMETERS

### -BlueprintId
The objectId of the blueprint

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Action
The action to take on the Custom Form of the Blueprint

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
