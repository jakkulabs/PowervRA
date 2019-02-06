# Remove-vRAExternalNetworkProfile

## SYNOPSIS
Remove an external network profile

## SYNTAX

```
Remove-vRAExternalNetworkProfile [-Id] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove an external network profile

## EXAMPLES

### EXAMPLE 1
```
Get-vRAExternalNetworkProfile -Name NetworkProfile01 | Remove-vRAExternalNetworkProfile
```

### EXAMPLE 2
```
Remove-vRExternalANetworkProfile -Id 597ff2c1-a35f-4a81-bfd3-ca014
```

## PARAMETERS

### -Id
The id of the external network profile

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

## NOTES

## RELATED LINKS
