# Request-vRACatalogItem

## SYNOPSIS
Request a vRA catalog item

## SYNTAX

### Standard (Default)
```
Request-vRACatalogItem -Id <String> [-RequestedFor <String>] [-Description <String>] [-Reasons <String>]
 [-Wait] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### JSON
```
Request-vRACatalogItem -JSON <String> [-Wait] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Request a vRA catalog item with a given request template payload. 

If the wait switch is passed the cmdlet will wait until the request has completed.
If successful informaiton
about the new resource will be returned

If no switch is passed then the request id will be returned

## EXAMPLES

### EXAMPLE 1
```
$Template = Get-vRAEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | Get-vRACatalogItemRequestTemplate
```

$Resource = Request-vRACatalogItem -JSON $Template -Wait -Verbose

### EXAMPLE 2
```
$Template = Get-vRAEntitledCatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" | Get-vRACatalogItemRequestTemplate
```

$RequestId = Request-vRACatalogItem -JSON $Template -Verbose

### EXAMPLE 3
```
Request-vRACatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e"
```

### EXAMPLE 4
```
Request-vRACatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Wait
```

### EXAMPLE 5
```
Request-vRACatalogItem -Id "dab4e578-57c5-4a30-b3b7-2a5cefa52e9e" -Description "Test" -Reasons "Test Reason"
```

## PARAMETERS

### -Id
The Id of the catalog item to request

```yaml
Type: String
Parameter Sets: Standard
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RequestedFor
The user principal that the request is for (e.g.
user@vsphere.local).
If not specified the current user is used

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

### -Description
A description for the request

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

### -Reasons
Reasons for the request

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

### -JSON
JSON string containing the request template

```yaml
Type: String
Parameter Sets: JSON
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Wait
Wait for the request to complete

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
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
