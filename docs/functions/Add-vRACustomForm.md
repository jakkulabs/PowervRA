# Add-vRACustomForm

## SYNOPSIS
Add a vRA Custom Form for a Blueprint

## SYNTAX

```
Add-vRACustomForm [-BlueprintId] <String[]> [-Body] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add a vRA Custom Form for a Blueprint

## EXAMPLES

### EXAMPLE 1
```
$JSON = Get-Content -Path ~/CentOS.json -Raw
```

Add-vRACustomForm -BlueprintId "CentOS" -Body $JSON

### EXAMPLE 2
```
$JSON = Get-Content -Path ~/CentOS.json -Raw
```

Get-vRABlueprint -Name "CentOS" | Add-vRACustomForm -Body $JSON

### EXAMPLE 3
```
$Form = Get-vRABlueprint -Name "CentOS" | Get-vRACustomForm
```

Add-vRACustomForm -BlueprintId "RHEL7" | Add-vRACustomForm -Body $Form.JSON

## PARAMETERS

### -BlueprintId
Specify the ID of a Blueprint

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Body
The JSON string containing the custom form

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

### System.String

## NOTES

## RELATED LINKS
