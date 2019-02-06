# Set-vRABusinessGroup

## SYNOPSIS
Update a vRA Business Group

## SYNTAX

### Standard (Default)
```
Set-vRABusinessGroup -TenantId <String> -ID <String> [-Name <String>] [-Description <String>]
 [-MachinePrefixId <String>] [-SendManagerEmailsTo <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### JSON
```
Set-vRABusinessGroup -TenantId <String> -ID <String> -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update a vRA Business Group

## EXAMPLES

### EXAMPLE 1
```
Set-vRABusinessGroup -TenantId Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7" -Name BusinessGroup01 -Description "Business Group 01" -MachinePrefixId "87e99513-cbea-4589-8678-c84c5907bdf2" -SendManagerEmailsTo "busgroupmgr01@vrademo.local"
```

### EXAMPLE 2
```
$JSON = @"
```

{
    "id": "f8e0d99e-c567-4031-99cb-d8410c841ed7",
    "name": "BusinessGroup01",
    "description": "Business Group 01",
    "extensionData": {
    "entries": \[
        {
        "key": "iaas-machine-prefix",
        "value": {
            "type": "string",
            "value": "87e99513-cbea-4589-8678-c84c5907bdf2"
        }
        },
        {
        "key": "iaas-manager-emails",
        "value": {
            "type": "string",
            "value": "busgroupmgr01@vrademo.local"
        }
        }
    \]
    },
    "tenant": "Tenant01"
}
"@
$JSON | Set-vRABusinessGroup -ID Tenant01 -Id "f8e0d99e-c567-4031-99cb-d8410c841ed7"

## PARAMETERS

### -TenantId
Tenant ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
Business Group ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Business Group Name

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
Business Group Description

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

### -MachinePrefixId
Machine Prefix Id

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

### -SendManagerEmailsTo
Send Manager Emails To

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
Body text to send in JSON format

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

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
