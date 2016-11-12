---
external help file: Get-vRAUserPrincipal-help.xml
online version: 
schema: 2.0.0
---

# Get-vRAUserPrincipal

## SYNOPSIS
Finds regular users

## SYNTAX

### Standard (Default)
```
Get-vRAUserPrincipal [-Tenant <String>] [-LocalUsersOnly] [-Limit <String>]
```

### byId
```
Get-vRAUserPrincipal -Id <String[]> [-Tenant <String>]
```

## DESCRIPTION
Finds regular users in one of the identity providers configured for the tenant.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-vRAUserPrincipal
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-vRAUserPrincipal -LocalUsersOnly
```

### -------------------------- EXAMPLE 3 --------------------------
```
Get-vRAUserPrincipal -Id user@vsphere.local
```

### -------------------------- EXAMPLE 4 --------------------------
```
Get-vRAUserPrincipal -UserName user@vsphere.local
```

### -------------------------- EXAMPLE 5 --------------------------
```
Get-vRAUserPrincipal -PrincipalId user@vsphere.local
```

## PARAMETERS

### -Id
The Id of the user

```yaml
Type: String[]
Parameter Sets: byId
Aliases: UserName, PrincipalId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
The tenant of the user

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

### -LocalUsersOnly
Only return local users

```yaml
Type: SwitchParameter
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The number of entries returned per page from the API.
This has a default value of 100.

```yaml
Type: String
Parameter Sets: Standard
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Management.Automation.PSObject.

## NOTES

## RELATED LINKS

