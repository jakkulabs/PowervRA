# Get-vRACustomForm

## SYNOPSIS
Retrieve vRA Custom Form for a Blueprint

## SYNTAX

```
Get-vRACustomForm [-BlueprintId] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Retrieve vRA Custom Form for a Blueprint

## EXAMPLES

### EXAMPLE 1
```
Get-vRACustomForm -BlueprintId "CentOS"
```

### EXAMPLE 2
```
Get-vRABlueprint -Name "CentOS" | Get-vRACustomForm
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS
