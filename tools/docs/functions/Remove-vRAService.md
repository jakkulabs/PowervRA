# Remove-vRAService

## SYNOPSIS
Remove a vRA Service

## SYNTAX

```
Remove-vRAService [-Id] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a vRA Service

## EXAMPLES

### EXAMPLE 1
```
Remove-vRAService -Id "d00d3631-997c-40f7-90e8-7ccbc153c20c"
```

### EXAMPLE 2
```
Get-vRAService -Id "d00d3631-997c-40f7-90e8-7ccbc153c20c" | Remove-vRAService
```

### EXAMPLE 3
```
Get-vRAService | Where-Object {$_.name -ne "Default Service"} | Remove-vRAService
```

## PARAMETERS

### -Id
The id of the service

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### None

## NOTES

## RELATED LINKS
