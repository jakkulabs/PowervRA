# Get-vRABlueprint

## SYNOPSIS
Retrieve vRA Blueprints

## SYNTAX

### Standard (Default)
```
Get-vRABlueprint [-ExtendedProperties] [-Limit <String>] [<CommonParameters>]
```

### ById
```
Get-vRABlueprint -Id <String[]> [-ExtendedProperties] [-Limit <String>] [<CommonParameters>]
```

### ByName
```
Get-vRABlueprint -Name <String[]> [-ExtendedProperties] [-Limit <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve vRA Blueprints

## EXAMPLES

### EXAMPLE 1
```
Get-vRABlueprint
```

### EXAMPLE 2
```
Get-vRABlueprint -Id "309100fd-b8ce-4e8c-ac8c-a667b8ace54f"
```

### EXAMPLE 3
```
Get-vRABlueprint -Name "Blueprint01","Blueprint02"
```

### EXAMPLE 4
```
Get-vRABlueprint -Name "Blueprint01","Blueprint02" -ExtendedProperties
```

## PARAMETERS

### -Id
Specify the ID of a Blueprint

```yaml
Type: String[]
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
Specify the Name of a Blueprint

```yaml
Type: String[]
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtendedProperties
Return Blueprint Extended Properties.
Performance will be slower since
additional API requests may be required

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
