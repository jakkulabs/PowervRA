# Remove-vRABusinessGroup

## SYNOPSIS
Remove a vRA Business Group

## SYNTAX

### Id (Default)
```
Remove-vRABusinessGroup -TenantId <String> -Id <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Remove-vRABusinessGroup -TenantId <String> -Name <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a vRA Business Group

## EXAMPLES

### EXAMPLE 1
```
Remove-vRABusinessGroup -TenantId Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"
```

### EXAMPLE 2
```
Remove-vRABusinessGroup -TenantId Tenant01 -Name "BusinessGroup01","BusinessGroup02"
```

### EXAMPLE 3
```
Get-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01 | Remove-vRABusinessGroup -Confirm:$false
```

## PARAMETERS

### -TenantId
Tenant Id

```yaml
Type: String
Parameter Sets: (All)
Aliases: Tenant

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
Business Group Id

```yaml
Type: String[]
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Business Group Name

```yaml
Type: String[]
Parameter Sets: Name
Aliases:

Required: True
Position: Named
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

### System.String.

## OUTPUTS

### None

## NOTES

## RELATED LINKS
