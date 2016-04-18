# Get-vRATenantRole

## SYNOPSIS
    
Retrieve vRA Tenant Role

## SYNTAX
 Get-vRATenantRole [-TenantId] <String> [-PrincipalId] <String[]> [[-Limit] <String>] [<CommonParameters>]    

## DESCRIPTION

Retrieve vRA Tenant Role

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
* Accept pipeline input: false

### Limit

The number of entries returned per page from the API. This has a default value of 100.

* Required: false
* Position: 3
* Default value: 100
* Accept pipeline input: false

## INPUTS

System.String

## OUTPUTS

System.Management.Automation.PSObject.

## EXAMPLES
```
-------------------------- EXAMPLE 1 --------------------------

PS C:\>Get-vRATenantRole -TenantId Tenant01 -PrincipalId Tenantadmin@vrademo.local
```

