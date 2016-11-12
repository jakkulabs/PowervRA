---
external help file: Remove-vRAGroupPrincipal-help.xml
online version: 
schema: 2.0.0
---

# Remove-vRAGroupPrincipal

## SYNOPSIS
Remove a vRA custom group

## SYNTAX

```
Remove-vRAGroupPrincipal -Id <String[]> [-Tenant <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a vRA custom group

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRAGroupPrincipal -PrincipalId Group@Tenant
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAGroupPrincipal -Id Group@Tenant | Remove-vRAGroupPrincipal
```

## PARAMETERS

### -Id
The principal id of the custom group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrincipalId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tenant
The tenant of the group

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: $Global:vRAConnection.Tenant
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

### System.String.

## OUTPUTS

### None

## NOTES

## RELATED LINKS

