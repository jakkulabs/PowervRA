# Get-vRAComponentRegistryServiceStatus

## SYNOPSIS
Get component registry service status

## SYNTAX

### Standard (Default)
```
Get-vRAComponentRegistryServiceStatus [-Page <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### ById
```
Get-vRAComponentRegistryServiceStatus -Id <String[]> [<CommonParameters>]
```

### ByName
```
Get-vRAComponentRegistryServiceStatus -Name <String[]> [<CommonParameters>]
```

## DESCRIPTION
Get component registry service status

## EXAMPLES

### EXAMPLE 1
```
Get-vRAComponentRegistryServiceStatus
```

### EXAMPLE 2
```
Get-vRAComponentRegistryServiceStatus -Limit 9999
```

### EXAMPLE 3
```
Get-vRAComponentRegistryServiceStatus -Page 1
```

### EXAMPLE 4
```
Get-vRAComponentRegistryServiceStatus -Id xxxxxxxxxxxxxxxxxxxxxxxx
```

### EXAMPLE 5
```
Get-vRAComponentRegistryServiceStatus -Name "iaas-service"
```

## PARAMETERS

### -Id
The Id of the service

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

### -Name
The name of the service

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

### -Page
The index of the page to display.

```yaml
Type: Int32
Parameter Sets: Standard
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: Int32
Parameter Sets: Standard
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
System.Int
System.Management.Automation.SwitchParameter

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
