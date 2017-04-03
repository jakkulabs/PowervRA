# Remove-vRAPropertyDefinition

## SYNOPSIS
Removes a Property Definiton from the specified tenant

## SYNTAX

```
Remove-vRAPropertyDefinition [-Id] <String> [[-Tenant] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Uses the REST API to delete a property definiton based on the Id supplied.
If the Tenant is supplied it will delete the property for that tenant only.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Remove the property "Hostname"
```

Remove-vRAPropertyDefinition -Id Hostname

### -------------------------- EXAMPLE 2 --------------------------
```
# Remove the property "Hostname" from the tenant "Development"
```

Get-vRAPropertyDefinition -Id "Hostname" -Tenant Development

## PARAMETERS

### -Id
The id of the property definition to delete

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tenant
The tenant of the property definition to delete

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
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

## INPUTS

### System.String

## OUTPUTS

### None

## NOTES

## RELATED LINKS

