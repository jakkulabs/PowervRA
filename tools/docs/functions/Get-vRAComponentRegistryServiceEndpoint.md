# Get-vRAComponentRegistryServiceEndpoint

## SYNOPSIS
Retrieve a list of endpoints for a service

## SYNTAX

```
Get-vRAComponentRegistryServiceEndpoint [-Id] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Retrieve a list of endpoints for a service

## EXAMPLES

### EXAMPLE 1
```
Get-vRAComponentRegistryServiceEndpoint
```

### EXAMPLE 2
```
Get-vRAComponentRegistryService -Id xxxxxxxxxxxxxxxxxxxxxxxx | Get-vRAComponentRegistryServiceEndpoint
```

## PARAMETERS

### -Id
The Id of the service.
Specifying the Id of the service will retrieve detailed information.

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

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
