# Export-vRAIcon

## SYNOPSIS
Export a vRA Icon

## SYNTAX

```
Export-vRAIcon [-Id] <String[]> [-File] <String>
```

## DESCRIPTION
Export a vRA Icon

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
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

## INPUTS

### System.String

## OUTPUTS

### System.IO.FileInfo

## NOTES

## RELATED LINKS

