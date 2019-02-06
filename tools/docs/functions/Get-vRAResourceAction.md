# Get-vRAResourceAction

## SYNOPSIS
Retrieve available Resource Actions for a resource

## SYNTAX

```
Get-vRAResourceAction [-ResourceId] <String[]> [<CommonParameters>]
```

## DESCRIPTION
A resourceAction is a specific type of ResourceOperation that is performed by submitting a request.

## EXAMPLES

### EXAMPLE 1
```
Get-vRAResource -Name vm01 | Get-vRAResourceAction
```

### EXAMPLE 2
```
Get-vRAResource -Name vm01 | Get-vRAResourceAction | Select Id, Name, BindingId
```

## PARAMETERS

### -ResourceId
The id of the resource

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
