# Import-vRAIcon

## SYNOPSIS
Imports a vRA Icon

## SYNTAX

```
Import-vRAIcon [-Id] <String[]> [-File] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Imports a vRA Icon

## EXAMPLES

### EXAMPLE 1
```
Import-vRAIcon -Id "cafe_default_icon_genericAllServices" -File C:\Icons\NewIcon.png
```

Update the default All Services Icon with a new image file.
Note: admin permissions for the default vRA Tenant are required for this action.

### EXAMPLE 2
```
Get-ChildItem -Path C:\Icons\NewIcon.png | Import-vRAIcon -Id "cafe_default_icon_genericAllServices" -Confirm:$false
```

Update the default All Services Icon with a new image file via the pipeline.
Note: admin permissions for the default vRA Tenant are required for this action.

### EXAMPLE 3
```
Import-vRAIcon -Id "cafe_icon_Service01" -File C:\Icons\Service01Icon.png -Confirm:$false
```

Create a new Icon named cafe_icon_Service01

## PARAMETERS

### -Id
Specify the ID of an Icon

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
The Icon file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
