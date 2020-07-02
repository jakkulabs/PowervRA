# Remove-vRAUserPrincipal

## SYNOPSIS
Remove a vRA local user principal

## SYNTAX

```
Remove-vRAUserPrincipal [-Id] <String[]> [[-Tenant] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a vRA local user principal

## EXAMPLES

### EXAMPLE 1
```
Remove-vRAUserPrincipal -PrincipalId user@vsphere.local
```

### EXAMPLE 2
```
Get-vRAUserPrincipal -Id user@vsphere.local | Remove-vRAUserPrincipal
```

## PARAMETERS

### -Id
The principal id of the user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrincipalId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tenant
The tenant of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:vRAConnection.Tenant
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

### System.String.

## OUTPUTS

### None

## NOTES

## RELATED LINKS
