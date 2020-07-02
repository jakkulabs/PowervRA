# Get-vRABusinessGroup

## SYNOPSIS
Retrieve vRA Business Groups

## SYNTAX

```
Get-vRABusinessGroup [[-TenantId] <String>] [[-Name] <String[]>] [[-Limit] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve vRA Business Groups

## EXAMPLES

### EXAMPLE 1
```
Get-vRABusinessGroup
```

### EXAMPLE 2
```
Get-vRABusinessGroup -TenantId Tenant01 -Name BusinessGroup01,BusinessGroup02
```

## PARAMETERS

### -TenantId
Specify the ID of a Tenant

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specify the Name of a Business Group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
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
Position: 3
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
