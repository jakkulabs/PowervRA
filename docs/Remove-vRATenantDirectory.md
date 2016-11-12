# Remove-vRATenantDirectory

## SYNOPSIS
Remove a vRA Tenant Directory

## SYNTAX

```
Remove-vRATenantDirectory [-Id] <String> [-Domain] <String> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a vRA Tenant Directory

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRATenantDirectory -Id Tenant01 -Domain vrademo.local
```

### -------------------------- EXAMPLE 2 --------------------------
```
$Id = "Tenant01"
```

Get-vRATenantDirectory -Id $Id | Remove-vRATenantDirectory -Id $Id -Confirm:$false

## PARAMETERS

### -Id
Tenant Id

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Tenant Directory Domain

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### None

## NOTES

## RELATED LINKS

