# Remove-vRAIcon

## SYNOPSIS
Remove a vRA Icon

## SYNTAX

```
Remove-vRAIcon [-Id] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove a vRA Icon from the service catalog.
If the icon is one of the default system icons, it will be reverted to its default state instead of being deleted.

## EXAMPLES

### EXAMPLE 1
```
Remove-vRAIcon -Id "cafe_default_icon_genericAllServices"
```

Set the default All Services Icon back to the original icon.
Note: admin permissions for the default vRA Tenant are required for this action.

### EXAMPLE 2
```
Get-vRAIcon -Id "cafe_icon_Service01" | Remove-vRAIcon -Confirm:$false
```

Delete the Icon named cafe_icon_Service01

## PARAMETERS

### -Id
The id of the Icon

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
