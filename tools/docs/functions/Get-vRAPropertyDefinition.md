# Get-vRAPropertyDefinition

## SYNOPSIS
Get a property that the user is allowed to review.

## SYNTAX

### Standard (Default)
```
Get-vRAPropertyDefinition [-Page <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### ById
```
Get-vRAPropertyDefinition -Id <String[]> [<CommonParameters>]
```

## DESCRIPTION
API for property definitions that a system administrator can interact with.
It allows the user to interact 
with property definitions that the user is permitted to review.

## EXAMPLES

### EXAMPLE 1
```
Get-vRAPropertyDefinition
```

### EXAMPLE 2
```
Get-vRAPropertyDefinition -Limit 200
```

### EXAMPLE 3
```
Get-vRAPropertyDefinition -Id Hostname
```

## PARAMETERS

### -Id
The id of the property definition

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
This has a default value of 100

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

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
