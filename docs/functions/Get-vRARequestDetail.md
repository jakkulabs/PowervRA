# Get-vRARequestDetail

## SYNOPSIS
Get detailed information about vRA request

## SYNTAX

### ById (Default)
```
Get-vRARequestDetail -Id <String[]> [<CommonParameters>]
```

### ByRequestNumber
```
Get-vRARequestDetail -RequestNumber <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get detailed information about vRA request.
These are result produced by the request (if any)

## EXAMPLES

### EXAMPLE 1
```
Get-vRARequestDetail -Id 972ab103-950a-4240-8a3d-97174ee07f35
```

### EXAMPLE 2
```
Get-vRARequestDetail -RequestNumber 965299
```

### EXAMPLE 3
```
Get-vRARequestDetail -RequestNumber 965299,965300
```

### EXAMPLE 4
```
Get-vRARequest -RequestNumber 965299 | Get-vRARequestDetail
```

## PARAMETERS

### -Id
The Id of the request to query

```yaml
Type: String[]
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -RequestNumber
The request number of the request to query

```yaml
Type: String[]
Parameter Sets: ByRequestNumber
Aliases:

Required: True
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
