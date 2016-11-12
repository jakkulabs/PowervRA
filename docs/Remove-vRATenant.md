# Remove-vRATenant

## SYNOPSIS
Remove a vRA Tenant

## SYNTAX

```
Remove-vRATenant [-Id] <String[]> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a vRA Tenant

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRATenant -Id Tenant02
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRATenant -Id Tenant02 | Remove-vRATenant -Confirm:$false
```

## PARAMETERS

### -Id
Tenant ID

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
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

