# New-vRAGroupPrincipal

## SYNOPSIS
Create a vRA custom group

## SYNTAX

### Standard (Default)
```
New-vRAGroupPrincipal [-Tenant <String>] -Name <String> [-Description <String>] [-WhatIf] [-Confirm]
```

### JSON
```
New-vRAGroupPrincipal -JSON <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Create a vRA Principal (user)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-vRAGroupPrincipal -Name TestGroup01 -Description "Test Group 01"
```

### -------------------------- EXAMPLE 2 --------------------------
```
$JSON = @"
```

{
        "@type": "Group",
        "groupType": "CUSTOM",
        "name": "TestGroup01",
        "fqdn": "TestGroup01@Tenant",
        "domain": "Tenant",
        "description": "Test Group 01",
        "principalId": {
            "domain": "Tenant",
            "name": "TestGroup01"
        }
    }
"@

## PARAMETERS

### -Tenant
The tenant of the group

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: $Global:vRAConnection.Tenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Group name

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
A description for the group

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

## INPUTS

### System.String.

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

