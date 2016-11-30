# Remove-vRAUserPrincipal

## SYNOPSIS
Remove a vRA local user principal

## SYNTAX

```
Remove-vRAUserPrincipal [-Id] <String[]> [[-Tenant] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Remove a vRA local user principal

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRAUserPrincipal -PrincipalId user@vsphere.local
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAUserPrincipal -Id user@vsphere.local | Remove-vRAUserPrincipal
```

## PARAMETERS

### -Id
The principal id of the user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrincipalId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tenant
The tenant of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
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

