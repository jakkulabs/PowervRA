# Set-vRATenant

## SYNOPSIS
Update a vRA Tenant

## SYNTAX

### Standard (Default)
```
Set-vRATenant -Name <String> [-Description <String>] [-ContactEmail <String>] -ID <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### JSON
```
Set-vRATenant -JSON <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update a vRA Tenant

## EXAMPLES

### EXAMPLE 1
```
Set-vRATenant -Name Tenant01 -Description "This is the updated description" -ID Tenant01
```

### EXAMPLE 2
```
$JSON = @"
```

{
  "name" : "Tenant02",
  "description" : "This is the updated description for Tenant02",
  "urlName" : "Tenant02",
  "contactEmail" : "test.user@tenant02.local",
  "id" : "Tenant02",
  "defaultTenant" : false,
  "password" : ""
}
"@
$JSON | Set-vRATenant

## PARAMETERS

### -Name
Tenant Name

```yaml
Type: String
Parameter Sets: Standard
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Tenant Description

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

### -ContactEmail
Tenant Contact Email

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

### -ID
Tenant ID

```yaml
Type: String
Parameter Sets: Standard
Aliases:

Required: True
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
