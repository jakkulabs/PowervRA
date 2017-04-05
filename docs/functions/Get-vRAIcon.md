# Get-vRAIcon

## SYNOPSIS
Retrieve a vRA Icon

## SYNTAX

```
Get-vRAIcon [-Id] <String[]>
```

## DESCRIPTION
Retrieve a vRA Icon

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAIcon -Id "cafe_default_icon_genericAllServices"
```

Get the default All Services Icon.
Note: admin permissions for the default vRA Tenant are required for this action.

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAIcon -Id "cafe_icon_Service01"
```

Get the vRA Icon named cafe_icon_Service01

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
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

