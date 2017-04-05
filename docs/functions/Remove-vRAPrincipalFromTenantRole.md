# Remove-vRAPrincipalFromTenantRole

## SYNOPSIS
Remove a vRA Principal from a Tenant Role

## SYNTAX

```
Remove-vRAPrincipalFromTenantRole [-TenantId] <String> [-PrincipalId] <String[]> [-RoleId] <String> [-WhatIf]
 [-Confirm]
```

## DESCRIPTION
Remove a vRA Principal from a Tenant Role

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-vRAPrincipalFromTenantRole -TenantId Tenant01 -PrincipalId Tenantadmin@vrademo.local -RoleId CSP_TENANT_ADMIN
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAUserPrincipal -UserName Tenantadmin@vrademo.local | Remove-vRAPrincipalFromTenantRole -TenantId Tenant01 -RoleId CSP_TENANT_ADMIN
```

## PARAMETERS

### -TenantId
Specify the Tenant Id

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

### -PrincipalId
Specify the Principal Id

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -RoleId
Specify the Role Id

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
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

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

