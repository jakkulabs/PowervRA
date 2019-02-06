# Get-vRAResourceMetric

## SYNOPSIS
Retrieve metrics for a deployed resource

## SYNTAX

### Standard (Default)
```
Get-vRAResourceMetric [-Limit <String>] [<CommonParameters>]
```

### ById
```
Get-vRAResourceMetric [-Id <String[]>] [-Limit <String>] [<CommonParameters>]
```

### ByName
```
Get-vRAResourceMetric [-Name <String[]>] [-Limit <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve metrics for a deployed resource

## EXAMPLES

### EXAMPLE 1
```
Get-vRAResourceMetric
```

### EXAMPLE 2
```
Get-vRAConsumerCatalogItem -Name vm01 | Get-vRAResourceMetric
```

### EXAMPLE 3
```
Get-vRAResourceMetric -Id "448fcd09-b8c0-482c-abbc-b3ab818c2e31"
```

### EXAMPLE 4
```
Get-vRAResourceMetric -Name vm01
```

## PARAMETERS

### -Id
The id of the catalog resource

```yaml
Type: String[]
Parameter Sets: ById
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the catalog resource

```yaml
Type: String[]
Parameter Sets: ByName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
