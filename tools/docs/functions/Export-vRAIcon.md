# Export-vRAIcon

## SYNOPSIS
Export a vRA Icon

## SYNTAX

```
Export-vRAIcon [-Id] <String[]> [-File] <String> [<CommonParameters>]
```

## DESCRIPTION
Export a vRA Icon

## EXAMPLES

### EXAMPLE 1
```
Export-vRAIcon -Id "cafe_default_icon_genericAllServices" -File C:\Icons\AllServicesIcon.png
```

Export the default All Services Icon to a local file.
Note: admin permissions for the default vRA Tenant are required for this action.

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
Specify the file to output the icon to

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.IO.FileInfo

## NOTES

## RELATED LINKS
