# Add-vRAPrincipalToTenantRole

## SYNOPSIS
    
Add a vRA Principal to a Tenant Role

## SYNTAX
 Add-vRAPrincipalToTenantRole [-TenantId] <String> [-PrincipalId] <String[]> [-RoleId] <String> [-WhatIf] [-Confirm]  [<CommonParameters>]    

## DESCRIPTION

Add a vRA Principal to a Tenant Role

## PARAMETERS


### TenantId

Specify the Tenant Id

* Required: true
* Position: 1
* Default value: 
* Accept pipeline input: false

### PrincipalId

Specify the Principal Id

* Required: true
* Position: 2
* Default value: 
* Accept pipeline input: true (ByValue, ByPropertyName)

### RoleId

Specify the Role Id

* Required: true
* Position: 3
* Default value: 
* Accept pipeline input: false

### WhatIf


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

### Confirm


* Required: false
* Position: named
* Default value: 
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Add-vRAPrincipalToTenantRole -TenantId Tenant01 -PrincipalId Tenantadmin@vrademo.local -RoleId CSP_TENANT_ADMIN







-------------------------- EXAMPLE 2 --------------------------

PS C:\>Get-vRAUserPrincipal -UserName Tenantadmin@vrademo.local | Add-vRAPrincipalToTenantRole -TenantId Tenant01 
-RoleId CSP_TENANT_ADMIN
```

