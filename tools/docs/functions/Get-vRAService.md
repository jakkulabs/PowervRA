# Get-vRAService

## SYNOPSIS
Retrieve vRA services that the user is has access to

## SYNTAX

### Standard (Default)
```
Get-vRAService [-Page <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### ById
```
Get-vRAService -Id <String[]> [<CommonParameters>]
```

### ByName
```
Get-vRAService -Name <String[]> [<CommonParameters>]
```

## DESCRIPTION
A service represents a customer-facing/user friendly set of activities.
In the context of this Service Catalog, 
these activities are the catalog items and resource actions. 
A service must be owned by a specific organization and all the activities it contains should belongs to the same organization.

## EXAMPLES

### EXAMPLE 1
```
Get-vRAService
```

### EXAMPLE 2
```
Get-vRAService -Id 332d38d5-c8db-4519-87a7-7ef9f358091a
```

### EXAMPLE 3
```
Get-vRAService -Name "Default Service"
```

## PARAMETERS

### -Id
The id of the service

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
The Name of the service

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

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
