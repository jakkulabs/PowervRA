# Get-vRAResource

## SYNOPSIS
Get a deployed resource

## SYNTAX

### Standard (Default)
```
Get-vRAResource [-Type <String>] [-WithExtendedData] [-WithOperations] [-ManagedOnly] [-Limit <Int32>]
 [-Page <Int32>] [<CommonParameters>]
```

### ById
```
Get-vRAResource -Id <String[]> [<CommonParameters>]
```

### ByName
```
Get-vRAResource -Name <String[]> [<CommonParameters>]
```

## DESCRIPTION
A deployment represents a collection of deployed artifacts that have been provisioned by a provider.

## EXAMPLES

### EXAMPLE 1
```
Get-vRAResource
```

### EXAMPLE 2
```
Get-vRAResource -WithExtendedData
```

### EXAMPLE 3
```
Get-vRAResource -WithOperations
```

### EXAMPLE 4
```
Get-vRAResource -Id "6195fd70-7243-4dc9-b4f3-4b2300e15ef8"
```

### EXAMPLE 5
```
Get-vRAResource -Name "CENTOS-555667"
```

## PARAMETERS

### -Id
The id of the resource

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
The Name of the resource

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

### -Type
Show resources that match a certain type.

Supported types ar:

    Deployment,
    Machine

```yaml
Type: String
Parameter Sets: Standard
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithExtendedData
Populate the resources extended data by calling their provider

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WithOperations
Populate the resources operations attribute by calling the provider.
This will force withExtendedData to true.

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagedOnly
Show resources owned by the users managed business groups, excluding any machines owned by the user in a non-managed
business group

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases:

Required: False
Position: Named
Default value: False
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

### -Page
The index of the page to display

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.Int
Switch

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS
